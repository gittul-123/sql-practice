-- DB: SQLite
PRAGMA foreign_keys = ON;  -- SQLite 전용

-- 1. 이름이 김민준인 회원 조회 (WHERE)
SELECT * FROM member WHERE '김민준';

-- 2. 출판날짜가 최신인 책 조회 (ORDER BY, LIMIT)
SELECT * FROM book ORDER BY published_date DESC LIMIT 3;

-- 3. 분류가 문학(category_id = 9)이면서 2015년 이후 출판된 책 조회 (WHERE, AND)
SELECT * FROM book WHERE category_id = 9 AND published_date >= '2015-01-01';

-- 4. 책 제목 중 '의'가 들어가는 책 조회 (LIKE)
SELECT * FROM book WHERE title LIKE '%의%';

-- 5. 각 책의 제목과 카테고리 이름 조회 (INNER JOIN)
SELECT book.title, category.category_name
FROM book
INNER JOIN category ON book.category_id = category.id;

-- 6. 모든 카테고리와 해당 책 제목 조회, 책이 없는 카테고리도 포함 (LEFT JOIN)
SELECT book.title, category.category_name
FROM category
LEFT JOIN book ON book.category_id = category.id;

-- 7. 대여 기록별 회원 이름, 책 제목, 대여일 조회 (INNER JOIN 3개 테이블)
SELECT member.name, book.title, rental.rental_date
FROM rental
INNER JOIN member   ON rental.member_id = member.id
INNER JOIN book ON rental.book_id = book.id;

-- 8. 대여 기록이 한 번도 없는 회원 조회 (LEFT JOIN, IS NULL)
SELECT member.name
FROM member
LEFT JOIN rental ON rental.member_id = member.id
WHERE rental.id IS NULL;

-- 9. 카테고리별 도서 수 집계, 책이 없는 카테고리는 제외 (INNER JOIN, GROUP BY, COUNT)
SELECT category.category_name, COUNT(*)
FROM book
INNER JOIN category ON book.category_id = category.id
GROUP BY category.category_name;

-- 10. 모든 카테고리별 도서 수 집계, 책이 없는 카테고리는 0권으로 표시 (LEFT JOIN, GROUP BY, COUNT)
SELECT category.category_name, COUNT(book.id)
FROM category
LEFT JOIN book ON book.category_id = category.id
GROUP BY category.category_name;


-- 11. 회원별 대여 횟수 집계, 대여 기록이 없는 회원은 0회로 표시 (LEFT JOIN, GROUP BY, COUNT)
SELECT member.id,member.name, COUNT(rental.id) 
FROM member
LEFT JOIN rental ON member.id = rental.member_id
GROUP BY member.id;

-- 12. 회원별 평균 대여 일수 조회, 반납하지 않은 건은 평균에서 제외 (GROUP BY, AVG)
-- SQLite 전용 문법: julianday()
SELECT member_id, AVG(julianday(return_date) - julianday(rental_date)) AS avg_days
FROM rental
GROUP BY member_id;

-- 13. 대여 기록이 한 번도 없는 회원 조회 (서브쿼리, NOT IN)
SELECT member.name
FROM member
WHERE id NOT IN (SELECT member_id FROM rental);

--- 8번 방식(LEFT JOIN+IS NULL)과 13번 방식(서브쿼리+NOT IN)의 비교
                8번 (LEFT JOIN + IS NULL)	13번 (서브쿼리 + NOT IN)
읽는 느낌	     이어 붙인 다음 NULL을 골라냄	 "빌린 적 있는 번호 목록에 없는 회원"
이해 쉬움	     처음엔 어려움	                말로 읽으면 직관적
데이터가 많을 때  보통 빠름                     DB에 따라 느릴 수 있음
비고                                         NOT IN은 NULL이 하나라도 포함되면 결과가 비어버림(주의 필요)

-- 14. 정예나(5번)가 '이야기 강'(9번)을 반납한 것으로 반납일 갱신 (UPDATE)
UPDATE rental
SET return_date = '2026-10-13'
WHERE member_id = 5 AND book_id = 9;

-- 15. 대여 기록이 없는 회원(11번 오서율) 삭제 (DELETE)
DELETE FROM member WHERE id = 11;

-- [보너스] 2. 데이터 정합성 깨뜨려 보기 
FK 에러 시도: DELETE FROM member WHERE id = 1;
-- 결과: FOREIGN KEY constraint failed
-- 왜 막히나: rental이 member 1번을 가리키는 3건이 있어서, 지우면 존재하지 않는 회원을 참조하게 됨
-- 고치는 법: 자식(rental)을 먼저 삭제한 뒤 부모(member)를 삭제
-- 참고: SQLite는 PRAGMA foreign_keys = ON; 을 켜야 FK 검사가 동작함 (파일 상단에 명시)

-- 16. rental.member_id에 인덱스 생성 (INDEX)
-- 적용 이유: 회원별 대여 조회(JOIN, GROUP BY)에서 member_id를 자주 검색해서, 조회 속도를 높이기 위함
CREATE INDEX idx_rental_member_id ON rental(member_id);


