package com.dingdong.eeum.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.List;

@Getter
@AllArgsConstructor
public class ScrollResponseDto<T> implements SearchResult<T> {
    private final List<T> places;
    private final boolean hasNext;
    private final String nextCursor;
}
