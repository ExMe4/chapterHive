package com.chapterhive.backend.model

import jakarta.persistence.*
import java.util.*

@Entity
@Table(name = "users")
data class User(
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    val id: UUID? = null,

    @Column(unique = true, nullable = false)
    val email: String,

    val username: String? = null,
    val password: String? = null,
    val profilePicture: String? = null,
    val provider: String = "google", // Mark user as a Google user

    @Enumerated(EnumType.STRING)
    val role: Role = Role.USER, // Default role is USER

    @OneToMany(mappedBy = "user", cascade = [CascadeType.ALL], fetch = FetchType.LAZY)
    val readingProgress: List<ReadingProgress> = mutableListOf()
) {
    enum class Role {
        ADMIN, USER
    }
}
