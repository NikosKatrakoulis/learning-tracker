package com.learning.tracker.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "units")
@Data
public class Unit {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "course_id", nullable = false)
    @JsonIgnore
    private Course course;

    @Column(nullable = false)
    private String title;

    private String section;

    private String content;

    @Column(name = "order_index", nullable = false)
    private Integer orderIndex;

    @Column(name = "unit_type", nullable = false)
    private String unitType = "lesson";

    @Column(name = "pdf_path")
    private String pdfPath;

    @Column(name = "pdf_data", columnDefinition = "BYTEA")
    private byte[] pdfData;

    @Column(name = "pdf_name")
    private String pdfName;
}
