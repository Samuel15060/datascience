CREATE DATABASE LibManSys;
USE LibManSys;

CREATE TABLE books (
    Bookid INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(100) NOT NULL,
    Author VARCHAR(100) NOT NULL,
    Genre VARCHAR(100),
    Price DECIMAL(5,2) CHECK (Price > 0),
    PublishedYear INT DEFAULT 2000
);

CREATE TABLE members( 
    memberID INT AUTO_INCREMENT PRIMARY KEY, 
    firstName VARCHAR(50) NOT NULL, 
    lastName VARCHAR(50) NOT NULL, 
    email VARCHAR(100) NOT NULL UNIQUE, 
    phone CHAR(10) CHECK (CHAR_LENGTH(phone) = 10) 
);

CREATE TABLE transactions( 
    transactionID INT AUTO_INCREMENT PRIMARY KEY, 
    bookID INT NOT NULL, 
    memberID INT NOT NULL, 
    issueDate DATE NOT NULL, 
    returnDate DATE, 
    fineAmount DECIMAL(5,2) DEFAULT 0, 
    FOREIGN KEY(bookID) REFERENCES books(Bookid), 
    FOREIGN KEY(memberID) REFERENCES members(memberID) 
);

INSERT INTO books (Title, Author, Genre, Price, PublishedYear) VALUES
('The Silent Patient', 'Alex Michaelides', 'Thriller', 14.99, 2019),
('Where the Crawdads Sing', 'Delia Owens', 'Fiction', 16.99, 2018),
('Atomic Habits', 'James Clear', 'Self-Help', 20.99, 2018),
('Dune', 'Frank Herbert', 'Science Fiction', 18.50, 1965),
('To Kill a Mockingbird', 'Harper Lee', 'Classic', 12.99, 1960),
('The Hobbit', 'J.R.R. Tolkien', 'Fantasy', 15.50, 1937),
('Becoming', 'Michelle Obama', 'Biography', 22.99, 2018),
('The Psychology of Money', 'Morgan Housel', 'Finance', 19.99, 2020),
('The Midnight Library', 'Matt Haig', 'Fiction', 13.99, 2020),
('1984', 'George Orwell', 'Dystopian', 11.50, 1949);

INSERT INTO members (firstName, lastName, email, phone) VALUES
('John', 'Doe', 'john.doe@example.com', '1234567890'),
('Jane', 'Smith', 'jane.smith@example.com', '9876543210'),
('Michael', 'Johnson', 'michael.johnson@example.com', '4567890123'),
('Emily', 'Davis', 'emily.davis@example.com', '3216540987'),
('Robert', 'Brown', 'robert.brown@example.com', '6543215678'),
('Sarah', 'Miller', 'sarah.miller@example.com', '7890123456'),
('David', 'Wilson', 'david.wilson@example.com', '2345678901'),
('Jessica', 'Moore', 'jessica.moore@example.com', '8901234567'),
('William', 'Anderson', 'william.anderson@example.com', '5678901234'),
('Olivia', 'Taylor', 'olivia.taylor@example.com', '3456789012');

INSERT INTO transactions (bookID, memberID, issueDate, returnDate) VALUES
(1, 3, '2024-01-10', '2024-01-20'),
(2, 5, '2024-01-12', '2024-01-22'),
(3, 1, '2024-01-15', '2024-01-25'),
(4, 7, '2024-01-18', '2024-01-28'),
(5, 2, '2024-01-20', '2024-01-30'),
(6, 8, '2024-01-22', '2024-02-01'),
(7, 4, '2024-01-25', '2024-02-04'),
(8, 6, '2024-01-28', '2024-02-07'),
(9, 10, '2024-01-30', '2024-02-09'),
(10, 9, '2024-02-02', '2024-02-12');

INSERT INTO transactions (bookID, memberID, issueDate, returnDate) VALUES
(2, 4, '2024-01-10', NULL);

SELECT * FROM books;
SELECT * FROM members;
SELECT * FROM transactions;

SELECT * FROM books WHERE Price > 15;

SELECT firstName, lastName FROM members WHERE lastName = 'Smith';

SELECT * FROM books ORDER BY price DESC;

SELECT Genre, COUNT(*) AS Count_genre 
FROM Books
GROUP BY Genre
HAVING COUNT(*) > 1;

SELECT * FROM members WHERE firstName LIKE 'J%';

SELECT * FROM books WHERE PublishedYear > 2010 ORDER BY Title ASC;

SELECT memberID, COUNT(*) AS Count_trans 
FROM transactions
GROUP BY memberID;

SELECT transactionID, bookID, 
IFNULL(returnDate,'Not Returned') AS ReturnStatus  
FROM transactions;

SELECT transactionID, 
CASE
  WHEN DATEDIFF(returnDate, issueDate) <= 14 THEN NULL
  ELSE 50
END AS fineAmount
FROM transactions;

SELECT Title, Price,
CASE
  WHEN Price < 10 THEN 'LOW PRICE'
  WHEN Price BETWEEN 10 AND 20 THEN 'MEDIUM PRICE'
  ELSE 'HIGH PRICE'
END AS PriceCategory
FROM books;

SELECT title, 
IF(Price > 20, 'Expensive', 'Affordable') AS PriceStatus
FROM books;

SELECT 
    T.transactionID,
    B.Title AS BookTitle,
    CONCAT(M.firstName, ' ', M.lastName) AS MemberName,
    issueDate
FROM transactions T
INNER JOIN books B ON T.bookID = B.Bookid
INNER JOIN members M ON T.memberID = M.memberID;

SELECT 
    T.transactionID,
    B.Title AS BookTitle,
    T.issueDate
FROM books B
LEFT JOIN transactions T ON B.bookID = T.Bookid;

SELECT 
    B.Title AS BookTitle,
    CONCAT(M.firstName, ' ', M.lastName) AS MemberName,
    M.memberID
FROM members M
LEFT JOIN transactions T ON M.memberID = T.memberID
LEFT JOIN books B ON T.Bookid = B.bookID

UNION

SELECT 
    B.Title AS BookTitle,
    CONCAT(M.firstName, ' ', M.lastName) AS MemberName,
    M.memberID
FROM Books B
LEFT JOIN transactions T ON B.bookID = T.Bookid
LEFT JOIN members M ON T.memberID = M.memberID;

SELECT 
    T.transactionID,
    CONCAT(M.firstName, ' ', M.lastName) AS MemberName,
    T.issueDate
FROM transactions T
RIGHT JOIN members M ON T.memberID = M.memberID;

SELECT 
    T.transactionID,
    CONCAT(M.firstName, ' ', M.lastName) AS MemberName,
    T.issueDate,
    B.Title AS BookTitle
FROM transactions T
RIGHT JOIN members M ON T.memberID = M.memberID
LEFT JOIN books B ON T.Bookid = B.bookID;
