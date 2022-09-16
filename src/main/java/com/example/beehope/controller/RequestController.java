package com.example.beehope.controller;


import com.example.beehope.dto.RequestDTO;
import com.example.beehope.mapper.RequestMapper;
import com.example.beehope.model.Request;
import com.example.beehope.service.RequestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StreamUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;


import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;
import javax.validation.constraints.Min;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URI;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

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
    @ResponseBody
    @PostMapping(value = "/requests")
    ResponseEntity<?> createRequest(RequestDTO inRequest, MultipartFile file) {
        Request request = RequestMapper.DtoToEntity(inRequest, file);
        Request addedRequest = requestService.save(request);
        String fileName = StringUtils.cleanPath(file.getOriginalFilename());

        Path path = Paths.get(fileName);
        try {
            Files.copy(file.getInputStream(), path, StandardCopyOption.REPLACE_EXISTING);
        } catch (IOException e) {
            e.printStackTrace();
        }

        URI location = ServletUriComponentsBuilder.fromCurrentRequest()
                .path("/{id}")
                .buildAndExpand(addedRequest.getId())
                .toUri();
        return ResponseEntity.created(location).build();
    }

    //Редактирование заявки
    //todo photo
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


    //    @PostMapping("/upload")
//    public ResponseEntity uploadToLocalFileSystem(@RequestParam("file") MultipartFile file) {
//        String fileName = StringUtils.cleanPath(file.getOriginalFilename());
//        Path path = Paths.get(fileName);
//        try {
//            Files.copy(file.getInputStream(), path, StandardCopyOption.REPLACE_EXISTING);
//        } catch (IOException e) {
//            e.printStackTrace();
//        }
//        String fileDownloadUri = ServletUriComponentsBuilder.fromCurrentContextPath()
//                .path("/files/download/")
//                .path(fileName)
//                .toUriString();
//        return ResponseEntity.ok(fileDownloadUri);
//    }
    //Загрузка одной фотографии
    @GetMapping("/download/{fileName:.+}")
    public ResponseEntity downloadFileFromLocal(@PathVariable String fileName) {
        Path path = Paths.get(fileName);
        Resource resource = null;
        try {
            resource = new UrlResource(path.toUri());
        } catch (MalformedURLException e) {
            e.printStackTrace();
        }
        return ResponseEntity.ok()
                .contentType(MediaType.IMAGE_PNG)
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + resource.getFilename() + "\"")
                .body(resource);
    }
    //Загрузка всех фоток в zip архиве
    @GetMapping(value = "/zip-download", produces = "application/zip")
    public void zipDownload(HttpServletResponse response) throws IOException {
        List<String> images = requestService.findAllImages();
        ZipOutputStream zipOut = new ZipOutputStream(response.getOutputStream());
        for (String fileName : images) {
            FileSystemResource resource = new FileSystemResource(fileName);
            ZipEntry zipEntry = new ZipEntry(resource.getFilename());
            zipEntry.setSize(resource.contentLength());
            zipOut.putNextEntry(zipEntry);
            StreamUtils.copy(resource.getInputStream(), zipOut);
            zipOut.closeEntry();
        }
        zipOut.finish();
        zipOut.close();
        response.setStatus(HttpServletResponse.SC_OK);
        response.addHeader(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + "zipAnimals" + "\"");
    }

}

