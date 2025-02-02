package com.chapterhive.backend.model

import jakarta.persistence.*
import java.util.*


@Entity
data class Book(
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    val id: UUID? = null,

    val googleBookId: String? = null,

    val title: String,
    val author: String,
    val pages: Int? = null,
    val coverImage: String? = null,
    val source: String = "local", // Can be "local" or "API"
    val publicationYear: Int? = null,
    val genre: String? = null,
    val description: String? = null,
    val publisher: String? = null,
    val language: String? = null
)
