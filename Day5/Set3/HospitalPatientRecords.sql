

-- 1. DATABASE CREATION
CREATE DATABASE HospitalDB;
USE HospitalDB;


-- 2. CREATE TABLES (3NF)


-- PATIENT TABLE
CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    patient_name VARCHAR(100) NOT NULL,
    age INT,
    gender VARCHAR(10),
    address VARCHAR(255),
    phone VARCHAR(15),
    email VARCHAR(100),
    CONSTRAINT uq_patient_email UNIQUE (email)
);

-- DEPARTMENT TABLE
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

-- DOCTOR TABLE
CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY,
    doctor_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100),
    department_id INT,
    FOREIGN KEY (department_id)
    REFERENCES departments(department_id)
);

-- VISIT TABLE
CREATE TABLE visits (
    visit_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    visit_date DATE NOT NULL,
    diagnosis VARCHAR(255),
    prescription TEXT,
    status VARCHAR(20) DEFAULT 'Open',

    FOREIGN KEY (patient_id)
    REFERENCES patients(patient_id),

    FOREIGN KEY (doctor_id)
    REFERENCES doctors(doctor_id),

    CONSTRAINT chk_visit_date
    CHECK (visit_date BETWEEN '2000-01-01' AND '2099-12-31')
);

-- BILLING TABLE
CREATE TABLE billing (
    bill_id INT PRIMARY KEY,
    visit_id INT NOT NULL UNIQUE,
    bill_amount DECIMAL(10,2) NOT NULL,
    payment_status VARCHAR(20) DEFAULT 'Pending',

    FOREIGN KEY (visit_id)
    REFERENCES visits(visit_id),

    CONSTRAINT chk_bill_amount
    CHECK (bill_amount >= 0)
);


-- 3. ALTER TABLE OPERATIONS

-- SET 3: HOSPITAL PATIENT RECORDS AND CLINICAL NOTES

-- 1. DATABASE CREATION
CREATE DATABASE HospitalDB;
USE HospitalDB;


-- 2. CREATE TABLES (3NF)


-- PATIENT TABLE
CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    patient_name VARCHAR(100) NOT NULL,
    age INT,
    gender VARCHAR(10),
    address VARCHAR(255),
    phone VARCHAR(15),
    email VARCHAR(100),
    CONSTRAINT uq_patient_email UNIQUE (email)
);

-- DEPARTMENT TABLE
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

-- DOCTOR TABLE
CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY,
    doctor_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100),
    department_id INT,
    FOREIGN KEY (department_id)
    REFERENCES departments(department_id)
);

-- VISIT TABLE
CREATE TABLE visits (
    visit_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    visit_date DATE NOT NULL,
    diagnosis VARCHAR(255),
    prescription TEXT,
    status VARCHAR(20) DEFAULT 'Open',

    FOREIGN KEY (patient_id)
    REFERENCES patients(patient_id),

    FOREIGN KEY (doctor_id)
    REFERENCES doctors(doctor_id),

    CONSTRAINT chk_visit_date
    CHECK (visit_date BETWEEN '2000-01-01' AND '2099-12-31')
);

-- BILLING TABLE
CREATE TABLE billing (
    bill_id INT PRIMARY KEY,
    visit_id INT NOT NULL UNIQUE,
    bill_amount DECIMAL(10,2) NOT NULL,
    payment_status VARCHAR(20) DEFAULT 'Pending',

    FOREIGN KEY (visit_id)
    REFERENCES visits(visit_id),

    CONSTRAINT chk_bill_amount
    CHECK (bill_amount >= 0)
);


-- 3. ALTER TABLE OPERATIONS


-- ADD INSURANCE ID
ALTER TABLE patients
ADD insurance_id VARCHAR(30);

-- RENAME TABLE
ALTER TABLE departments
RENAME TO hospital_departments;

-- DROP A CONSTRAINT
ALTER TABLE patients
DROP INDEX uq_patient_email;

-- DISPLAY TABLES
SHOW TABLES;


-- 4. INSERT SAMPLE DATA


