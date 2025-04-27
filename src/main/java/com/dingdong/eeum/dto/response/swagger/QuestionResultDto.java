package com.dingdong.eeum.dto.response.swagger;

import com.dingdong.eeum.dto.response.QuestionResponseDto;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class QuestionResultDto {
    @Schema(description = "질문 목록")
    private List<QuestionResponseDto> questions;
}
