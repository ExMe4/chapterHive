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
        // Check database
        val localBook = bookRepository.findByTitleIgnoreCase(title)
        if (localBook != null) {
            return ResponseEntity.ok(localBook)
        }

        // If not found, fetch from Google Books API
        val apiBook = bookApiService.fetchBookDetails(title)
        if (apiBook != null) {
            val existingBook = bookRepository.findByGoogleBookId(apiBook.googleBookId!!)
            if (existingBook != null) {
                return ResponseEntity.ok(existingBook) // ✅ Return if already stored
            }

            val savedBook = bookRepository.save(apiBook.copy(source = "api"))
            return ResponseEntity.ok(savedBook)
        }

        return ResponseEntity.notFound().build()
    }
}
