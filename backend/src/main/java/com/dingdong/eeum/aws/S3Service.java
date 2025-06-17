package com.dingdong.eeum.aws;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.DeleteObjectRequest;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class S3Service {

    private final AmazonS3 amazonS3Client;

    @Value("${cloud.aws.s3.bucket}")
    private String bucket;

    public List<String> uploadFiles(List<MultipartFile> multipartFiles) {
        List<String> fileUrls = new ArrayList<>();

        int filesToUpload = multipartFiles.size();

        for (int i = 0; i < filesToUpload; i++) {
            MultipartFile file = multipartFiles.get(i);
            String fileName = createFileName(file.getOriginalFilename());
            ObjectMetadata objectMetadata = new ObjectMetadata();
            objectMetadata.setContentLength(file.getSize());
            objectMetadata.setContentType(file.getContentType());

            try {
                PutObjectRequest putObjectRequest = new PutObjectRequest(
                        bucket,
                        fileName,
                        file.getInputStream(),
                        objectMetadata
                );

                amazonS3Client.putObject(putObjectRequest);

                String fileUrl = amazonS3Client.getUrl(bucket, fileName).toString();
                fileUrls.add(fileUrl);
            } catch (IOException e) {
                throw new RuntimeException("File upload failed", e);
            }
        }

        return fileUrls;
    }

    public void deleteFile(String imageUrl) {
        String fileName = imageUrl.substring(imageUrl.lastIndexOf("/") + 1);
        amazonS3Client.deleteObject(new DeleteObjectRequest(bucket, fileName));
    }

    private String createFileName(String originalFileName) {
        return "reviews/" + UUID.randomUUID().toString() + "_" + originalFileName;
    }
}
