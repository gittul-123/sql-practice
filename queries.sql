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