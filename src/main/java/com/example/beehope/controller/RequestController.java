package com.example.beehope.controller;


import com.example.beehope.dto.RequestDTO;
import com.example.beehope.mapper.RequestMapper;
import com.example.beehope.model.Request;
import com.example.beehope.service.RequestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;


import javax.validation.Valid;
import javax.validation.constraints.Min;
import java.net.URI;
import java.util.List;
import java.util.NoSuchElementException;

@RestController
@RequestMapping("/api")
public class RequestController {

    @Autowired
    RequestService requestService;

    //Получение всех заявок из бд
    @GetMapping(value = "/requests")
    List<Request> getAll() {
        return requestService.getAllRequests();
    }

    //Получение определённой заявки по айди
    @GetMapping(value = "/requests/{id}")
    ResponseEntity<Request> getById(@PathVariable("id") @Min(1) int id) {
        Request request = requestService.findById(id)
                .orElseThrow(ThereIsNoSuchRequestException::new);
        return ResponseEntity.ok().body(request);
    }

    //Добавление новой заявки
    @PostMapping(value = "/requests")
    ResponseEntity<?> createRequest(@Valid @RequestBody RequestDTO inRequest) {
        Request request = RequestMapper.DtoToEntity(inRequest);
        Request addedRequest = requestService.save(request);
        URI location = ServletUriComponentsBuilder.fromCurrentRequest()
                .path("/{id}")
                .buildAndExpand(addedRequest.getId())
                .toUri();
        return ResponseEntity.created(location).build();
    }

    //Редактирование заявки
    @PutMapping(value = "/requests/{id}")
    ResponseEntity<Request> updateRequest(@PathVariable("id") @Min(1) int id, @Valid @RequestBody RequestDTO inRequest) {
        Request request = requestService.findById(id)
                .orElseThrow(ThereIsNoSuchRequestException::new);
        Request newRequest = RequestMapper.DtoToEntity(inRequest);
        newRequest.setId(request.getId());
        requestService.save(newRequest);
        return ResponseEntity.ok().body(newRequest);
    }

    // Удаление заявки по ID
    @DeleteMapping(value = "/requests/{id}")
    ResponseEntity deleteProduct(@PathVariable("id") @Min(1) int id) {
        Request request = requestService.findById(id)
                .orElseThrow(ThereIsNoSuchRequestException::new);
        requestService.delete(request.getId());
        return ResponseEntity.ok().body("Request with ID : " + id + " deleted with success!");
    }

}

