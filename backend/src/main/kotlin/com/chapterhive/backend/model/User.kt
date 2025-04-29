package com.chapterhive.backend.model

import com.chapterhive.backend.model.response.UserResponse
import jakarta.persistence.*
import java.time.LocalDateTime

@Entity
@Table(name = "users")
data class User(
    @Id
    val id: String,

    @Column(unique = true, nullable = false)
    val email: String,

    val username: String? = null,
    val profilePicture: String? = null,

    @Enumerated(EnumType.STRING)
    val provider: Provider,

    @Enumerated(EnumType.STRING)
    val role: Role = Role.USER,

    @OneToMany(mappedBy = "user", cascade = [CascadeType.ALL], fetch = FetchType.LAZY)
    val readingProgress: List<ReadingProgress> = mutableListOf(),

    @OneToMany(mappedBy = "user", cascade = [CascadeType.ALL], fetch = FetchType.LAZY)
    val reviews: List<Review> = mutableListOf(),

    @Column(name = "created_at", updatable = false)
    val createdAt: LocalDateTime = LocalDateTime.now()
) {
    fun toResponse() = UserResponse(
        id = this.id,
        email = this.email,
        username = this.username,
        profilePicture = this.profilePicture,
        provider = this.provider.name,
        role = this.role.name,
        createdAt = this.createdAt
    )

    enum class Role {
        ADMIN, USER
    }

    enum class Provider {
        GOOGLE, APPLE
    }
}
