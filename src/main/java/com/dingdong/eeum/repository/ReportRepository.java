package com.dingdong.eeum.repository;

import com.dingdong.eeum.constant.ReportStatus;
import com.dingdong.eeum.model.Report;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ReportRepository extends MongoRepository<Report, String> {

    boolean existsByContentIdAndReporterId(String contentId, String reporterId);

    @Query(value = "{ 'reviewId': { $in: ?0 } }", count = true)
    long countByReviewIdIn(List<String> reviewIds);
}