package com.chapterhive.backend.controller

import com.chapterhive.backend.model.Review
import com.chapterhive.backend.model.User
import com.chapterhive.backend.repository.BookRepository
import com.chapterhive.backend.repository.ReviewRepository
import com.chapterhive.backend.repository.UserRepository
import com.chapterhive.backend.security.JwtTokenProvider
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.*
import java.util.*

@RestController
@RequestMapping("/api/reviews")
class ReviewController(
    private val reviewRepository: ReviewRepository,
    private val bookRepository: BookRepository,
    private val userRepository: UserRepository,
    private val jwtTokenProvider: JwtTokenProvider
) {
    @PreAuthorize("isAuthenticated()")
    @PostMapping("/{bookId}/{userId}")
    fun addReview(
        @PathVariable bookId: UUID,
        @PathVariable userId: UUID,
        @RequestBody review: Review
    ): ResponseEntity<Review> {
        val book = bookRepository.findById(bookId)
        val user = userRepository.findById(userId)

        if (book.isEmpty || user.isEmpty) {
            return ResponseEntity.notFound().build()
        }

        val newReview = review.copy(book = book.get(), user = user.get())
        return ResponseEntity.ok(reviewRepository.save(newReview))
    }

    @GetMapping("/{bookId}")
    fun getReviews(
        @PathVariable bookId: UUID,
        @RequestParam(defaultValue = "0") page: Int,
        @RequestParam(defaultValue = "10") size: Int
    ): ResponseEntity<Page<Review>> {
        val pageable = PageRequest.of(page, size)
        return ResponseEntity.ok(reviewRepository.findByBookId(bookId, pageable))
    }

    @PreAuthorize("isAuthenticated()")
    @PutMapping("/{reviewId}")
    fun updateReview(@PathVariable reviewId: UUID, @RequestBody updatedReview: Review): ResponseEntity<Review> {
        val existingReview = reviewRepository.findById(reviewId)
        if (existingReview.isEmpty) {
            return ResponseEntity.notFound().build()
        }

        val reviewToUpdate = existingReview.get().copy(
            rating = updatedReview.rating,
            comment = updatedReview.comment
        )
        return ResponseEntity.ok(reviewRepository.save(reviewToUpdate))
    }

    @PreAuthorize("hasAuthority('ADMIN') or isAuthenticated()")
    @DeleteMapping("/{reviewId}")
    fun deleteReview(
        @PathVariable reviewId: UUID,
        @RequestHeader("Authorization") token: String
    ): ResponseEntity<Void> {
        val email = jwtTokenProvider.getEmailFromToken(token.substring(7))
        val user = userRepository.findByEmail(email) ?: return ResponseEntity.status(403).build()

        val review = reviewRepository.findById(reviewId)
        if (review.isEmpty) {
            return ResponseEntity.notFound().build()
        }

        if (review.get().user.id != user.id && user.role != User.Role.ADMIN) {
            return ResponseEntity.status(403).build()
        }

        reviewRepository.deleteById(reviewId)
        return ResponseEntity.noContent().build()
    }
}
