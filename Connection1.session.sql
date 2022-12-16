CREATE TABLE articles (
    article_ID INT PRIMARY KEY,
    article_name VARCHAR(50) NOT NULL
);

DESCRIBE articles;

CREATE TABLE customers (
    customer_ID INT PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL
);

INSERT INTO articles VALUES(
    1000, 'Margherita'
);

SELECT * FROM articles

DROP TABLE articles