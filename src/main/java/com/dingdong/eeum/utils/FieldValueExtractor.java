package com.dingdong.eeum.utils;

import com.dingdong.eeum.apiPayload.exception.handler.ExceptionHandler;
import org.springframework.stereotype.Component;

import java.lang.reflect.Field;

import static com.dingdong.eeum.apiPayload.code.status.ErrorStatus._INTERNAL_SERVER_ERROR;

@Component
public class FieldValueExtractor {
    public Object getFieldValue(Object object, String fieldPath) {
        try {
            String[] fields = fieldPath.split("\\.");
            Object value = object;

            for (String field : fields) {
                if (value == null) return null;

                if (field.equals("_id")) field = "id";

                Field declaredField = value.getClass().getDeclaredField(field);
                declaredField.setAccessible(true);
                value = declaredField.get(value);
            }

            return value;
        } catch (Exception e) {
            throw new ExceptionHandler(_INTERNAL_SERVER_ERROR);
        }
    }
}
