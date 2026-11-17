
// SET 3: HOSPITAL CLINICAL NOTES

// Select database
use('HospitalDB');

// Create clinical_notes collection with validation
db.createCollection('clinical_notes', {
    validator: {
        $jsonSchema: {
            bsonType: 'object',
            required: ['patient_id', 'visit_date', 'diagnosis'],
            properties: {
                patient_id: {
                    bsonType: 'int',
                    description: 'Patient ID is required'
                },
                visit_date: {
                    bsonType: 'date',
                    description: 'Visit date must be a date'
                },
                diagnosis: {
                    bsonType: 'string',
                    description: 'Diagnosis is required'
                },
                clinical_note: {
                    bsonType: 'object',
                    description: 'Clinical notes can have variable structure'
                }
            }
        }
    },
    validationLevel: 'strict',
    validationAction: 'error'
});

// INSERT TWO DOCUMENTS WITH DIFFERENT STRUCTURES
db.clinical_notes.insertMany([

    {
        patient_id: 1,
        visit_date: ISODate('2026-11-02'),
        diagnosis: 'Heart Pain',
        clinical_note: {
            symptoms: ['Chest pain', 'Breathlessness'],
            vitals: {
                blood_pressure: '120/80',
                heart_rate: 85
            },
            assessment: 'Requires cardiac evaluation'
        }
    },

    {
        patient_id: 2,
        visit_date: ISODate('2026-11-05'),
        diagnosis: 'Migraine',
        clinical_note: {
            observations: 'Severe headache',
            lab_results: {
                blood_test: 'Normal',
                glucose: 95
            },
            follow_up: {
                required: true,
                days: 7
            }
        }
    }

]);

// DISPLAY ALL DOCUMENTS
db.clinical_notes.find();

// QUERY DOCUMENTS BY DIAGNOSIS
db.clinical_notes.find({
    diagnosis: 'Heart Pain'
});

// QUERY MIGRAINE DIAGNOSIS
db.clinical_notes.find({
    diagnosis: 'Migraine'
});

// DISPLAY DOCUMENTS IN TABULAR-FRIENDLY FORMAT
db.clinical_notes.find(
    {},
    {
        _id: 0,
        patient_id: 1,
        diagnosis: 1,
        visit_date: 1
    }
);
