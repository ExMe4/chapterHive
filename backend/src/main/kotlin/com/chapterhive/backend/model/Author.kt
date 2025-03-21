package com.chapterhive.backend.model

import jakarta.persistence.*

@Entity
@Table(name = "authors")
data class Author(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long? = null,

    @Column(nullable = false, unique = true)
    val name: String,

    val bio: String? = null,

    val profileImageUrl: String? = null
)
