package com.chapterhive.backend.controller

import com.chapterhive.backend.model.User
import com.chapterhive.backend.model.response.UserResponse
import com.chapterhive.backend.repository.UserRepository
import com.chapterhive.backend.security.JwtTokenProvider
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.Parameter
import io.swagger.v3.oas.annotations.tags.Tag
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.*

@Tag(name = "Users", description = "User profile management endpoints")
@RestController
@RequestMapping("/api/users")
class UserController(
    private val userRepository: UserRepository,
    private val jwtTokenProvider: JwtTokenProvider
) {

    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Get user profile", description = "Retrieves the user profile based on user ID")
    @GetMapping("/{userId}")
    fun getUserProfile(
        @PathVariable userId: String,
        @RequestHeader("Authorization") token: String
    ): ResponseEntity<UserResponse> {
        val email = jwtTokenProvider.getEmailFromToken(token.substring(7))
        val user = userRepository.findByEmail(email) ?: return ResponseEntity.status(403).build()

        if (user.id != userId && user.role != User.Role.ADMIN) {
            return ResponseEntity.status(403).build()
        }

        return ResponseEntity.ok(user.toResponse())
    }

    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Update user profile", description = "Allows a user to update their profile details")
    @PutMapping("/{userId}")
    fun updateUserProfile(
        @Parameter(description = "User ID of the profile to update") @PathVariable userId: String,
        @RequestBody updatedUser: User,
        @RequestHeader("Authorization") token: String
    ): ResponseEntity<User> {
        val email = jwtTokenProvider.getEmailFromToken(token.substring(7))
        val user = userRepository.findByEmail(email) ?: return ResponseEntity.status(403).build()

        if (user.id != userId) {
            return ResponseEntity.status(403).build()
        }

        val updatedProfile = user.copy(
            username = updatedUser.username,
            profilePicture = updatedUser.profilePicture
        )
        return ResponseEntity.ok(userRepository.save(updatedProfile))
    }

    // TODO
    @Operation(summary = "Get reading progress", description = "Fetches a list of books the user is currently reading")
    @GetMapping("/{userId}/progress")
    fun getReadingProgress(
        @PathVariable userId: String
    ): ResponseEntity<List<String>> {
        val user = userRepository.findById(userId)
        return if (user.isPresent) {
            ResponseEntity.ok(user.get().readingProgress.map { it.book.title })
        } else {
            ResponseEntity.notFound().build()
        }
    }
}
