package com.chapterhive.backend.controller

import com.chapterhive.backend.model.User
import com.chapterhive.backend.security.JwtTokenProvider
import com.chapterhive.backend.service.AuthService
import com.chapterhive.backend.service.OAuthUser
import org.junit.jupiter.api.Test
import org.mockito.BDDMockito.*
import org.mockito.kotlin.anyOrNull
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest
import org.springframework.boot.test.context.TestConfiguration
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Import
import org.springframework.http.MediaType
import org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post
import org.springframework.test.web.servlet.result.MockMvcResultMatchers.*

@WebMvcTest(
    controllers = [AuthController::class],
    excludeAutoConfiguration = [
        SecurityAutoConfiguration::class,
        org.springframework.boot.autoconfigure.security.oauth2.client.servlet.OAuth2ClientAutoConfiguration::class,
        org.springframework.boot.autoconfigure.security.oauth2.resource.servlet.OAuth2ResourceServerAutoConfiguration::class
    ]
)
@Import(AuthControllerTest.MockConfig::class)
class AuthControllerTest {

    @Autowired
    lateinit var mockMvc: MockMvc

    @Autowired
    lateinit var authService: AuthService

    @Autowired
    lateinit var jwtTokenProvider: JwtTokenProvider

    companion object {
        val testUser = User(
            id = "123",
            email = "test@example.com",
            username = "Test User",
            profilePicture = "http://example.com/pic.jpg",
            provider = User.Provider.GOOGLE,
            role = User.Role.USER
        )
    }

    @TestConfiguration
    class MockConfig {
        @Bean
        fun authService(): AuthService = mock(AuthService::class.java)

        @Bean
        fun jwtTokenProvider(): JwtTokenProvider = mock(JwtTokenProvider::class.java)
    }

    @Test
    fun shouldReturnJWTAndUserOnSuccessfulGoogleLogin() {
        val token = "valid-google-token"
        val provider = "google"

        val verifiedUser = OAuthUser(
            id = "123",
            email = testUser.email,
            username = testUser.username,
            profilePicture = testUser.profilePicture
        )

        given(authService.verifyGoogleToken(token)).willReturn(verifiedUser)
        given(
            authService.findOrCreateUser(
                anyOrNull(), anyOrNull(), anyOrNull(), anyOrNull(), anyOrNull()
            )
        ).willReturn(testUser)
        given(jwtTokenProvider.generateToken(testUser.id, testUser.role.name)).willReturn("jwt-token")

        mockMvc.perform(
            post("/api/auth/login")
                .param("token", token)
                .param("provider", provider)
                .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                .with(csrf())
        )
            .andExpect(status().isOk)
            .andExpect(jsonPath("$.token").value("jwt-token"))
            .andExpect(jsonPath("$.user.email").value(testUser.email))
            .andExpect(jsonPath("$.user.username").value(testUser.username))
    }

    @Test
    fun shouldReturn400ForInvalidProvider() {
        mockMvc.perform(
            post("/api/auth/login")
                .param("token", "some-token")
                .param("provider", "unknown")
                .with(csrf())
        )
            .andExpect(status().isBadRequest)
            .andExpect(jsonPath("$.error").value("Invalid provider"))
    }

    @Test
    fun shouldReturn401IfTokenVerificationFails() {
        given(authService.verifyGoogleToken("bad-token")).willReturn(null)

        mockMvc.perform(
            post("/api/auth/login")
                .param("token", "bad-token")
                .param("provider", "google")
                .with(csrf())
        )
            .andExpect(status().isUnauthorized)
            .andExpect(jsonPath("$.error").value("Invalid token"))
    }
}
