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
        val verifiedUser = when (provider.lowercase()) {
            "google" -> authService.verifyGoogleToken(token)
            "apple" -> authService.verifyAppleToken(token)
            else -> return ResponseEntity.badRequest().body(mapOf("error" to "Invalid provider"))
        }

        verifiedUser?.let {
            val user = authService.findOrCreateUser(it.email, it.username, it.profilePicture, provider)
            val jwt = jwtTokenProvider.generateToken(user.email, user.role.name)
            return ResponseEntity.ok(
                mapOf(
                    "token" to jwt,
                    "user" to user.toResponse()
                )
            ).toString()
        }

        return ResponseEntity.status(401).body(mapOf("error" to "Invalid token"))
    }
}
