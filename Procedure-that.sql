use newspaper_database;
DROP PROCEDURE IF EXISTS GetTopAuthorsByEngagementInPeriod;
-- PROCEDURE FOR QUERY HERE
-- query 1 Trả về tác giả có lượt tương tác (view, like, share) cao nhất dựa vào các bài đăng trong khoảng thời gian truyền vào
DELIMITER //
CREATE PROCEDURE GetTopAuthorsByEngagementInPeriod(
    IN startDate DATE,
    IN endDate DATE
)
BEGIN
    SELECT
        A.AuthorID,
        A.AUsername,
        SUM(ArTotalViews + ArTotalShares*5 + ArTotalLikes*5) AS ArTotalEngagement
    FROM
        PublishedArticle
    JOIN
        Article Ar ON PublishedArticleID = ArticleID
	JOIN 
		Author A ON Ar.AuthorID = A.AuthorID
    WHERE
        ArPublishDate BETWEEN startDate AND endDate
    GROUP BY
        A.AuthorID, A.AUsername
    ORDER BY
        ArTotalEngagement DESC;
END //

DELIMITER ;
CALL GetTopAuthorsByEngagementInPeriod('2023-01-01', '2023-12-31');
-- Query 2: Trả về danh sách các bài báo được Published tìm theo 1 tag hoặc nhiều tag
DROP PROCEDURE IF EXISTS GetArticlesByTag;
DROP TABLE IF EXISTS tempTagList;
-- Tạo bảng tạm thời
CREATE TEMPORARY TABLE tempTagList (TagName VARCHAR(255));

-- Tạo stored procedure
DELIMITER //

CREATE PROCEDURE GetArticlesByTag(
    IN tagList VARCHAR(255) -- Danh sách các Tag, cách nhau bởi dấu phẩy
)
BEGIN
    -- Truncate bảng tạm thời để đảm bảo nó trống trước khi chèn dữ liệu mới
    TRUNCATE TABLE tempTagList;

    -- Chèn dữ liệu vào bảng tạm thời
    INSERT INTO tempTagList (TagName)
    SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(tagList, ',', n.n), ',', -1))
    FROM (
        SELECT 
            ROW_NUMBER() OVER () AS n
        FROM information_schema.tables
    ) n
    WHERE n.n <= 1 + LENGTH(tagList) - LENGTH(REPLACE(tagList, ',', ''));
    SELECT
        DISTINCT A.ArticleID,
        A.ArTitle,
        A.ArContent,
        P.ArPublishDate
    FROM
        Article A
    JOIN
		PublishedArticle P ON A.ArticleID = P.PublishedArticleID
	JOIN
        Label L ON P.PublishedArticleID = L.ArticleID
    JOIN
        Tag  T ON L.TagID = T.TagID
    WHERE
        T.TgTitle IN (SELECT TagName FROM tempTagList)
	ORDER BY
		ArPublishDate DESC;
    DROP TEMPORARY TABLE IF EXISTS tempTagList;
END //

DELIMITER ;
CALL GetArticlesByTag('Nổi bật, Việt Nam, Tương lai');
-- Query 3: Trả về danh sách các danh mục phổ biến dựa trên số bài báo và tổng lượng view của các bài báo được publish thuộc Topic đó trong tháng.
DROP PROCEDURE IF EXISTS GetPopularCategoriesByMonthlyViews;
DROP TABLE IF EXISTS tempCategoryViews;
DELIMITER //
CREATE PROCEDURE GetPopularCategoriesByMonthlyViews()
BEGIN
    -- Xác định khoảng thời gian cho tháng hiện tại
    SET @startOfMonth = DATE_FORMAT(NOW(), '%Y-%m-01');
    SET @endOfMonth = LAST_DAY(NOW());

    -- Tạo một bảng tạm thời để lưu trữ tổng lượt xem của mỗi danh mục trong tháng
    CREATE TEMPORARY TABLE tempCategoryViews AS
    SELECT
        A.TopicID  AS TopicID,
        T.TpTitle AS TopicName,
        COUNT(A.ArticleID) AS TotalArticles,
        SUM(ArTotalViews) AS TotalTopicViews
    FROM
        Topic T
    LEFT JOIN
        Article A ON A.TopicID = T.TopicID
	JOIN 
		PublishedArticle ON PublishedArticleID = ArticleID AND ArPublishDate BETWEEN @startOfMonth AND @endOfMonth
    GROUP BY
        A.TopicID, T.TpTitle;

    -- Lựa chọn thông tin danh mục và tổng lượt xem từ bảng tạm thời
    SELECT
        TopicID,
        TopicName,
        TotalArticles,
        TotalTopicViews
    FROM
        tempCategoryViews
    ORDER BY
        TotalTopicViews DESC;

    -- Xóa bảng tạm thời sau khi sử dụng
    DROP TEMPORARY TABLE IF EXISTS tempCategoryViews;
