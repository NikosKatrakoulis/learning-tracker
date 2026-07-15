package com.learning.tracker.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "quiz_options")
@Data
public class QuizOption {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "question_id", nullable = false)
    @JsonIgnore
    private QuizQuestion question;

    @Column(name = "option_letter", nullable = false)
    private String optionLetter;

    @Column(name = "option_text", nullable = false)
    private String optionText;
}
