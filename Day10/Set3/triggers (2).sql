
-- Day 10 - Set 3
-- Hospital Bed Capacity Control

IF DB_ID('HospitalAuditDB') IS NULL
    CREATE DATABASE HospitalAuditDB;
GO

USE HospitalAuditDB;
GO

-- 1. Create Ward Table
CREATE TABLE wards (
    ward_id INT PRIMARY KEY,
    ward_name VARCHAR(100),
    capacity INT NOT NULL,
    occupied_beds INT DEFAULT 0,
    CONSTRAINT CK_Ward_Capacity
        CHECK (capacity >= 0 AND occupied_beds >= 0
               AND occupied_beds <= capacity)
);
GO

-- 2. Create Admission Table
CREATE TABLE admissions (
    admission_id INT PRIMARY KEY,
    patient_name VARCHAR(100),
    ward_id INT,
    admission_date DATETIME2 DEFAULT SYSDATETIME(),

    CONSTRAINT FK_Admission_Ward
        FOREIGN KEY (ward_id) REFERENCES wards(ward_id)
);
GO

-- 3. Create Admission Audit Table
CREATE TABLE admission_audit (
    audit_id INT IDENTITY(1,1) PRIMARY KEY,
    admission_id INT,
    patient_name VARCHAR(100),
    ward_id INT,
    action_type VARCHAR(20),
    changed_by VARCHAR(128),
    changed_at DATETIME2 DEFAULT SYSDATETIME()
);
GO

-- 4. Insert Sample Wards
INSERT INTO wards
(ward_id, ward_name, capacity, occupied_beds)
VALUES
(1, 'General Ward', 3, 0),
(2, 'ICU', 2, 0),
(3, 'Emergency Ward', 4, 0);
GO

-- 5. Admission Capacity Validation Trigger
CREATE TRIGGER trg_CheckBedCapacity
ON admissions
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Reject the complete statement if any ward lacks capacity
    IF EXISTS (
        SELECT 1
        FROM inserted i
        LEFT JOIN wards w WITH (UPDLOCK, HOLDLOCK)
            ON i.ward_id = w.ward_id
        GROUP BY i.ward_id, w.capacity, w.occupied_beds
        HAVING
            w.ward_id IS NULL
            OR COUNT(*) + w.occupied_beds > w.capacity
    )
    BEGIN
        THROW 50002,
        'Admission rejected: Ward capacity is full or ward does not exist.',
        1;
    END;

    -- Insert valid admissions
    INSERT INTO admissions
    (admission_id, patient_name, ward_id, admission_date)
    SELECT
        admission_id,
        patient_name,
        ward_id,
        admission_date
    FROM inserted;

    -- Update occupied bed count
    UPDATE w
    SET occupied_beds = occupied_beds + x.admission_count
    FROM wards w
    INNER JOIN (
        SELECT ward_id, COUNT(*) AS admission_count
        FROM inserted
        GROUP BY ward_id
    ) x ON w.ward_id = x.ward_id;
END;
GO

-- 6. AFTER INSERT, UPDATE, DELETE Audit Trigger
CREATE TRIGGER trg_AdmissionAudit
ON admissions
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- INSERT audit
    INSERT INTO admission_audit
    (admission_id, patient_name, ward_id, action_type, changed_by)
    SELECT
        i.admission_id,
        i.patient_name,
        i.ward_id,
        'INSERT',
        SUSER_SNAME()
    FROM inserted i
    LEFT JOIN deleted d
        ON i.admission_id = d.admission_id
    WHERE d.admission_id IS NULL;

    -- UPDATE audit
    INSERT INTO admission_audit
    (admission_id, patient_name, ward_id, action_type, changed_by)
    SELECT
        i.admission_id,
        i.patient_name,
        i.ward_id,
        'UPDATE',
        SUSER_SNAME()
    FROM inserted i
    INNER JOIN deleted d
        ON i.admission_id = d.admission_id;

    -- DELETE audit
    INSERT INTO admission_audit
    (admission_id, patient_name, ward_id, action_type, changed_by)
    SELECT
        d.admission_id,
        d.patient_name,
        d.ward_id,
        'DELETE',
        SUSER_SNAME()
    FROM deleted d
    LEFT JOIN inserted i
        ON d.admission_id = i.admission_id
    WHERE i.admission_id IS NULL;
END;
GO

-- Check initial ward details
SELECT * FROM wards;
GO
