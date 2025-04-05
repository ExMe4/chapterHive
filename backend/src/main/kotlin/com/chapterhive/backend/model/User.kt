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
    val profilePicture: String? = null,

    @Enumerated(EnumType.STRING)
    val provider: Provider,

    @Enumerated(EnumType.STRING)
    val role: Role = Role.USER,

    @OneToMany(mappedBy = "user", cascade = [CascadeType.ALL], fetch = FetchType.LAZY)
    val readingProgress: List<ReadingProgress> = mutableListOf(),

    @OneToMany(mappedBy = "user", cascade = [CascadeType.ALL], fetch = FetchType.LAZY)
    val reviews: List<Review> = mutableListOf()
) {
    enum class Role {
        ADMIN, USER
    }

    enum class Provider {
        GOOGLE, APPLE
    }
}
