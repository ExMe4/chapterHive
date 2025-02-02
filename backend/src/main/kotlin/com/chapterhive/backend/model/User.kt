package com.chapterhive.backend.model

import jakarta.persistence.*
import java.util.*

@Entity
@Table(name = "users")
class User {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private val id: UUID? = null

    private val username: String? = null

    @Column(unique = true, nullable = false)
    private var email: String? = null

    private val password: String? = null

    @Enumerated(EnumType.STRING)
    private val role: Role? = null

    @OneToMany(mappedBy = "user", cascade = [CascadeType.ALL], fetch = FetchType.LAZY)
    val readingProgress: List<ReadingProgress> = mutableListOf()

    enum class Role {
        ADMIN, USER
    }
}