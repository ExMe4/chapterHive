package com.chapterhive.backend.controller

import com.chapterhive.backend.model.Review
import com.chapterhive.backend.repository.BookRepository
import com.chapterhive.backend.repository.ReviewRepository
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import java.util.*

@RestController
@RequestMapping("/api/reviews")
class ReviewController(
    private val reviewRepository: ReviewRepository,
    private val bookRepository: BookRepository
) {
    @PostMapping("/{bookId}")
    fun addReview(@PathVariable bookId: UUID, @RequestBody review: Review): ResponseEntity<Review> {
        val book = bookRepository.findById(bookId)
        if (book.isEmpty) {
            return ResponseEntity.notFound().build()
        }

        val newReview = review.copy(book = book.get())
        return ResponseEntity.ok(reviewRepository.save(newReview))
    }

    @GetMapping("/{bookId}")
    fun getReviews(@PathVariable bookId: UUID): ResponseEntity<List<Review>> {
        return ResponseEntity.ok(reviewRepository.findByBookId(bookId))
    }
}