package com.chapterhive.backend.repository

import com.chapterhive.backend.model.Author
import org.springframework.data.jpa.repository.JpaRepository

interface AuthorRepository : JpaRepository<Author, Long> {
    fun findByNameContainingIgnoreCase(name: String): List<Author>
}
