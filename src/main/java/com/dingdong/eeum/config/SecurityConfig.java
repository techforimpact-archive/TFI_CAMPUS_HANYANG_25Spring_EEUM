package com.dingdong.eeum.config;

import com.dingdong.eeum.apiPayload.code.status.ErrorStatus;
import com.dingdong.eeum.apiPayload.exception.response.Response;
import com.dingdong.eeum.filter.JwtAuthenticationFilter;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Slf4j
@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtAuthenticationFilter;
    private final ObjectMapper objectMapper;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public AccessDeniedHandler accessDeniedHandler() {
        return (request, response, accessDeniedException) -> {

            response.setStatus(403);
            response.setContentType("application/json;charset=UTF-8");

            Response<Void> errorResponse = new Response<>(
                    false,
                    ErrorStatus._FORBIDDEN.getCode(),
                    ErrorStatus._FORBIDDEN.getMessage(),
                    null
            );

            String jsonResponse = objectMapper.writeValueAsString(errorResponse);
            response.getWriter().write(jsonResponse);
        };
    }

    @Bean
    public AuthenticationEntryPoint authenticationEntryPoint() {
        return (request, response, authException) -> {

            String jwtError = (String) request.getAttribute("jwt.error");
            ErrorStatus errorStatus;

            switch (jwtError != null ? jwtError : "DEFAULT") {
                case "EXPIRED_TOKEN":
                    errorStatus = ErrorStatus.AUTH_TOKEN_EXPIRED;
                    break;
                case "INVALID_TOKEN":
                    errorStatus = ErrorStatus.AUTH_TOKEN_INVALID;
                    break;
                case "MALFORMED_TOKEN":
                    errorStatus = ErrorStatus.AUTH_TOKEN_MALFORMED;
                    break;
                case "INVALID_SIGNATURE":
                    errorStatus = ErrorStatus.AUTH_TOKEN_SIGNATURE_INVALID;
                    break;
                case "TOKEN_ERROR":
                    errorStatus = ErrorStatus.AUTH_TOKEN_ERROR;
                    break;
                case "FILTER_ERROR":
                    errorStatus = ErrorStatus.AUTH_FILTER_ERROR;
                    break;
                default:
                    errorStatus = ErrorStatus._UNAUTHORIZED;
                    break;
            }

            response.setStatus(errorStatus.getHttpStatus().value());
            response.setContentType("application/json;charset=UTF-8");

            Response<Void> errorResponse = new Response<>(
                    false,
                    errorStatus.getCode(),
                    errorStatus.getMessage(),
                    null
            );

            String jsonResponse = objectMapper.writeValueAsString(errorResponse);
            response.getWriter().write(jsonResponse);
        };
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf(AbstractHttpConfigurer::disable)

                .exceptionHandling(exceptions -> exceptions
                        .accessDeniedHandler(accessDeniedHandler())
                        .authenticationEntryPoint(authenticationEntryPoint())
                )

                .sessionManagement(session ->
                        session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))

                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/v1/auth/**").permitAll()
                        .requestMatchers("/swagger-ui/**", "/v3/api-docs/**").permitAll()
                        .requestMatchers("/actuator/**").permitAll()
                        .requestMatchers("/v1/user/qr").hasAnyRole("GUEST")
                        .anyRequest().hasAnyRole("USER", "ADMIN")
                )

                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}
