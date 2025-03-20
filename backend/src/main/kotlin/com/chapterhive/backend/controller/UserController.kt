package com.chapterhive.backend.controller

import com.chapterhive.backend.model.User
import com.chapterhive.backend.repository.UserRepository
import com.chapterhive.backend.security.JwtTokenProvider
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.*
import java.util.*

@RestController
@RequestMapping("/api/users")
class UserController(
    private val userRepository: UserRepository,
    private val jwtTokenProvider: JwtTokenProvider
) {

    @PreAuthorize("isAuthenticated()")
    @GetMapping("/{userId}")
    fun getUserProfile(
        @PathVariable userId: UUID,
        @RequestHeader("Authorization") token: String
    ): ResponseEntity<User> {
        val email = jwtTokenProvider.getEmailFromToken(token.substring(7))
        val user = userRepository.findByEmail(email) ?: return ResponseEntity.status(403).build()

        if (user.id != userId && user.role != User.Role.ADMIN) {
            return ResponseEntity.status(403).build()
        }

        return ResponseEntity.ok(user)
    }

    @PreAuthorize("isAuthenticated()")
    @PutMapping("/{userId}")
    fun updateUserProfile(
        @PathVariable userId: UUID,
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

    @GetMapping("/{userId}/progress")
    fun getReadingProgress(@PathVariable userId: UUID): ResponseEntity<List<String>> {
        val user = userRepository.findById(userId)
        return if (user.isPresent) {
            ResponseEntity.ok(user.get().readingProgress.map { it.book.title })
        } else {
            ResponseEntity.notFound().build()
        }
    }
}
