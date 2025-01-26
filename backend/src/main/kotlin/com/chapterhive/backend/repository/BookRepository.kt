package com.chapterhive.backend.repository

import com.chapterhive.backend.model.Book
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.*

@Repository
interface BookRepository : JpaRepository<Book?, UUID?> {
    fun findByTitle(title: String?): Book?

    fun findByTitleIgnoreCase(title: String): Book?
}