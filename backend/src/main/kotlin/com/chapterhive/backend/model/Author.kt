package com.chapterhive.backend.model

import com.chapterhive.backend.model.response.AuthorResponse
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
) {
    fun toResponse() = AuthorResponse(
        name = name,
        bio = bio ?: "",
        profileImageUrl = profileImageUrl ?: ""
    )
}
