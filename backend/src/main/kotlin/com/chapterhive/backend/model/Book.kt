package com.chapterhive.backend.model

import jakarta.persistence.*
import java.util.*


@Entity
data class Book(
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    val id: UUID? = null,

    val title: String,
    val author: String,
    val pages: Int? = null,
    val coverImage: String? = null,
    val source: String = "local" // Can be "local" or "api"
)
