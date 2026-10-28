package com.learning.tracker.model;

import jakarta.persistence.*;
import lombok.Data;

import java.util.List;

@Entity
@Table(name = "quiz_questions")
@Data
public class QuizQuestion {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "unit_id", nullable = false)
    private Unit unit;

    @Column(name = "question_text", nullable = false)
    private String questionText;

    // Letter of the correct option (e.g. "A"); matches QuizOption.optionLetter.
    @Column(name = "correct_option", nullable = false)
    private String correctOption;

    @Column(name = "order_index", nullable = false)
    private Integer orderIndex;

    // EAGER because a question is never shown without its options.
    @OneToMany(mappedBy = "question", fetch = FetchType.EAGER, cascade = CascadeType.ALL, orphanRemoval = true)
    @OrderBy("optionLetter ASC")
    private List<QuizOption> options;
}
