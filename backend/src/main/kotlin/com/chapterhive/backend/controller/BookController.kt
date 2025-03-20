package com.chapterhive.backend.controller

import com.chapterhive.backend.model.Book
import com.chapterhive.backend.service.BookApiService
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/books")
class BookController(
    private val bookApiService: BookApiService
) {
    @GetMapping("/search")
    fun getBookByTitle(@RequestParam title: String): ResponseEntity<Book> {
        val book = bookApiService.getBook(title) ?: return ResponseEntity.notFound().build()
        return ResponseEntity.ok(book)
    }
}
