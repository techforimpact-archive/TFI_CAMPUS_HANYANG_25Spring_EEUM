package com.dingdong.eeum.filter;

import com.dingdong.eeum.service.JwtService;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.MalformedJwtException;
import io.jsonwebtoken.security.SignatureException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Component
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtService jwtService;
    private final ObjectMapper objectMapper = new ObjectMapper();

    private static final String AUTHORIZATION_HEADER = "Authorization";
    private static final String BEARER_PREFIX = "Bearer ";

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {

        try {
            String token = getTokenFromRequest(request);

            if (StringUtils.hasText(token)) {
                try {
                    if (jwtService.validateToken(token)) {
                        String userId = jwtService.getUserIdFromToken(token);
                        String userRole = jwtService.getUserRoleFromToken(token);

                        List<GrantedAuthority> authorities = new ArrayList<>();
                        if (StringUtils.hasText(userRole)) {
                            authorities.add(new SimpleGrantedAuthority("ROLE_" + userRole));
                        } else {
                            authorities.add(new SimpleGrantedAuthority("ROLE_GUEST"));
                        }

                        UsernamePasswordAuthenticationToken authentication =
                                new UsernamePasswordAuthenticationToken(userId, null, authorities);
                        authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                        SecurityContextHolder.getContext().setAuthentication(authentication);
                    } else {
                        request.setAttribute("jwt.error", "INVALID_TOKEN");
                    }
                } catch (ExpiredJwtException e) {
                    request.setAttribute("jwt.error", "EXPIRED_TOKEN");
                } catch (MalformedJwtException e) {
                    request.setAttribute("jwt.error", "MALFORMED_TOKEN");
                } catch (SignatureException e) {
                    request.setAttribute("jwt.error", "INVALID_SIGNATURE");
                } catch (Exception e) {
                    request.setAttribute("jwt.error", "TOKEN_ERROR");
                }
            }

        } catch (Exception e) {
            request.setAttribute("jwt.error", "FILTER_ERROR");
        }

        filterChain.doFilter(request, response);
    }

    private String getTokenFromRequest(HttpServletRequest request) {
        String bearerToken = request.getHeader(AUTHORIZATION_HEADER);

        if (StringUtils.hasText(bearerToken)) {
            if (bearerToken.startsWith(BEARER_PREFIX)) {
                return bearerToken.substring(BEARER_PREFIX.length());
            } else {
                throw new IllegalArgumentException("Bearer prefix missing");
            }
        }

        return null;
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        String path = request.getRequestURI();

        boolean skip = path.startsWith("/v1/auth/") ||
                path.startsWith("/swagger-ui/") ||
                path.startsWith("/v3/api-docs/") ||
                path.equals("/favicon.ico") ||
                path.equals("/") ||
                path.startsWith("/actuator/");

        if (skip) {
            log.debug("JWT 필터 스킵: {}", path);
        }

        return skip;
    }
}
