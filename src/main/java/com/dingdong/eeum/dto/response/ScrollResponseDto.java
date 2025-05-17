package com.dingdong.eeum.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.List;

@Getter
@AllArgsConstructor
public class ScrollResponseDto<T> implements SearchResult<T> {
    private final List<T> contents;
    private final boolean hasNext;
    private final String nextCursor;
}
