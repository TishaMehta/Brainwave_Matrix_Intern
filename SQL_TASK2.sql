--1 Create Database
CREATE DATABASE HospitalDB
USE HospitalDB

--2 CREATE TABLE

--DOCTOR TABLE
CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY identity(1,1),
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Specialty VARCHAR(100),
    Phone VARCHAR(15),
    Email VARCHAR(100),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

--PATIENTS TABLE
CREATE TABLE PATIENTS(
	PatientID INT PRIMARY KEY IDENTITY(1,1),
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	DateOfBirth DATE,
	Gender VARCHAR(15),
	PhoneNumber VARCHAR(15),
	Address VARCHAR(255)
);

-- Departments table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY IDENTITY(1,1),
    DepartmentName VARCHAR(100)
);

-- Staff Table

CREATE TABLE STAFF(
	StaffID INT PRIMARY KEY IDENTITY(1,1),
	FirstName VARCHAR(50),
	LastName  VARCHAR(50),
	Role VARCHAR(50),
	PhoneNumber VARCHAR(15),
	Email VARCHAR(100),
	DepartmentID INT,
	FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

--Appointments Table
CREATE TABLE Appointments(
    AppointmentID INT PRIMARY KEY IDENTITY(1,1),
    PatientID INT,
    DoctorID INT,
    AppointmentDate DATETIME DEFAULT GETDATE(),
    Reason VARCHAR(255),
    FOREIGN KEY (PatientID) REFERENCES [PATIENTS](PatientID),
    FOREIGN KEY (DoctorID) REFERENCES [Doctors](DoctorID)
);


--Medical Records table

CREATE TABLE MedicalRecords(
	RecordID int primary key identity(1,1),
	PatientID int,
	Diagnosis varchar(255),
	Treatment varchar(255),
	Date date,
	FOREIGN KEY (PatientID) REFERENCES PATIENTS(PatientID)
);

--Labe Reports table

CREATE TABLE LabReports(
	ReportID INT PRIMARY KEY IDENTITY(1,1),
	PatientID INT,
	TestType VARCHAR(100),
	Result VARCHAR(255),
	ReporDate DATE,
	FOREIGN KEY (PatientID) REFERENCES PATIENTS(PatientID)
);

-- Rooms TABLE

CREATE TABLE Rooms(
	RoomID INT PRIMARY KEY IDENTITY(1,1),
	RoomType VARCHAR(50),
	Status VARCHAR(50)
);


--Bills Table

CREATE TABLE Bills(
	BillID INT PRIMARY KEY IDENTITY(1,1),
	PatientID INT,
	TotalAmount DECIMAL(10,2),
	PaymentStatus VARCHAR(20),
    BillingDate DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (PatientID) REFERENCES PATIENTS(PatientID)
);

--Emergency Contacts table

CREATE TABLE EmergencyContacts(
	ContactID INT PRIMARY KEY IDENTITY(1,1),
	PatientID INT,
	ContactName VARCHAR(100),
	Relationship VARCHAR(50),
	PhoneNumber VARCHAR(15),
	FOREIGN KEY (PatientID) REFERENCES PATIENTS(PatientID)
);

--3 INSERT RECORD ALL TABLE 
INSERT INTO Departments(DepartmentName)
VALUES('Cardiology'), ('Neurology');

INSERT INTO PATIENTS(FirstName, LastName, DateOfBirth, Gender, PhoneNumber, Address)
VALUES('John', 'Doe', '2025-03-17', 'Male', '1478529636', '123 Elm St'),
('Jane', 'Smith', '2025-03-18', 'Female', '7896541236', '456 oak st');

insert into Doctors(FirstName, LastName, Specialty, Phone, Email, DepartmentID)
values ('Emily', 'CLark', 'Cardiology', '7539518526', 'emily.lee@hospital.com', 1)

insert into STAFF(FirstName, LastName, Email, PhoneNumber, Role, DepartmentID)
values ('Alice', 'Johnson', 'alice@hospital.com', '7419638526', 'Nurse', 1),
('Rpbert', 'Brown', 'robert.brown@gmail.com', '7429528634', 'Doctor', 2);

insert into Appointments(PatientID, DoctorID, AppointmentDate, Reason)
values(2,1, '2025-03-17', 'Routin Checkup'),
(1, 1, '2025-03-19', 'Headache');

INSERT INTO MedicalRecords(PatientID, Diagnosis, Treatment, Date)
VALUES(1, 'Hyperyension', 'Medication and Lifestyle Change', '2025-03-18'),
(2, 'Migraine', 'Pain Management Therapy', '2025-03-17');

INSERT INTO LabReports(PatientID, TestType, Result, ReporDate)
VALUES (1, 'Blood test', 'normal', '2025-03-17'),
(2, 'X-Ray', 'Fracture Detected', '2025-03-18');

INSERT INTO Rooms( RoomType, Status)
VALUES('ICU', 'Available'),
('General', 'Available'),
('Single', 'Occupied');

INSERT INTO Bills(PatientID, TotalAmount, PaymentStatus, BillingDate)
VALUES(1, '2500', 'Paid', '2025-03-18'),
(2, '3500', 'Unpaid', '2025-03-20');

INSERT INTO EmergencyContacts(PatientID, ContactName, Relationship, PhoneNumber)
VALUES(1,'David Brown', 'Father', '7539638524'),
(2, 'Carol Johnson', 'Mother', '7418956239');


--4 Queries

--Retrive all Patients
SELECT * FROM PATIENTS

-- Update a patient's phone number
UPDATE PATIENTS SET PhoneNumber = '1111253696' WHERE FirstName = 'jANE'

--DELETE A Patients
DELETE FROM PATIENTS WHERE FirstName = 'Alice'

--FIND A DOCTORS BY SPECIALTY
SELECT FirstName, LastName from Doctors
WHERE Specialty = 'Cardiology'

--CALCULATE TOTAL REVENUE FROM BILLS
SELECT SUM(TOTALAMOUNT) AS TotalRevenue FROM Bills WHERE PaymentStatus = 'Paid'

-- FIND APPOINTMNETS FOR A SPECIFIC DOCTOR
SELECT A.AppointmentID, P.FirstName AS PatientName, A.AppointmentDate  
FROM Appointments A
JOIN PATIENTS P ON A.PatientID = P.PatientID
WHERE A.DoctorID = (SELECT DoctorID FROM Doctors WHERE LastName = 'Clark')

--FIND PATIENTS WITH NO APPOINTMENTS
SELECT * FROM PATIENTS WHERE PatientID not in (SELECT PatientID FROM Appointments)

--Get doctors with the highest numbe of appointments
SELECT D.FirstName, D.LastName, COUNT(A.AppointmentID) AS AppointmentCount 
FROM Doctors D
JOIN Appointments A ON D.DoctorID = A.DoctorID
GROUP BY D.DoctorID, D.FirstName, D.LastName
ORDER BY AppointmentCount DESC;

--List Patients and their last diagnosis
SELECT P.FirstName, P.LastName, M.Diagnosis, M. Date
FROM PATIENTS P 
JOIN MedicalRecords M
ON P.PatientID = M.PatientID
WHERE M.Date = (SELECT MAX(Date) FROM MedicalRecords where PatientID = P.PatientID)

--Find Patients with no emergency contact listed
SELECT * FROM PATIENTS 
WHERE PatientID NOT IN (SELECT PatientID FROM EmergencyContacts)

--GET TOTAL BILL PER PATIENT WITH PAYMENT STATUS
SELECT P.FirstName, P.LastName, SUM(B.TotalAmount) as TotalBill, b.PaymentStatus
FROM PATIENTS P
JOIN Bills B
ON P.PatientID = B.PatientID
GROUP BY P.PatientID, B.PaymentStatus, P.FirstName, P.LastName

--COUNT how many rooms are occupiedd per room type
SELECT RoomType, COUNT(*) AS OccupiedCount
FROM Rooms
where Status = 'Occupied'
GROUP BY RoomType

--Lista all patients with unpaid bills
SELECT P.FirstName, P.LastName, B.TotalAmount, B.PaymentStatus
FROM PATIENTS P
JOIN Bills B
ON P.PatientID = B.PatientID
WHERE B.PaymentStatus = 'Unpaid' 

--total revenue
select SUM(TotalAmount) as TotalRevenue
from Bills

--Find Department with most doctors
WITH DoctorCounts AS (
    SELECT D.DepartmentID, 
           DP.DepartmentName,
           COUNT(D.DoctorID) AS DoctorCount
    FROM Doctors D
    JOIN Departments DP ON D.DepartmentID = DP.DepartmentID
    GROUP BY D.DepartmentID, DP.DepartmentName
)
SELECT TOP 1 DepartmentName, DoctorCount
FROM DoctorCounts
ORDER BY DoctorCount DESC;
