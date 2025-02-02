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
        // Check if book exists in the database by Google Book ID
        val apiBook = bookApiService.fetchBookDetails(title)

        if (apiBook != null) {
            val existingBook = bookRepository.findByGoogleBookId(apiBook.googleBookId!!)
            if (existingBook != null) {
                return ResponseEntity.ok(existingBook) // Return existing book if found
            }

            // If book is not found, save it to DB
            bookRepository.save(apiBook)
            return ResponseEntity.ok(apiBook)
        }

        return ResponseEntity.notFound().build()
    }
}