-- DEPARTMENTS
INSERT INTO hospital_departments VALUES
(1, 'Cardiology'),
(2, 'Neurology'),
(3, 'Orthopedics'),
(4, 'Dermatology');

-- DOCTORS
INSERT INTO doctors VALUES
(101, 'Dr. Arun Kumar', 'Cardiologist', 1),
(102, 'Dr. Priya Sharma', 'Neurologist', 2),
(103, 'Dr. Rahul Raj', 'Orthopedic Surgeon', 3),
(104, 'Dr. Meena Devi', 'Dermatologist', 4);

-- PATIENTS
INSERT INTO patients
(patient_id, patient_name, age, gender, address, phone, email, insurance_id)
VALUES
(1, 'Abdul Rahman', 22, 'Male', 'Chennai', '9876543210', 'abdul@gmail.com', 'INS101'),
(2, 'Harini', 25, 'Female', 'Coimbatore', '9876543211', 'harini@gmail.com', 'INS102'),
(3, 'Hashini', 24, 'Female', 'Hyderabad', '9876543212', 'hashini@gmail.com', 'INS103'),
(4, 'Karthik', 30, 'Male', 'Bangalore', '9876543213', 'karthik@gmail.com', 'INS104'),
(5, 'Arun', 28, 'Male', 'Chennai', '9876543214', 'arun@gmail.com', 'INS105');

-- VISITS
INSERT INTO visits
(visit_id, patient_id, doctor_id, visit_date, diagnosis, prescription)
VALUES
(201, 1, 101, '2026-11-02', 'Heart Pain', 'ECG and medication'),
(202, 2, 102, '2026-11-05', 'Migraine', 'Pain relief tablets'),
(203, 3, 103, '2026-11-10', 'Bone Fracture', 'Rest and physiotherapy'),
(204, 4, 104, '2026-11-12', 'Skin Allergy', 'Antihistamine tablets'),
(205, 1, 102, '2026-11-15', 'Headache', 'Medication and rest');

-- BILLING
INSERT INTO billing VALUES
(301, 201, 2500.00, 'Paid'),
(302, 202, 1500.00, 'Pending'),
(303, 203, 5000.00, 'Paid'),
(304, 204, 1200.00, 'Pending'),
(305, 205, 1000.00, 'Paid');

-- 5. UPDATE DATA


UPDATE patients
SET address = 'Chennai, Tamil Nadu'
WHERE patient_id = 1;

UPDATE visits
SET status = 'Completed'
WHERE visit_id = 201;


-- 6. DELETE DATA

INSERT INTO patients
(patient_id, patient_name, age, gender, address, phone, email)
VALUES
(6, 'Temporary Patient', 35, 'Male', 'Chennai', '9000000000',
 'temp@gmail.com');

DELETE FROM patients
WHERE patient_id = 6;


-- 7. RETRIEVE PATIENTS VISITED IN A GIVEN MONTH


SELECT p.patient_id, p.patient_name,
       v.visit_date, v.diagnosis
FROM patients p
JOIN visits v
ON p.patient_id = v.patient_id
WHERE v.visit_date >= '2026-11-01'
AND v.visit_date < '2026-12-01';


-- 8. RETRIEVE DOCTORS OF A DEPARTMENT USING WHERE AND LIKE


SELECT d.doctor_id, d.doctor_name,
       d.specialization, hd.department_name
FROM doctors d
JOIN hospital_departments hd
ON d.department_id = hd.department_id
WHERE hd.department_name LIKE '%Cardio%';


-- 9. SEARCH PATIENTS USING LIKE


SELECT *
FROM patients
WHERE patient_name LIKE 'A%';


-- 10. DISPLAY ALL TABLE RECORDS


SELECT * FROM patients;
SELECT * FROM doctors;
SELECT * FROM hospital_departments;
SELECT * FROM visits;
SELECT * FROM billing;



-- ADD INSURANCE ID
ALTER TABLE patients
ADD insurance_id VARCHAR(30);

-- RENAME TABLE
ALTER TABLE departments
RENAME TO hospital_departments;

