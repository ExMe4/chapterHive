package com.chapterhive.backend.service

import com.chapterhive.backend.model.User
import com.chapterhive.backend.repository.UserRepository
import org.springframework.stereotype.Service

@Service
class AuthService(private val userRepository: UserRepository) {

    fun findOrCreateUser(email: String, username: String?, profilePicture: String?): User {
        val existingUser = userRepository.findByEmail(email)
        return existingUser ?: userRepository.save(
            User(
                email = email,
                username = username,
                profilePicture = profilePicture,
                role = User.Role.USER // Default to USER role
            )
        )
    }
}
