CREATE DATABASE LibraryManagementSystem;
use LibraryManagementSystem

-- Table 1: Categories
CREATE TABLE Categories (
    Category_ID INT PRIMARY KEY IDENTITY(1,1),  
    Category_Name VARCHAR(100) UNIQUE NOT NULL
);


INSERT INTO Categories (Category_Name) VALUES 
('Fiction'),
('Non-Fiction'),
('Science'),
('History'),
('Technology');


-- Table 2: Books (Stores Book Information)
CREATE TABLE Books (
    Book_ID INT PRIMARY KEY IDENTITY(1,1),
    Title VARCHAR(255) NOT NULL,
    Author VARCHAR(255),
    Publisher VARCHAR(255),
    ISBN VARCHAR(20) UNIQUE,
    Category_ID INT,
    Copies_Available INT DEFAULT 1,
    FOREIGN KEY (Category_ID) REFERENCES Categories(Category_ID)
);

INSERT INTO Books (Title, Author, Publisher, ISBN, Category_ID, Copies_Available)
VALUES 
('The Great Gatsby', 'F. Scott Fitzgerald', 'Scribner', '9780743273565', 1, 5),
('A Brief History of Time', 'Stephen Hawking', 'Bantam', '9780553380163', 3, 3);

-- Table 3: Members
CREATE TABLE Members (
    Member_ID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone_Number VARCHAR(15),
    Address TEXT,
    Membership_Date DATE,
    Expiry_Date DATE
);

INSERT INTO Members (Name, Email, Phone_Number, Address, Membership_Date, Expiry_Date)
VALUES 
('Henry White', 'Henry@example.com', '9876543210', '123 Main St, NY', '2024-01-15', '2025-01-15'),
('Jack Miller', 'Jack@example.com', '8765432109', '456 Elm St, CA', '2024-02-10', '2025-02-10');


-- Table 4: Librarians (Library Staff Details)
CREATE TABLE Librarians (
    Librarian_ID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone_Number VARCHAR(15)
);

INSERT INTO Librarians (Name, Email, Phone_Number)
VALUES 
('David Brown', 'david@example.com', '7896541230');

-- Table 5: Borrowing
CREATE TABLE Borrowing (
    Borrow_ID INT PRIMARY KEY IDENTITY(1,1),
    Member_ID INT,
    Book_ID INT,
    Issue_Date DATE,
    Due_Date DATE,
    Return_Date DATE NULL,
    FOREIGN KEY (Member_ID) REFERENCES Members(Member_ID),
    FOREIGN KEY (Book_ID) REFERENCES Books(Book_ID)
);

INSERT INTO Borrowing (Member_ID, Book_ID, Issue_Date, Due_Date)
VALUES 
(1, 1, '2024-06-01', '2024-06-15'),
(2, 2, '2024-06-05', '2024-06-19');


-- Table 6: Reservations (Tracks Book Reservations)
CREATE TABLE Reservations (
    Reservation_ID INT PRIMARY KEY IDENTITY(1,1),
    Member_ID INT,
    Book_ID INT,
    Reservation_Date DATE,
    Status VARCHAR(20) CHECK (Status IN ('Pending', 'Completed', 'Cancelled')),
  FOREIGN KEY (Member_ID) REFERENCES Members(Member_ID),
    FOREIGN KEY (Book_ID) REFERENCES Books(Book_ID)
);

INSERT INTO Reservations (Member_ID, Book_ID, Reservation_Date, Status)
VALUES (1, 2, '2024-06-20', 'Pending'),
(1,1,'2025-02-03', 'Completed');

-- Table 7: Fines
CREATE TABLE Fines (
    Fine_ID INT PRIMARY KEY IDENTITY(1,1),
    Member_ID INT,
    Borrow_ID INT,
    Amount DECIMAL(10,2),
    Status VARCHAR(20) CHECK(STATUS IN('Unpaid', 'Paid')),
    FOREIGN KEY (Member_ID) REFERENCES Members(Member_ID),
    FOREIGN KEY (Borrow_ID) REFERENCES Borrowing(Borrow_ID)
);

INSERT INTO Fines (Member_ID, Borrow_ID, Amount, Status)
VALUES 
(1, 1, 50.00, 'Unpaid');


-- Table 8: Suppliers (Stores Book Suppliers Information)
CREATE TABLE Suppliers (
    Supplier_ID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone_Number VARCHAR(15),
    Address TEXT
);