-- DROP A CONSTRAINT
ALTER TABLE patients
DROP INDEX uq_patient_email;

-- DISPLAY TABLES
SHOW TABLES;


-- 4. INSERT SAMPLE DATA

-- DEPARTMENTS
INSERT INTO hospital_departments VALUES
(1, 'Cardiology'),
(2, 'Neurology'),
(3, 'Orthopedics'),
(4, 'Dermatology');

-- DOCTORS
INSERT INTO doctors VALUES
(101, 'Dr. Arun Kumar', 'Cardiologist', 1),
(102, 'Dr. Priya Sharma', 'Neurologist', 2),
(103, 'Dr. Rahul Raj', 'Orthopedic Surgeon', 3),
(104, 'Dr. Meena Devi', 'Dermatologist', 4);

-- PATIENTS
INSERT INTO patients
(patient_id, patient_name, age, gender, address, phone, email, insurance_id)
VALUES
(1, 'Abdul Rahman', 22, 'Male', 'Chennai', '9876543210', 'abdul@gmail.com', 'INS101'),
(2, 'Harini', 25, 'Female', 'Coimbatore', '9876543211', 'harini@gmail.com', 'INS102'),
(3, 'Hashini', 24, 'Female', 'Hyderabad', '9876543212', 'hashini@gmail.com', 'INS103'),
(4, 'Karthik', 30, 'Male', 'Bangalore', '9876543213', 'karthik@gmail.com', 'INS104'),
(5, 'Arun', 28, 'Male', 'Chennai', '9876543214', 'arun@gmail.com', 'INS105');

-- VISITS
INSERT INTO visits
(visit_id, patient_id, doctor_id, visit_date, diagnosis, prescription)
VALUES
(201, 1, 101, '2026-11-02', 'Heart Pain', 'ECG and medication'),
(202, 2, 102, '2026-11-05', 'Migraine', 'Pain relief tablets'),
(203, 3, 103, '2026-11-10', 'Bone Fracture', 'Rest and physiotherapy'),
(204, 4, 104, '2026-11-12', 'Skin Allergy', 'Antihistamine tablets'),
(205, 1, 102, '2026-11-15', 'Headache', 'Medication and rest');

-- BILLING
INSERT INTO billing VALUES
(301, 201, 2500.00, 'Paid'),
(302, 202, 1500.00, 'Pending'),
(303, 203, 5000.00, 'Paid'),
(304, 204, 1200.00, 'Pending'),
(305, 205, 1000.00, 'Paid');


-- 5. UPDATE DATA


UPDATE patients
SET address = 'Chennai, Tamil Nadu'
WHERE patient_id = 1;

UPDATE visits
SET status = 'Completed'
WHERE visit_id = 201;


-- 6. DELETE DATA

INSERT INTO patients
(patient_id, patient_name, age, gender, address, phone, email)
VALUES
(6, 'Temporary Patient', 35, 'Male', 'Chennai', '9000000000',
 'temp@gmail.com');

DELETE FROM patients
WHERE patient_id = 6;

-- 7. RETRIEVE PATIENTS VISITED IN A GIVEN MONTH


SELECT p.patient_id, p.patient_name,
       v.visit_date, v.diagnosis
FROM patients p
JOIN visits v
ON p.patient_id = v.patient_id
WHERE v.visit_date >= '2026-11-01'
AND v.visit_date < '2026-12-01';


-- 8. RETRIEVE DOCTORS OF A DEPARTMENT USING WHERE AND LIKE

SELECT d.doctor_id, d.doctor_name,
       d.specialization, hd.department_name
FROM doctors d
JOIN hospital_departments hd
ON d.department_id = hd.department_id
WHERE hd.department_name LIKE '%Cardio%';


-- 9. SEARCH PATIENTS USING LIKE


SELECT *
FROM patients
WHERE patient_name LIKE 'A%';

-- 10. DISPLAY ALL TABLE RECORDS


SELECT * FROM patients;
SELECT * FROM doctors;
SELECT * FROM hospital_departments;
SELECT * FROM visits;
SELECT * FROM billing;
