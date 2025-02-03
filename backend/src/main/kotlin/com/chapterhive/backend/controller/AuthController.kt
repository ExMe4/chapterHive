package com.chapterhive.backend.controller

import com.chapterhive.backend.security.GoogleTokenVerifier
import com.chapterhive.backend.security.JwtTokenProvider
import com.chapterhive.backend.service.AuthService
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

data class GoogleLoginRequest(val idToken: String)
data class AuthResponse(val token: String)

@RestController
@RequestMapping("/api/auth")
class AuthController(
    private val googleTokenVerifier: GoogleTokenVerifier,
    private val authService: AuthService,
    private val jwtTokenProvider: JwtTokenProvider
) {

    @PostMapping("/google-login")
    fun googleLogin(@RequestBody request: GoogleLoginRequest): ResponseEntity<Any> {
        val tokenPayload = googleTokenVerifier.verifyGoogleIdToken(request.idToken)
            ?: return ResponseEntity.badRequest().body("Invalid Google ID Token")

        val email = tokenPayload["email"] as String
        val username = tokenPayload["name"] as? String
        val profilePicture = tokenPayload["picture"] as? String

        val user = authService.findOrCreateUser(email, username, profilePicture)

        val token = jwtTokenProvider.generateToken(user.email)

        return ResponseEntity.ok(AuthResponse(token))
    }
}
