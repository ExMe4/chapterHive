package com.chapterhive.backend.config

import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.security.config.annotation.web.builders.HttpSecurity
import org.springframework.security.oauth2.client.oidc.userinfo.OidcUserService
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService
import org.springframework.security.web.SecurityFilterChain

@Configuration
class SecurityConfig {

    @Bean
    fun securityFilterChain(http: HttpSecurity): SecurityFilterChain {
        http
            .csrf { it.disable() }
            .authorizeHttpRequests { auth ->
                auth
                    // .requestMatchers("/api/reviews/**").permitAll()
                    .anyRequest().permitAll() // permit all requests for now
            }
            .oauth2Login { oauth2 ->
                oauth2
                    .userInfoEndpoint { userInfo ->
                        userInfo
                            .oidcUserService(OidcUserService())  // For Google Web
                            .userService(DefaultOAuth2UserService())  // For Google Android/iOS
                    }
                    .loginPage("/login")
            }
        return http.build()
    }
}