INSERT INTO Suppliers (Name, Email, Phone_Number, Address)
VALUES 
('Book Distributors Inc.', 'contact@bookdist.com', '9998887777', '789 Warehouse St, TX');

-- TABLE1 SELECTALL
CREATE PROCEDURE SelectAllCategories
AS
BEGIN
    SELECT * FROM Categories;
END;

--TABLE1 SELECTBYPK
CREATE PROCEDURE SelectCategoryByID 
    @Category_ID INT
AS
BEGIN
    SELECT * FROM Categories WHERE Category_ID = @Category_ID;
END;


EXEC SelectCategoryByID @Category_ID = 1;

--TABLE1 INSERT
CREATE PROCEDURE InsertCategory
    @Category_Name VARCHAR(100)
AS
BEGIN
    INSERT INTO Categories (Category_Name)
    VALUES (@Category_Name);
END;

EXEC InsertCategory @Category_Name = 'Science Fiction';

--TABLE 1 UPDATE
CREATE PROCEDURE UpdateCategory
    @Category_ID INT,
    @Category_Name VARCHAR(100)
AS
BEGIN
    UPDATE Categories
    SET Category_Name = @Category_Name
    WHERE Category_ID = @Category_ID;
END;

EXEC UpdateCategory @Category_ID = 2, @Category_Name = 'Historical Fiction';

--TABLE 1 DELETE
CREATE PROCEDURE DeleteCategory
    @Category_ID INT
AS
BEGIN
    DELETE FROM Categories WHERE Category_ID = @Category_ID;
END;

EXEC DeleteCategory @Category_ID = 5;


--TABLE2 SELECTALL
CREATE PROCEDURE SelectAllBooks
AS
BEGIN
    SELECT * FROM Books;
END;

EXEC SelectAllBooks;

--TABLE 2 SELECTBYPK
CREATE PROCEDURE SelectBookByID
    @Book_ID INT
AS
BEGIN
    SELECT * FROM Books WHERE Book_ID = @Book_ID;
END;

EXEC SelectBookByID @Book_ID = 1;


--TABLE 2 INSERT
CREATE PROCEDURE InsertBook
    @Title VARCHAR(255),
    @Author VARCHAR(255),
    @Publisher VARCHAR(255),
    @ISBN VARCHAR(20),
    @Category_ID INT,
    @Copies_Available INT
AS
BEGIN
    INSERT INTO Books (Title, Author, Publisher, ISBN, Category_ID, Copies_Available)
    VALUES (@Title, @Author, @Publisher, @ISBN, @Category_ID, @Copies_Available);
END;


EXEC InsertBook 
    @Title = 'Harry Potter',
    @Author = 'J.K. Rowling',
    @Publisher = 'Bloomsbury',
    @ISBN = '9780747532743',
    @Category_ID = 1,
    @Copies_Available = 5;


--TABLE2 UPDATE
CREATE PROCEDURE UpdateBook
    @Book_ID INT,
    @Title VARCHAR(255),
    @Author VARCHAR(255),
    @Publisher VARCHAR(255),
    @ISBN VARCHAR(20),
    @Category_ID INT,
    @Copies_Available INT
AS
BEGIN
    UPDATE Books
    SET Title = @Title, 
        Author = @Author, 
        Publisher = @Publisher, 
        ISBN = @ISBN, 
        Category_ID = @Category_ID, 
        Copies_Available = @Copies_Available
    WHERE Book_ID = @Book_ID;
END;


EXEC UpdateBook 
    @Book_ID = 2,
    @Title = 'The Hobbit',
    @Author = 'J.R.R. Tolkien',
    @Publisher = 'HarperCollins',
    @ISBN = '9780261102217',
    @Category_ID = 2,
    @Copies_Available = 3;


--TABLE 2 DELETE
CREATE PROCEDURE DeleteBook
    @Book_ID INT
AS
BEGIN
    DELETE FROM Books WHERE Book_ID = @Book_ID;
END;

EXEC DeleteBook @Book_ID = 3;



--TABLE 3 SELECTALL
CREATE PROCEDURE SelectAllMembers
AS
BEGIN
    SELECT * FROM Members;
END;

EXEC SelectAllMembers

--TABLE 3 SELECTBYPK
CREATE PROCEDURE SelectMemberByID
    @Member_ID INT
AS
BEGIN
    SELECT * FROM Members WHERE Member_ID = @Member_ID;
END;