END //
DELIMITER ;
CALL GetPopularCategoriesByMonthlyViews();

 -- Query 4: Trả về danh sách các Article theo status hoặc review phase hoặc theo editorID
 DROP PROCEDURE IF EXISTS FilterArticlesForEditor;
 DELIMITER //

CREATE PROCEDURE FilterArticlesForEditor(
    IN filterEditorID INT,
    IN filterStatus VARCHAR(255),
    IN filterMinReviewPhase VARCHAR(255)
)
BEGIN
    -- Lựa chọn thông tin bài báo và đếm số lượt đánh giá dựa trên trạng thái và giai đoạn đánh giá (nếu có)
    SELECT
        A.ArticleID,
        A.ArTitle,
        A.ArContent,
        A.ArStatus,
        COUNT(ReviewPhase) AS ReviewCount
    FROM
        Article A
    LEFT JOIN
        Review_log R ON A.ArticleID = R.ArticleID
    WHERE
        (A.EditorID = filterEditorID OR filterEditorID is NULL)
        AND (A.ArStatus = filterStatus OR filterStatus IS NULL)
    GROUP BY
        A.ArticleID, A.ArTitle, A.ArContent, A.ArStatus
	HAVING 
		filterMinReviewPhase IS NULL OR ReviewCount >=filterMinReviewPhase;
END //
DELIMITER ;
CALL FilterArticlesForEditor(2,'Wait',1);
 -- Queries 5: LỌC Publish ARTICLE 
DROP PROCEDURE IF EXISTS FilterArticles;

 DELIMITER //

CREATE PROCEDURE FilterArticles(
    IN filterGenre VARCHAR(255),
    IN filterAuthorID INT,
    IN startDate DATE,
    IN endDate DATE,
    IN filterTopic VARCHAR(255)
)
BEGIN
    -- Đặt giá trị mặc định nếu các đối số không được truyền vào
    SET filterGenre = COALESCE(filterGenre, NULL);
    SET filterAuthorID = COALESCE(filterAuthorID, NULL);
    SET startDate = COALESCE(startDate, '2019-01-01');
    SET endDate = COALESCE(endDate, CURRENT_DATE);
    SET filterTopic = COALESCE(filterTopic, NULL);
    -- Lựa chọn thông tin bài báo dựa trên nhiều tiêu chí
    SELECT
        A.ArticleID,
        A.ArTitle,
        A.ArContent,
        ArPublishDate,
        ArTotalViews,
        ArTotalLikes,
        ArTotalShares
    FROM
        Article A
	JOIN
		PublishedArticle ON PublishedArticleID = A.ArticleID
	JOIN 
		Genre G ON G.GenreID = A.GenreID
    JOIN
		Topic T ON T.TopicID = A.TopicID
    WHERE
        (G.GTitle = filterGenre OR filterGenre IS NULL)
        AND (A.AuthorID = filterAuthorID OR filterAuthorID IS NULL)
        AND (ArPublishDate BETWEEN startDate AND endDate)
        AND (T.TpTitle = filterTopic OR filterTopic IS NULL)
	ORDER BY
		ArPublishDate DESC;
END //

DELIMITER ;
select * from article;
select * from genre;
CALL FilterArticles ('Tin', null,null,'2023-12-31','Chính trị');
-- Queries 6: Tìm Article theo từ khoá trong tên
DROP PROCEDURE if exists SearchArticles;
DELIMITER //

