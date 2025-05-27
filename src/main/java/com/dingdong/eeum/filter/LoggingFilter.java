package com.dingdong.eeum.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.util.ContentCachingRequestWrapper;
import org.springframework.web.util.ContentCachingResponseWrapper;

import java.io.IOException;
import java.util.Collections;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

@Slf4j
@Component
@Order(Ordered.HIGHEST_PRECEDENCE)
public class LoggingFilter implements Filter {

    private static final String REQUEST_ID_HEADER = "X-Request-ID";

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        if (shouldSkipLogging(httpRequest.getRequestURI())) {
            chain.doFilter(request, response);
            return;
        }

        String requestId = generateRequestId();
        httpResponse.setHeader(REQUEST_ID_HEADER, requestId);

        ContentCachingRequestWrapper wrappedRequest = new ContentCachingRequestWrapper(httpRequest);
        ContentCachingResponseWrapper wrappedResponse = new ContentCachingResponseWrapper(httpResponse);

        long startTime = System.currentTimeMillis();

        try {
            logRequest(wrappedRequest, requestId);

            chain.doFilter(wrappedRequest, wrappedResponse);

            logResponse(wrappedRequest, wrappedResponse, requestId, startTime);

        } catch (Exception e) {
            logError(wrappedRequest, requestId, e, startTime);
            throw e;
        } finally {
            wrappedResponse.copyBodyToResponse();
        }
    }

    private void logRequest(ContentCachingRequestWrapper request, String requestId) {
        String uri = request.getRequestURI();
        String method = request.getMethod();
        String queryString = request.getQueryString();
        String clientIp = getClientIp(request);

        log.info("REQUEST [{}] {} {} {} - Client IP: {}",
                requestId, method, uri,
                StringUtils.hasText(queryString) ? "?" + queryString : "",
                clientIp);

        Map<String, String> headers = Collections.list(request.getHeaderNames())
                .stream()
                .filter(this::isLoggableHeader)
                .collect(Collectors.toMap(
                        headerName -> headerName,
                        request::getHeader
                ));

        if (!headers.isEmpty()) {
            log.debug("HEADERS [{}] Request Headers: {}", requestId, headers);
        }

        if (isJsonContent(request.getContentType())) {
            String body = getRequestBody(request);
            if (StringUtils.hasText(body) && body.length() < 1000) {
                log.debug("BODY [{}] Request Body: {}", requestId, body);
            }
        }
    }

    private void logResponse(ContentCachingRequestWrapper request,
                             ContentCachingResponseWrapper response,
                             String requestId, long startTime) {

        long duration = System.currentTimeMillis() - startTime;
        int status = response.getStatus();
        String method = request.getMethod();
        String uri = request.getRequestURI();

        String statusLevel = getStatusLevel(status);

        log.info("RESPONSE [{}] {} {} - {} {} ({}ms)",
                requestId, method, uri, status, statusLevel, duration);

        if (status >= 400 && isJsonContent(response.getContentType())) {
            String responseBody = getResponseBody(response);
            if (StringUtils.hasText(responseBody) && responseBody.length() < 1000) {
                log.warn("ERROR_BODY [{}] Response Body: {}", requestId, responseBody);
            }
        }

        if (duration > 3000) {
            log.warn("SLOW_REQUEST [{}] {} {} took {}ms", requestId, method, uri, duration);
        }
    }

    private void logError(ContentCachingRequestWrapper request, String requestId, Exception e, long startTime) {
        long duration = System.currentTimeMillis() - startTime;
        String method = request.getMethod();
        String uri = request.getRequestURI();

        log.error("ERROR [{}] {} {} - Error after {}ms: {}",
                requestId, method, uri, duration, e.getMessage());
    }

    private String generateRequestId() {
        return UUID.randomUUID().toString().substring(0, 8);
    }

    private String getClientIp(HttpServletRequest request) {
        String xForwardedFor = request.getHeader("X-Forwarded-For");
        if (StringUtils.hasText(xForwardedFor)) {
            return xForwardedFor.split(",")[0].trim();
        }

        String xRealIp = request.getHeader("X-Real-IP");
        if (StringUtils.hasText(xRealIp)) {
            return xRealIp;
        }

        return request.getRemoteAddr();
    }

    private boolean shouldSkipLogging(String uri) {
        return uri.startsWith("/actuator/") ||
                uri.startsWith("/swagger-ui/") ||
                uri.startsWith("/v3/api-docs/") ||
                uri.equals("/favicon.ico") ||
                uri.endsWith(".css") ||
                uri.endsWith(".js") ||
                uri.endsWith(".png") ||
                uri.endsWith(".jpg") ||
                uri.endsWith(".ico");
    }

    private boolean isLoggableHeader(String headerName) {
        String lowerCaseName = headerName.toLowerCase();
        return !lowerCaseName.contains("authorization") &&
                !lowerCaseName.contains("cookie") &&
                !lowerCaseName.contains("password") &&
                !lowerCaseName.contains("token");
    }

    private boolean isJsonContent(String contentType) {
        return contentType != null && contentType.contains("application/json");
    }

    private String getRequestBody(ContentCachingRequestWrapper request) {
        try {
            byte[] content = request.getContentAsByteArray();
            if (content.length > 0) {
                return new String(content, request.getCharacterEncoding());
            }
        } catch (Exception e) {
            log.debug("Request body를 읽을 수 없음: {}", e.getMessage());
        }
        return "";
    }

    private String getResponseBody(ContentCachingResponseWrapper response) {
        try {
            byte[] content = response.getContentAsByteArray();
            if (content.length > 0) {
                return new String(content, response.getCharacterEncoding());
            }
        } catch (Exception e) {
            log.debug("Response body를 읽을 수 없음: {}", e.getMessage());
        }
        return "";
    }

    private String getStatusLevel(int status) {
        if (status >= 500) return "SERVER_ERROR";
        if (status >= 400) return "CLIENT_ERROR";
        if (status >= 300) return "REDIRECT";
        return "SUCCESS";
    }
}
