package com.example.beehope.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotBlank;

@Getter
@Setter
@Accessors(chain = true)

@NoArgsConstructor
public class RequestDTO {
    @NotBlank(message = "Name is required!")
    private String name;
    private String description;
    @NotBlank(message = "Name is required!")
    private String coordinates;
    private String status;
}
