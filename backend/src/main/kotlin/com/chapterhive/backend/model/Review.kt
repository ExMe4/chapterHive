package com.chapterhive.backend.model

import jakarta.persistence.*
import java.util.*

@Entity
data class Review(
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    val id: UUID? = null,

    @ManyToOne
    @JoinColumn(name = "book_id", nullable = false)
    val book: Book,

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    val user: User,

    val rating: Int, // 1 to 5 stars
    val comment: String? = null,
)
