package com.example.beehope.service;



import com.example.beehope.model.Request;

import java.util.List;
import java.util.Optional;

public interface IRequest {
    List<Request> getAllRequests();
    Optional<Request> findById(int id);
    Request save(Request request);
    void delete(int id);
}
