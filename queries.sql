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