package com.example.beehope.mapper;


import com.example.beehope.dto.RequestDTO;
import com.example.beehope.model.Request;

public class RequestMapper {
    public static Request DtoToEntity(RequestDTO requestDTO) {
        return new Request().setName(requestDTO.getName())
                .setDescription(requestDTO.getDescription())
                .setCoordinates(requestDTO.getCoordinates())
                .setStatus(requestDTO.getStatus());
    }
    public static RequestDTO EntityToDto(Request request) {
        return new RequestDTO().setName(request.getName())
                .setDescription(request.getDescription())
                .setCoordinates(request.getCoordinates())
                .setStatus(request.getStatus());
    }
}
