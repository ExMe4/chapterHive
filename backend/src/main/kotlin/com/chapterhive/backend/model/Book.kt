package com.chapterhive.backend.model

import jakarta.persistence.*
import java.util.*


@Entity
class Book {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    var id: UUID? = null

    var title: String? = null
    private val author: String? = null
    private val pages = 0
    private val coverImage: String? = null

    @Column(nullable = false)
    private var averageRating = 0.0f

    private val reviewCount = 0
}
