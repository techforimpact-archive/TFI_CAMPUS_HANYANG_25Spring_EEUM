package com.dingdong.eeum.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class NicknameResetRequestDto {
    @NotBlank(message = "닉네임은 필수입니다")
    private String nickname;
}