CREATE PROCEDURE SearchArticles(
    IN searchKeyword VARCHAR(255),
    IN sortField VARCHAR(255), -- Tên trường để sắp xếp
    IN sortOrder VARCHAR(4)
)
BEGIN
    -- Lựa chọn thông tin bài báo dựa trên từ khóa trong tiêu đề
    SET searchKeyword = COALESCE(searchKeyword, '');
    SET sortField = COALESCE(sortField, 'ArPublishDate');
    SET sortOrder = COALESCE(sortOrder, 'DESC');
    SELECT
        A.ArticleID,
        A.ArTitle,
        A.ArContent,
        ArPublishDate,
        ArTotalViews,
        ArTotalLikes,
        ArTotalShares,
        A.AuthorID,
		M.MLink
    FROM
        Article A
	JOIN 
		PublishedArticle ON A.ArticleID = PublishedArticleID
	LEFT JOIN
        Attach Att ON PublishedArticleID = Att.ArticleID
    LEFT JOIN
        Media M ON Att.MediaID = M.MediaID
    WHERE
        ArTitle LIKE CONCAT('%', searchKeyword, '%')
	ORDER BY
        CASE 
        WHEN sortOrder = 'DESC' THEN
            CASE 
                WHEN sortField = 'ArPublishDate' THEN ArPublishDate
                WHEN sortField = 'ArTotalViews' THEN ArTotalViews
                WHEN sortField = 'ArTotalLikes' THEN ArTotalLikes
            END
    END DESC,
    CASE 
        WHEN sortOrder = 'ASC' THEN
            CASE 
                WHEN sortField = 'ArPublishDate' THEN ArPublishDate
                WHEN sortField = 'ArTotalViews' THEN ArTotalViews
                WHEN sortField = 'ArTotalLikes' THEN ArTotalLikes
            END
    END ASC;
END //

DELIMITER ;
CALL SearchArticles('', 'arpublishdate', 'desc');

-- Queries 7: Xếp hạng tác giả theo tiền nhuận bút chi trả từ cao nhất xuống thấp nhất trong khoảng thời gian
DROP PROCEDURE IF EXISTS GetTopAuthorsByProfit;

DELIMITER //

CREATE PROCEDURE GetTopAuthorsByProfit(
    IN startDate DATE,
    IN endDate DATE
)
BEGIN
	SET startDate = COALESCE(startDate, '2019-01-01');
    SET endDate = COALESCE(endDate, CURRENT_DATE);
    SELECT
        Au.AuthorID,
        EName AS AuthorName,
        SUM(BTotalAmount - BRemainAmount) AS TotalProfit
    FROM
        Bill B
    JOIN
        Article A ON B.PublishedArticleID = A.ArticleID
    JOIN
        Author Au ON Au.AuthorID = A.AuthorID
	JOIN
		Employee ON Au.AuthorID = EmployeeID
    WHERE
		B.BPayDate BETWEEN startDate AND endDate
    GROUP BY
        Au.AuthorID
    ORDER BY
        TotalProfit DESC;
END //

DELIMITER ;
CALL GetTopAuthorsByProfit (null, '2023-12-31');
-- =========Queries 8: Get recent Comments;
DROP PROCEDURE IF EXISTS GetRecentCommentThroughArticleID;
DELIMITER //

CREATE PROCEDURE GetRecentCommentThroughArticleID(
    IN ArticleID INT
)
BEGIN
    SELECT
        CommentID,
        CPostDate,
        CContent, 
        C.RUserName,
        CTotalLikes,
        CTotalReplies,
        ParentCommentID
	FROM
		Comment C
	WHERE 
		C.PublishedArticleID = ArticleID
	ORDER BY CPostDate DESC;
END //

DELIMITER ;
CALL GetRecentCommentThroughArticleID(8);
-- -===========Query 9 ===============

DROP PROCEDURE IF EXISTS GetEditLogThroughArticleID;
DELIMITER //
CREATE PROCEDURE GetEditLogThroughArticleID(IN ID int)
BEGIN
	SELECT 
		EditPhase,
        EditContent,
        EditDate
	FROM edit_log E WHERE E.ArticleID = ID
    ORDER BY
		EditPhase;
END //
DELIMITER ;
CALL GetEditLogThroughArticleID(3);

-- ===========Query 10 ===============

DROP PROCEDURE IF EXISTS GetReviewLogThroughArticleID;
DELIMITER //
CREATE PROCEDURE GetReviewLogThroughArticleID(IN ID int)
BEGIN
	SELECT 
		ReviewPhase,
		ReviewContent,
        ReviewDate
	FROM review_log R WHERE R.ArticleID = ID
    ORDER BY
		ReviewPhase;
END //
DELIMITER ;
CALL GetReviewLogThroughArticleID(2);


