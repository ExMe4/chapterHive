package com.chapterhive.backend.controller

import com.chapterhive.backend.model.Book
import com.chapterhive.backend.security.JwtTokenProvider
import com.chapterhive.backend.service.BookApiService
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.*

@Tag(name = "Books", description = "Endpoints for searching books")
@RestController
@RequestMapping("/api/books")
class BookController(
    private val bookApiService: BookApiService,
    private val jwtTokenProvider: JwtTokenProvider
) {
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Search book by title", description = "Fetches book details based on the title")
    @GetMapping("/search")
    fun getBookByTitle(@RequestParam title: String): ResponseEntity<Book> {
        val book = bookApiService.getBook(title) ?: return ResponseEntity.notFound().build()
        return ResponseEntity.ok(book)
    }
}
