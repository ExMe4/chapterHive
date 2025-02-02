package com.chapterhive.backend.model

import jakarta.persistence.*
import java.util.*

@Entity
data class ReadingProgress(
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    val id: UUID? = null,

    // Reference to the user
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    val user: User,

    // Reference to the book
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "book_id")
    val book: Book,

    // How far the user is in the book (for a 400-page book, e.g., page number)
    val currentPage: Int = 0,

    val completionPercentage: Double = 0.0
)