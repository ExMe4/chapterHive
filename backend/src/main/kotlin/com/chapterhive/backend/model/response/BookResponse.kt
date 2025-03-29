package com.chapterhive.backend.model.response

data class BookResponse(
    val title: String,
    val author: String,
    val description: String,
    val coverImage: String,
    val publicationYear: Int?,
    val language: String,
    val publisher: String,
    val genre: String,
    val pages: Int,
    val source: String,
    val isbnList: List<String> = emptyList()
)