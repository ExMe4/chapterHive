package com.chapterhive.backend.controller

import com.chapterhive.backend.repository.BookRepository
import com.chapterhive.backend.repository.AuthorRepository
import com.chapterhive.backend.service.GoogleBooksService
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/explore")
class ExploreController(
    private val bookRepository: BookRepository,
    private val authorRepository: AuthorRepository,
    private val googleBooksService: GoogleBooksService
) {
    @GetMapping
    fun explore(@RequestParam("query", required = false) query: String?): Map<String, Any> {
        return if (query.isNullOrBlank()) {
            mapOf("message" to "No query provided, return default explore content")
        } else {
            val books = bookRepository.findByTitleContainingIgnoreCase(query)
            val authors = authorRepository.findByNameContainingIgnoreCase(query)

            // If no local results, fetch from Google Books API
            if (books.isEmpty() && authors.isEmpty()) {
                val externalBooks = googleBooksService.searchBooks(query)
                return mapOf("books" to externalBooks, "authors" to authors)
            }

            mapOf("books" to books, "authors" to authors)
        }
    }
}
