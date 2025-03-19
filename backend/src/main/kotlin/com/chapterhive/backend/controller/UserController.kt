package com.chapterhive.backend.controller

import com.chapterhive.backend.model.User
import com.chapterhive.backend.repository.UserRepository
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import java.util.*

@RestController
@RequestMapping("/api/users")
class UserController(
    private val userRepository: UserRepository
) {

    @GetMapping("/{userId}")
    fun getUserProfile(@PathVariable userId: UUID): ResponseEntity<User> {
        val user = userRepository.findById(userId)
        return if (user.isPresent) ResponseEntity.ok(user.get()) else ResponseEntity.notFound().build()
    }

    @PutMapping("/{userId}")
    fun updateUserProfile(@PathVariable userId: UUID, @RequestBody updatedUser: User): ResponseEntity<User> {
        val existingUser = userRepository.findById(userId)
        if (existingUser.isEmpty) {
            return ResponseEntity.notFound().build()
        }

        val userToUpdate = existingUser.get().copy(
            username = updatedUser.username,
            profilePicture = updatedUser.profilePicture
        )
        return ResponseEntity.ok(userRepository.save(userToUpdate))
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
