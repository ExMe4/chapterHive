package com.chapterhive.backend.service

import com.chapterhive.backend.repository.BookRepository
import com.chapterhive.backend.repository.AuthorRepository
import org.springframework.stereotype.Service

@Service
class ExploreService(
    private val bookRepository: BookRepository,
    private val authorRepository: AuthorRepository,
    private val googleBooksService: GoogleBooksService
) {
    fun explore(query: String?): Map<String, Any> {
        if (query.isNullOrBlank()) {
            return mapOf("message" to "No query provided, return default explore content")
        }

        // Fetch from local database
        val books = bookRepository.findByTitleContainingIgnoreCase(query).map { it.toResponse() }
        val authors = authorRepository.findByNameContainingIgnoreCase(query)

        // If no local results, fetch from Google Books API
        return if (books.isEmpty() && authors.isEmpty()) {
            val externalBooks = googleBooksService.searchBooks(query)
            mapOf("books" to externalBooks, "authors" to authors.map { it.toResponse() })
        } else {
            mapOf("books" to books, "authors" to authors.map { it.toResponse() })
        }
    }
}
