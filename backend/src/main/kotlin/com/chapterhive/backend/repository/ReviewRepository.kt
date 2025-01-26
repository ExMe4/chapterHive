package com.chapterhive.backend.repository

import com.chapterhive.backend.model.Review
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.*

@Repository
interface ReviewRepository : JpaRepository<Review?, UUID?> {
    fun findByBookId(bookId: UUID?): List<Review?>?
}