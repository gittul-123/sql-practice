-- DB: SQLite / SQLite 전용 문법: AUTOINCREMENT

CREATE TABLE member (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	name TEXT,
	phone TEXT NOT NULL,
	email TEXT UNIQUE
)

CREATE TABLE category (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	category_name TEXT NOT NULL UNIQUE
)

CREATE TABLE book (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	title TEXT NOT NULL,
	author TEXT,
	published_date DATE,
	category_id INTEGER NOT NULL,
	FOREIGN KEY (category_id) REFERENCES category(id)
)

CREATE TABLE rental (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
	member_id INTEGER NOT NULL,
	book_id INTEGER NOT NULL,
	rental_date DATE NOT NULL,
	return_date DATE,
    FOREIGN KEY (member_id) REFERENCES member(id),
	FOREIGN KEY (book_id) REFERENCES book(id)
)