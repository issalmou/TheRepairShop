package m2si.poo.TheRepairShop.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Table(name = "repair_images")
@Getter
@Setter
@NoArgsConstructor
public class RepairImage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "repair_id", nullable = false)
    private Repair repair;

    @Column(nullable = false, length = 255)
    private String path;

    @Column(name = "original_name", length = 255)
    private String originalName;

    @Column(name = "content_type", length = 100)
    private String contentType;

    @Column
    private Long size;

    @Column(name = "uploaded_at", nullable = false, updatable = false)
    private LocalDateTime uploadedAt;

    @PrePersist
    protected void onCreate() {
        uploadedAt = LocalDateTime.now();
    }
}
