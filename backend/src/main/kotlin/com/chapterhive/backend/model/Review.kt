package com.chapterhive.backend.model

import jakarta.persistence.*
import java.time.LocalDateTime
import java.util.*

@Entity
class Review {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private val id: UUID? = null

    @ManyToOne
    @JoinColumn(name = "book_id", nullable = false)
    private val book: Book? = null

    private val userId: UUID? = null

    @Column(nullable = false)
    private var rating = 0 // Star rating (1–5)

    private val comment: String? = null

    private val createdAt: LocalDateTime = LocalDateTime.now()
}