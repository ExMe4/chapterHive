package com.chapterhive.backend.controller

import com.chapterhive.backend.security.GoogleTokenVerifier
import com.chapterhive.backend.security.JwtTokenProvider
import com.chapterhive.backend.service.AuthService
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

data class GoogleLoginRequest(val idToken: String)
data class AuthResponse(val token: String)

@Tag(name = "Authentication", description = "Handles authentication using Google OAuth")
@RestController
@RequestMapping("/api/auth")
class AuthController(
    private val googleTokenVerifier: GoogleTokenVerifier,
    private val authService: AuthService,
    private val jwtTokenProvider: JwtTokenProvider
) {
    @Operation(summary = "Login with Google", description = "Authenticates a user using a Google ID token and returns a JWT token.")
    @PostMapping("/google-login")
    fun googleLogin(@RequestBody request: GoogleLoginRequest): ResponseEntity<Any> {
        val tokenPayload = googleTokenVerifier.verifyGoogleIdToken(request.idToken)
            ?: return ResponseEntity.badRequest().body("Invalid Google ID Token")

        val email = tokenPayload["email"] as String
        val username = tokenPayload["name"] as? String
        val profilePicture = tokenPayload["picture"] as? String

        val user = authService.findOrCreateUser(email, username, profilePicture)

        val token = jwtTokenProvider.generateToken(user.email, user.role.name)

        return ResponseEntity.ok(AuthResponse(token))
    }
}
