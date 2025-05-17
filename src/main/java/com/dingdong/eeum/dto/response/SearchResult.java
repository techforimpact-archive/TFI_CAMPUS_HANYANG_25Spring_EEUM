package com.dingdong.eeum.dto.response;

import java.util.List;

public interface SearchResult<T> {
    List<T> getContents();
}
