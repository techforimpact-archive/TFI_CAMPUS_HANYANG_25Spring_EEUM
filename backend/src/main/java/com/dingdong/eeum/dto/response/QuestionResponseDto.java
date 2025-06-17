package com.dingdong.eeum.dto.response;

import com.dingdong.eeum.model.Question;
import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public class QuestionResponseDto {
    private String id;
    private String question;
    private String detail;

    public static QuestionResponseDto toQuestionResponseDto(Question question) {
        return new QuestionResponseDto(
                question.getId(),
                question.getQuestion(),
                question.getDetail()
        );
    }
}
