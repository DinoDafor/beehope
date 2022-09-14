package com.example.beehope.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.Accessors;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;

@Entity
@Table(name = "requests")
@Accessors(chain = true)
@Getter
@Setter
@EntityListeners(AuditingEntityListener.class) //для автоматической даты и модификации даты
@NoArgsConstructor
//todo другой конструктор?
//  @CreatedDate @LastModifiedDate
public class Request {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private String name;
    private String description;
    private String coordinates;
    private String status;
    //@Column
//    photo?;

}
