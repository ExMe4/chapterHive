package com.chapterhive.backend.security

import jakarta.servlet.FilterChain
import jakarta.servlet.ServletRequest
import jakarta.servlet.ServletResponse
import jakarta.servlet.http.HttpServletRequest
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.security.core.userdetails.User
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter

class JwtAuthenticationFilter(
    private val jwtTokenProvider: JwtTokenProvider
) : UsernamePasswordAuthenticationFilter() {

    override fun doFilter(req: ServletRequest, res: ServletResponse, chain: FilterChain) {
        val request = req as HttpServletRequest
        val token = request.getHeader("Authorization")?.replace("Bearer ", "")

        if (token != null && jwtTokenProvider.validateToken(token)) {
            val email = jwtTokenProvider.getEmailFromToken(token)
            val role = jwtTokenProvider.getRoleFromToken(token)

            val auth = org.springframework.security.authentication.UsernamePasswordAuthenticationToken(
                User(email, "", listOf(org.springframework.security.core.authority.SimpleGrantedAuthority(role))),
                null,
                listOf(org.springframework.security.core.authority.SimpleGrantedAuthority(role))
            )

            SecurityContextHolder.getContext().authentication = auth
        }

        chain.doFilter(req, res)
    }
}
