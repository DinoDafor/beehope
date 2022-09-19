package com.example.beehope.repository;


import com.example.beehope.model.Request;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RequestRepository extends JpaRepository<Request, Integer> {
    @Query(nativeQuery = true, value = "SELECT image FROM requests")
    List<String> findImages();

}

