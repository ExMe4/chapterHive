package com.chapterhive.backend.service

import com.chapterhive.backend.model.User
import com.chapterhive.backend.model.User.Provider
import com.chapterhive.backend.repository.UserRepository
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.extension.ExtendWith
import org.mockito.BDDMockito.*
import org.mockito.Mock
import org.mockito.junit.jupiter.MockitoExtension
import org.springframework.web.client.RestTemplate
import java.util.*
import kotlin.test.assertEquals
import kotlin.test.assertNotNull
import kotlin.test.assertNull

@ExtendWith(MockitoExtension::class)
class AuthServiceTest {

    @Mock
    lateinit var restTemplate: RestTemplate

    @Mock
    lateinit var userRepository: UserRepository

    lateinit var authService: AuthService

    @BeforeEach
    fun setUp() {
        authService = AuthService(restTemplate, userRepository)
    }

    @Test
    fun shouldReturnOAuthUserWhenTokenIsValid() {
        // given
        val token = "validToken"
        val jsonResponse = """
            {
                "sub": "12345",
                "email": "user@example.com",
                "name": "John Doe",
                "picture": "http://example.com/profile.jpg"
            }
        """.trimIndent()

        given(restTemplate.getForObject(anyString(), eq(String::class.java))).willReturn(jsonResponse)

        // when
        val result = authService.verifyGoogleToken(token)

        // then
        assertNotNull(result)
        assertEquals("12345", result.id)
        assertEquals("user@example.com", result.email)
        assertEquals("John Doe", result.username)
        assertEquals("http://example.com/profile.jpg", result.profilePicture)
    }

    @Test
    fun shouldReturnNullWhenTokenIsMissingFields() {
        // given
        val token = "invalidToken"
        val jsonResponse = """{ "sub": "12345" }""" // Missing email

        given(restTemplate.getForObject(anyString(), eq(String::class.java))).willReturn(jsonResponse)

        // when
        val result = authService.verifyGoogleToken(token)

        // then
        assertNull(result)
    }

    @Test
    fun shouldReturnNullWhenExceptionThrown() {
        // given
        val token = "crashToken"
        given(restTemplate.getForObject(anyString(), eq(String::class.java))).willThrow(RuntimeException("Google API error"))

        // when
        val result = authService.verifyGoogleToken(token)

        // then
        assertNull(result)
    }

    @Test
    fun shouldReturnExistingUserIfFound() {
        // given
        val user = User(
            id = "123",
            email = "existing@example.com",
            username = "existingUser",
            profilePicture = null,
            provider = Provider.GOOGLE,
            role = User.Role.USER
        )
        given(userRepository.findById("123")).willReturn(Optional.of(user))

        // when
        val result = authService.findOrCreateUser(
            id = "123",
            email = "existing@example.com",
            username = "existingUser",
            profilePicture = null,
            provider = "google"
        )

        // then
        assertEquals(user, result)
        verify(userRepository, never()).save(any())
    }

    @Test
    fun shouldCreateUserIfNotFound() {
        // given
        given(userRepository.findById("456")).willReturn(Optional.empty())

        val newUser = User(
            id = "456",
            email = "new@example.com",
            username = "newUser",
            profilePicture = "http://example.com/pic.jpg",
            provider = Provider.GOOGLE,
            role = User.Role.USER
        )

        given(userRepository.save(any(User::class.java))).willReturn(newUser)

        // when
        val result = authService.findOrCreateUser(
            id = "456",
            email = "new@example.com",
            username = "newUser",
            profilePicture = "http://example.com/pic.jpg",
            provider = "google"
        )

        // then
        assertNotNull(result)
        assertEquals("456", result.id)
        assertEquals("new@example.com", result.email)
        verify(userRepository).save(any(User::class.java))
    }
}
