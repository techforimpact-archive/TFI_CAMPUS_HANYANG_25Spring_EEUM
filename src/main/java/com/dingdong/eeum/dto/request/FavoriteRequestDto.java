package com.dingdong.eeum.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.NoArgsConstructor;


@Getter
@NoArgsConstructor
public class FavoriteRequestDto {
    @NotBlank(message = "장소 ID는 필수입니다.")
    @Schema(description = "장소 ID", example = "place123")
    private String placeId;
}
