
-- Day 10 - Set 3
-- Testing and Evidence

USE HospitalAuditDB;
GO

-- TEST 1: Insert normal admissions

PRINT 'TEST 1: Normal Admissions';

INSERT INTO admissions
(admission_id, patient_name, ward_id)
VALUES
(101, 'Arun', 1),
(102, 'Bala', 1);

SELECT * FROM admissions;
SELECT * FROM wards;
GO

-- TEST 2: Fill the remaining bed

PRINT 'TEST 2: Fill Ward Capacity';

INSERT INTO admissions
(admission_id, patient_name, ward_id)
VALUES
(103, 'Divya', 1);

SELECT * FROM wards;
GO

-- TEST 3: Attempt admission when ward is full

PRINT 'TEST 3: Full Ward Admission';

BEGIN TRY

    INSERT INTO admissions
    (admission_id, patient_name, ward_id)
    VALUES
    (104, 'Kumar', 1);

END TRY
BEGIN CATCH

    SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;

END CATCH;
GO

-- TEST 4: Multi-row insert
-- Ward 2 has capacity 2.
-- Three admissions are attempted.
-- Entire statement should fail.

PRINT 'TEST 4: Multi Row Admission';

BEGIN TRY

    INSERT INTO admissions
    (admission_id, patient_name, ward_id)
    VALUES
    (201, 'Patient A', 2),
    (202, 'Patient B', 2),
    (203, 'Patient C', 2);

END TRY
BEGIN CATCH

    SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;

END CATCH;
GO

-- Verify ward 2
SELECT * FROM wards
WHERE ward_id = 2;

SELECT * FROM admissions
WHERE ward_id = 2;
GO

-- TEST 5: Valid multi-row admission

PRINT 'TEST 5: Valid Multi Row Admission';

INSERT INTO admissions
(admission_id, patient_name, ward_id)
VALUES
(204, 'Patient D', 2),
(205, 'Patient E', 2);

SELECT * FROM wards;
GO

-- TEST 6: Update admission details

PRINT 'TEST 6: Update Admission';

UPDATE admissions
SET patient_name = 'Arun Kumar'
WHERE admission_id = 101;

SELECT * FROM admission_audit
ORDER BY audit_id;
GO

-- TEST 7: Delete an admission

PRINT 'TEST 7: Delete Admission';

DELETE FROM admissions
WHERE admission_id = 102;

SELECT * FROM admission_audit
ORDER BY audit_id;
GO

-- TEST 8: Final verification

PRINT 'FINAL WARD DETAILS';

SELECT * FROM wards;

PRINT 'FINAL ADMISSION DETAILS';

SELECT * FROM admissions;

PRINT 'FINAL AUDIT HISTORY';

SELECT * FROM admission_audit
ORDER BY audit_id;
GO
