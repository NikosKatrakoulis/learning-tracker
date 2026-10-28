package com.learning.tracker.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.function.Function;

/**
 * Creates, parses and validates HMAC-signed JWTs. The token carries only the username (subject);
 * roles are re-loaded from the database on every request by JwtAuthenticationFilter.
 */

@Component
public class JwtTokenProvider {

    // The fallback value is for local development only
    // HMAC-SHA requires a sufficiently long key, hence the long default.
    @Value("${app.jwt.secret:defaultSecretKeyForDevelopmentPurposeOnlyMustBeLongEnough}")
    private String jwtSecret;

    @Value("${app.jwt.expiration-ms:86400000}")
    private long jwtExpirationMs;

    private SecretKey getSigningKey() {
        return Keys.hmacShaKeyFor(jwtSecret.getBytes(StandardCharsets.UTF_8));
    }

    public String generateToken(Authentication authentication) {
        UserDetails userPrincipal = (UserDetails) authentication.getPrincipal();
        System.out.println("[DEBUG_LOG] Generating token for user: " + userPrincipal.getUsername());

        return Jwts.builder()
                .subject(userPrincipal.getUsername())
                .issuedAt(new Date())
                .expiration(new Date((new Date()).getTime() + jwtExpirationMs))
                .signWith(getSigningKey())
                .compact();
    }

    public String getUsernameFromToken(String token) {
        return getClaimFromToken(token, Claims::getSubject);
    }

    // Generic accessor so any claim can be read without repeating the parse logic.
    public <T> T getClaimFromToken(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = getAllClaimsFromToken(token);
        return claimsResolver.apply(claims);
    }

    // Verifies the signature and expiry while parsing; throws if the token is invalid.
    private Claims getAllClaimsFromToken(String token) {
        return Jwts.parser()
                .verifyWith(getSigningKey())
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }

    // Returns false for any failure (expired, malformed, bad signature) without telling the caller which one.
    public boolean validateToken(String authToken) {
        try {
            Jwts.parser().verifyWith(getSigningKey()).build().parseSignedClaims(authToken);
            return true;
        } catch (Exception e) {
            System.out.println("[DEBUG_LOG] JWT validation failed: " + e.getMessage());
        }
        return false;
    }
}
