package com.chapterhive.backend.controller

import com.chapterhive.backend.security.JwtTokenProvider
import com.chapterhive.backend.service.AuthService
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@Tag(name = "Authentication", description = "Handles authentication using Google OAuth")
@RestController
@RequestMapping("/api/auth")
class AuthController(
    private val authService: AuthService,
    private val jwtTokenProvider: JwtTokenProvider
) {

    @PostMapping("/login")
    @Operation(summary = "Login", description = "Allows user to login with Google or Apple")
    fun login(@RequestParam token: String, @RequestParam provider: String): Any? {
        println("Received login request for provider: $provider")
        println("Token (shortened): ${token.take(30)}...")

        val verifiedUser = when (provider.lowercase()) {
            "google" -> {
                println("Verifying Google token")
                authService.verifyGoogleToken(token)
            }
            "apple" -> authService.verifyAppleToken(token)
            else -> {
                println("Invalid provider: $provider")
                return ResponseEntity.badRequest().body(mapOf("error" to "Invalid provider"))
            }
        }

        if (verifiedUser == null) {
            println("Token verification failed")
            return ResponseEntity.status(401).body(mapOf("error" to "Invalid token"))
        }

        println("Token verified: ${verifiedUser.email}")

        val user = authService.findOrCreateUser(
            verifiedUser.id,
            verifiedUser.email,
            verifiedUser.username,
            verifiedUser.profilePicture,
            provider
        )

        val jwt = jwtTokenProvider.generateToken(user.email, user.role.name)
        println("Generated JWT for ${user.email}")

        return ResponseEntity.ok(
            mapOf(
                "token" to jwt,
                "user" to user.toResponse()
            )
        )
    }

}