EXEC SelectMemberByID @Member_ID = 1;


--TABLE 3 INSERT
CREATE PROCEDURE InsertMember
    @Name VARCHAR(255),
    @Email VARCHAR(100),
    @Phone_Number VARCHAR(15),
    @Address TEXT,
    @Membership_Date DATE,
    @Expiry_Date DATE
AS
BEGIN
    INSERT INTO Members (Name, Email, Phone_Number, Address, Membership_Date, Expiry_Date)
    VALUES (@Name, @Email, @Phone_Number, @Address, @Membership_Date, @Expiry_Date);
END;


EXEC InsertMember 
    @Name = 'John Doe',
    @Email = 'johndoe@example.com',
    @Phone_Number = '9876543210',
    @Address = '123 Main St, NY',
    @Membership_Date = '2024-06-01',
    @Expiry_Date = '2025-06-01';


--TABLE 3 UPDATE MEMBER
CREATE PROCEDURE UpdateMember
    @Member_ID INT,
    @Name VARCHAR(255),
    @Email VARCHAR(100),
    @Phone_Number VARCHAR(15),
    @Address TEXT,
    @Membership_Date DATE,
    @Expiry_Date DATE
AS
BEGIN
    UPDATE Members
    SET Name = @Name, 
        Email = @Email, 
        Phone_Number = @Phone_Number, 
        Address = @Address, 
        Membership_Date = @Membership_Date, 
        Expiry_Date = @Expiry_Date
    WHERE Member_ID = @Member_ID;
END;



EXEC UpdateMember 
    @Member_ID = 2,
    @Name = 'Jane Smith',
    @Email = 'janesmith@example.com',
    @Phone_Number = '8765432109',
    @Address = '456 Elm St, CA',
    @Membership_Date = '2024-07-15',
    @Expiry_Date = '2025-07-15';

--TABLE 3 DELETE
CREATE PROCEDURE DeleteMember
    @Member_ID INT
AS
BEGIN
    DELETE FROM Members WHERE Member_ID = @Member_ID;
END;


EXEC DeleteMember @Member_ID = 3;


--TABLE 4 SELECTALL
CREATE PROCEDURE SelectAllLibrarians
AS
BEGIN
    SELECT * FROM Librarians;
END;


EXEC SelectAllLibrarians;


--TABLE4 SELECTBYPK
CREATE PROCEDURE SelectLibrarianByID
    @Librarian_ID INT
AS
BEGIN
    SELECT * FROM Librarians WHERE Librarian_ID = @Librarian_ID;
END;


EXEC SelectLibrarianByID @Librarian_ID = 1;


--TABLE 4 INSERT
CREATE PROCEDURE InsertLibrarian
    @Name VARCHAR(255),
    @Email VARCHAR(100),
    @Phone_Number VARCHAR(15)
AS
BEGIN
    INSERT INTO Librarians (Name, Email, Phone_Number)
    VALUES (@Name, @Email, @Phone_Number);
END;


EXEC InsertLibrarian 
    @Name = 'Sarah Johnson',
    @Email = 'sarah@example.com',
    @Phone_Number = '9876543210';


--TABLE 4 UPDATE
CREATE PROCEDURE UpdateLibrarian
    @Librarian_ID INT,
    @Name VARCHAR(255),
    @Email VARCHAR(100),
    @Phone_Number VARCHAR(15)
AS
BEGIN
    UPDATE Librarians
    SET Name = @Name, 
        Email = @Email, 
        Phone_Number = @Phone_Number
    WHERE Librarian_ID = @Librarian_ID;
END;



EXEC UpdateLibrarian 
    @Librarian_ID = 2,
    @Name = 'Michael Brown',
    @Email = 'michael@example.com',
    @Phone_Number = '8765432109';



--TABLE 4 DELETE
CREATE PROCEDURE DeleteLibrarian
    @Librarian_ID INT
AS
BEGIN
    DELETE FROM Librarians WHERE Librarian_ID = @Librarian_ID;
END;


EXEC DeleteLibrarian @Librarian_ID = 3;


--TABLE 5 5SELECT ALL
CREATE PROCEDURE SelectAllBorrowing
AS
BEGIN
    SELECT * FROM Borrowing;
END;


EXEC SelectAllBorrowing;

--TABLE 5 SELECTBYPK
CREATE PROCEDURE SelectBorrowingByID
    @Borrow_ID INT
