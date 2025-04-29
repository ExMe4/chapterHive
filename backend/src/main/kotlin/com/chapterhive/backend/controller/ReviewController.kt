package com.chapterhive.backend.controller

import com.chapterhive.backend.model.Review
import com.chapterhive.backend.model.User
import com.chapterhive.backend.repository.BookRepository
import com.chapterhive.backend.repository.ReviewRepository
import com.chapterhive.backend.repository.UserRepository
import com.chapterhive.backend.security.JwtTokenProvider
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.Parameter
import io.swagger.v3.oas.annotations.tags.Tag
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.*
import java.util.*

@Tag(name = "Reviews", description = "Manage user reviews for books")
@RestController
@RequestMapping("/api/reviews")
class ReviewController(
    private val reviewRepository: ReviewRepository,
    private val bookRepository: BookRepository,
    private val userRepository: UserRepository,
    private val jwtTokenProvider: JwtTokenProvider
) {
    @PreAuthorize("isAuthenticated()")
    @Operation(summary = "Add a review", description = "Allows a user to add a review for a book.")
    @PostMapping("/{bookId}/{userId}")
    fun addReview(
        @Parameter(description = "ID of the book to review") @PathVariable bookId: UUID,
        @Parameter(description = "ID of the user adding the review") @PathVariable userId: String,
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

    @Operation(summary = "Get reviews for a book", description = "Fetches paginated reviews for a specific book.")
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
    @Operation(summary = "Update a review", description = "Allows a user to update their review.")
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
    @Operation(summary = "Delete a review", description = "Allows an admin or the review owner to delete a review.")
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
