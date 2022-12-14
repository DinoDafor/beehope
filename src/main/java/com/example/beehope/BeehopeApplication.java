package com.example.beehope;


import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@SpringBootApplication
//@ComponentScan( basePackageClasses = RequestController.class) // где искать контроллер
@EnableJpaAuditing //для автоматического изменений даты и даты модификации
public class BeehopeApplication {

    public static void main(String[] args) {
        SpringApplication.run(BeehopeApplication.class, args);
    }

}
