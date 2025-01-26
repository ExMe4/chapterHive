package com.chapterhive.backend.controller

import com.chapterhive.backend.model.Book
import com.chapterhive.backend.repository.BookRepository
import com.chapterhive.backend.service.BookApiService
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/books")
class BookController(
    private val bookRepository: BookRepository,
    private val bookApiService: BookApiService
) {

    @GetMapping("/{title}")
    fun getBookByTitle(@PathVariable title: String): ResponseEntity<Book> {
        // Search in local database first
        val localBook = bookRepository.findByTitleIgnoreCase(title)
        if (localBook != null) {
            return ResponseEntity.ok(localBook)
        }

        // If not found, fetch from API
        val apiBook = bookApiService.fetchBookDetails(title)
        return if (apiBook != null) {
            // Save the book from API to the database for future use
            bookRepository.save(apiBook)
            ResponseEntity.ok(apiBook)
        } else {
            ResponseEntity.notFound().build()
        }
    }
}
