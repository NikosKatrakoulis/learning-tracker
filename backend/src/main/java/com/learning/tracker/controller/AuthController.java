package com.learning.tracker.controller;

import com.learning.tracker.model.User;
import com.learning.tracker.repository.UserRepository;
import com.learning.tracker.security.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * Public login endpoint (/api/auth/** is permitAll in SecurityConfig).
 */
@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class AuthController {
    private final UserRepository userRepository;
    private final AuthenticationManager authenticationManager;
    private final JwtTokenProvider tokenProvider;

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> credentials) {
        String username = credentials.get("username");
        String password = credentials.get("password");
        
        try {
            // Delegates to DaoAuthenticationProvider: loads the user and checks the BCrypt hash.
            // Throws AuthenticationException on bad credentials.
            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(username, password)
            );
            
            SecurityContextHolder.getContext().setAuthentication(authentication);
            String jwt = tokenProvider.generateToken(authentication);

            // Second lookup only to obtain id/role/fullName for the response
            User user = userRepository.findByUsername(username).orElseThrow();
            
            return ResponseEntity.ok(Map.of(
                "accessToken", jwt,
                "id", user.getId(),
                "username", user.getUsername(),
                "role", user.getRole(),
                "fullName", user.getFullName()
            ));
        } catch (org.springframework.security.core.AuthenticationException e) {
            // Same message for unknown user and wrong password, so the response does not reveal which usernames exist.
            return ResponseEntity.status(401).body(Map.of("message", "Invalid username or password"));
        }
    }
}
