
// ==================================================
// DAY 9 - SET 2: INSURANCE PREMIUM PROCESSING
// MONGODB 8.0
// ==================================================

// Select database

use('InsurancePremiumDB');


// ==================================================
// 1. CREATE CUSTOMER COMMUNICATIONS COLLECTION
// ==================================================

db.customer_communications.drop();

db.customer_communications.insertMany([

    {
        communication_id: 101,
        customer_name: "Arun",
        policy_number: "POL101",
        communication_type: "Complaint",
        subject: "Premium deduction issue",
        message: "Incorrect premium amount deducted",
        status: "Unresolved",
        communication_date: new Date("2026-11-15")
    },

    {
        communication_id: 102,
        customer_name: "Rahul",
        policy_number: "POL102",
        communication_type: "Complaint",
        subject: "Claim delay",
        message: "Claim settlement is delayed",
        status: "Resolved",
        communication_date: new Date("2026-11-16")
    },

    {
        communication_id: 103,
        customer_name: "Kumar",
        policy_number: "POL103",
        communication_type: "Complaint",
        subject: "Policy renewal issue",
        message: "Unable to renew insurance policy",
        status: "Unresolved",
        communication_date: new Date("2026-11-17")
    },

    {
        communication_id: 104,
        customer_name: "Vijay",
        policy_number: "POL104",
        communication_type: "Feedback",
        subject: "Service feedback",
        message: "Good customer service",
        status: "Resolved",
        communication_date: new Date("2026-11-18")
    },

    {
        communication_id: 105,
        customer_name: "Ajay",
        policy_number: "POL105",
        communication_type: "Complaint",
        subject: "Incorrect policy details",
        message: "Policy information is incorrect",
        status: "Unresolved",
        communication_date: new Date("2026-11-19")
    },

    {
        communication_id: 106,
        customer_name: "Ravi",
        policy_number: "POL106",
        communication_type: "Complaint",
        subject: "Payment failure",
        message: "Premium payment failed",
        status: "Unresolved",
        communication_date: new Date("2026-11-20")
    }

]);


// ==================================================
// 2. DISPLAY ALL CUSTOMER COMMUNICATIONS
// ==================================================

db.customer_communications.find();


// ==================================================
// 3. CREATE MONGODB VIEW
// Filter unresolved complaints only
// ==================================================

db.createView(

    "vw_unresolved_complaints",

    "customer_communications",

    [
        {
            $match: {
                communication_type: "Complaint",
                status: "Unresolved"
            }
        },

        {
            $project: {
                _id: 0,
                communication_id: 1,
                customer_name: 1,
                policy_number: 1,
                subject: 1,
                message: 1,
                status: 1,
                communication_date: 1
            }
        }

    ]

);


// ==================================================
// 4. DISPLAY MONGODB VIEW
// ==================================================

db.vw_unresolved_complaints.find();


// ==================================================
// 5. ADDITIONAL VERIFICATION
// ==================================================

// Count unresolved complaints

db.vw_unresolved_complaints.countDocuments();

// Find unresolved complaints of a particular customer

db.vw_unresolved_complaints.find({
    customer_name: "Arun"
});

// Display only complaint subjects

db.vw_unresolved_complaints.find(
    {},
    {
        _id: 0,
        customer_name: 1,
        subject: 1
    }
);

// Display total communications

db.customer_communications.countDocuments();
