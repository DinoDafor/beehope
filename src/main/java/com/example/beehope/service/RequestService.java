package com.example.beehope.service;



import com.example.beehope.model.Request;
import com.example.beehope.repository.RequestRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class RequestService implements IRequest {
    @Autowired
    RequestRepository requestRepository;

    @Override
    public List<Request> getAllRequests() {
        return requestRepository.findAll();
    }

    @Override
    public Optional<Request> findById(int id) {
        return requestRepository.findById(id);
    }

    @Override
    public Request save(Request request) {
        return requestRepository.save(request);
    }

    @Override
    public void delete(int id) {
        requestRepository.deleteById(id);
    }
    public List<String> findAllImages(){
       return requestRepository.findImages();
    }
}