AS
BEGIN
    SELECT * FROM Borrowing WHERE Borrow_ID = @Borrow_ID;
END;


EXEC SelectBorrowingByID @Borrow_ID = 1;


--TABLE 5 INSERT
CREATE PROCEDURE InsertBorrowing
    @Member_ID INT,
    @Book_ID INT,
    @Issue_Date DATE,
    @Due_Date DATE
AS
BEGIN
    INSERT INTO Borrowing (Member_ID, Book_ID, Issue_Date, Due_Date)
    VALUES (@Member_ID, @Book_ID, @Issue_Date, @Due_Date);
END;


EXEC InsertBorrowing 
    @Member_ID = 1,
    @Book_ID = 2,
    @Issue_Date = '2024-06-20',
    @Due_Date = '2024-07-05';


-- TABLE 5 UPDATE
CREATE PROCEDURE UpdateBorrowing
    @Borrow_ID INT,
    @Return_Date DATE
AS
BEGIN
    UPDATE Borrowing
    SET Return_Date = @Return_Date
    WHERE Borrow_ID = @Borrow_ID;
END;


EXEC UpdateBorrowing 
    @Borrow_ID = 2,
    @Return_Date = '2024-07-02';

-- TABLE 5 DELETE
CREATE PROCEDURE DeleteBorrowing
    @Borrow_ID INT
AS
BEGIN
    DELETE FROM Borrowing WHERE Borrow_ID = @Borrow_ID;
END;


EXEC DeleteBorrowing @Borrow_ID = 4;


--TABLE 6 SELECT ALL
CREATE PROCEDURE SelectAllReservations
AS
BEGIN
    SELECT * FROM Reservations;
END;


EXEC SelectAllReservations;


--TABLE 6 SELECTBYPK
CREATE PROCEDURE SelectReservationByID
    @Reservation_ID INT
AS
BEGIN
    SELECT * FROM Reservations WHERE Reservation_ID = @Reservation_ID;
END;


EXEC SelectReservationByID @Reservation_ID = 2;


--TABLE 6 INSERT
CREATE PROCEDURE InsertReservation
    @Member_ID INT,
    @Book_ID INT,
    @Reservation_Date DATE,
    @Status VARCHAR(20)
AS
BEGIN
    INSERT INTO Reservations (Member_ID, Book_ID, Reservation_Date, Status)
    VALUES (@Member_ID, @Book_ID, @Reservation_Date, @Status);
END;


EXEC InsertReservation 
    @Member_ID = 1,
    @Book_ID = 2,
    @Reservation_Date = '2024-06-25',
    @Status = 'Pending';


--TABLE 6 UPDATE
CREATE PROCEDURE UpdateReservationStatus
    @Reservation_ID INT,
    @Status VARCHAR(20)
AS
BEGIN
    UPDATE Reservations
    SET Status = @Status
    WHERE Reservation_ID = @Reservation_ID;
END;


EXEC UpdateReservationStatus 
    @Reservation_ID = 2,
    @Status = 'Completed';


--TABLE 6 DELETE
CREATE PROCEDURE DeleteReservation
    @Reservation_ID INT
AS
BEGIN
    DELETE FROM Reservations WHERE Reservation_ID = @Reservation_ID;
END;


EXEC DeleteReservation @Reservation_ID = 3;



--TABLE 7 SELECTALL
CREATE PROCEDURE SelectAllFines
AS
BEGIN
    SELECT * FROM Fines;
END;

EXEC SelectAllFines;


--TABLE 7 SELECTBYPK
CREATE PROCEDURE SelectFineByID
    @Fine_ID INT
AS
BEGIN
    SELECT * FROM Fines WHERE Fine_ID = @Fine_ID;
END;


EXEC SelectFineByID @Fine_ID = 1;


--TABLE 7 INSERT
CREATE PROCEDURE InsertFine
    @Member_ID INT,
    @Borrow_ID INT,
    @Amount DECIMAL(10,2),
    @Status VARCHAR(20)
AS
BEGIN
    INSERT INTO Fines (Member_ID, Borrow_ID, Amount, Status)
    VALUES (@Member_ID, @Borrow_ID, @Amount, @Status);
END;


EXEC InsertFine 
    @Member_ID = 1,
    @Borrow_ID = 2,
    @Amount = 50.00,
    @Status = 'paid';


--TABLE 7 UPDATE
CREATE PROCEDURE UpdateFineStatus
    @Fine_ID INT,
    @Status VARCHAR(20)
