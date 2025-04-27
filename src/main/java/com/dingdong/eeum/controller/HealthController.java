package com.dingdong.eeum.controller;

import com.dingdong.eeum.apiPayload.exception.response.Response;
import com.dingdong.eeum.constant.PlaceSearch;
import io.swagger.v3.oas.annotations.Parameter;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class HealthController {
    @GetMapping("/")
    public String health(){
        return "healthy";
    }
}