AS
BEGIN
    UPDATE Fines
    SET Status = @Status
    WHERE Fine_ID = @Fine_ID;
END;


EXEC UpdateFineStatus 
    @Fine_ID = 1,
    @Status = 'Paid';


--TABLE 7 DELETE
CREATE PROCEDURE DeleteFine
    @Fine_ID INT
AS
BEGIN
    DELETE FROM Fines WHERE Fine_ID = @Fine_ID;
END;


EXEC DeleteFine @Fine_ID = 5;


--TABLE 7 calculate a fine
CREATE PROCEDURE CalculateFine
    @Borrow_ID INT
AS
BEGIN
    DECLARE @Due_Date DATE, @Return_Date DATE, @Days_Late INT, @FineAmount DECIMAL(10,2);
    
    -- Get Due Date & Return Date
    SELECT @Due_Date = Due_Date, @Return_Date = Return_Date 
    FROM Borrowing WHERE Borrow_ID = @Borrow_ID;
    
    -- Check if book is overdue
    IF @Return_Date > @Due_Date
    BEGIN
        SET @Days_Late = DATEDIFF(DAY, @Due_Date, @Return_Date);
        SET @FineAmount = @Days_Late * 10; -- Assuming fine is 10 per day

        INSERT INTO Fines (Member_ID, Borrow_ID, Amount, Status)
        SELECT Member_ID, Borrow_ID, @FineAmount, 'Unpaid' FROM Borrowing WHERE Borrow_ID = @Borrow_ID;
    END;
END;




EXEC CalculateFine @Borrow_ID = 2;



--TABLE 8 SELECTALL
CREATE PROCEDURE SelectAllSuppliers
AS
BEGIN
    SELECT * FROM Suppliers;
END;

EXEC SelectAllSuppliers;


--TABLE 8 SELECTBYPK
CREATE PROCEDURE SelectSupplierByID
    @Supplier_ID INT
AS
BEGIN
    SELECT * FROM Suppliers WHERE Supplier_ID = @Supplier_ID;
END;


EXEC SelectSupplierByID @Supplier_ID = 1;


--TABLE 8 INSERT
CREATE PROCEDURE InsertSupplier
    @Name VARCHAR(255),
    @Email VARCHAR(100),
    @Phone_Number VARCHAR(15),
    @Address TEXT
AS
BEGIN
    INSERT INTO Suppliers (Name, Email, Phone_Number, Address)
    VALUES (@Name, @Email, @Phone_Number, @Address);
END;


EXEC InsertSupplier 
    @Name = 'BookWorld Pvt Ltd',
    @Email = 'contact@bookworld.com',
    @Phone_Number = '9876543210',
    @Address = '123, Library Street, NY';



--TABLE 8 UPDATE
CREATE PROCEDURE UpdateSupplier
    @Supplier_ID INT,
    @Name VARCHAR(255),
    @Email VARCHAR(100),
    @Phone_Number VARCHAR(15),
    @Address TEXT
AS
BEGIN
    UPDATE Suppliers
    SET Name = @Name, Email = @Email, Phone_Number = @Phone_Number, Address = @Address
    WHERE Supplier_ID = @Supplier_ID;
END;


EXEC UpdateSupplier 
    @Supplier_ID = 1,
    @Name = 'BookWorld Pvt Ltd',
    @Email = 'support@bookworld.com',
    @Phone_Number = '9876543211',
    @Address = '456, New Library Street, NY';


--TABLE 8 DELETE
CREATE PROCEDURE DeleteSupplier
    @Supplier_ID INT
AS
BEGIN
    DELETE FROM Suppliers WHERE Supplier_ID = @Supplier_ID;
END;


EXEC DeleteSupplier @Supplier_ID = 2;




--LIST ALL UNPAID FINES

SELECT f.Fine_ID, m.Name, f.Amount, f.Status 
FROM Fines f
JOIN Members m ON f.Member_ID = m.Member_ID
WHERE f.Status = 'Unpaid';



--Count Book by category
SELECT c.Category_Name, COUNT(b.Book_ID) AS Total_Books
FROM Books b
JOIN Categories c ON b.Category_ID = c.Category_ID
GROUP BY c.Category_Name;



-- List all books supplied by a specific supplier
SELECT s.Name AS Supplier_Name, b.Title AS Book_Title, b.Author
FROM Suppliers s
JOIN Books b ON b.Publisher = s.Name;








