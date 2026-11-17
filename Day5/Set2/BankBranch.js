
use('BankDB');

// 1. CREATE COLLECTION
db.createCollection("activity_logs");

// 2. INSERT 20 DOCUMENTS
db.activity_logs.insertMany([

    { customer_id: 1, event: "login", timestamp: new Date("2026-11-01T09:00:00") },
    { customer_id: 1, event: "login", timestamp: new Date("2026-11-02T10:00:00") },
    { customer_id: 1, event: "login", timestamp: new Date("2026-11-03T11:00:00") },
    { customer_id: 1, event: "login", timestamp: new Date("2026-11-04T12:00:00") },
    { customer_id: 1, event: "login", timestamp: new Date("2026-11-05T13:00:00") },

    { customer_id: 1, event: "logout", timestamp: new Date("2026-11-05T14:00:00") },
    { customer_id: 2, event: "login", timestamp: new Date("2026-11-01T09:30:00") },
    { customer_id: 2, event: "login", timestamp: new Date("2026-11-02T10:30:00") },
    { customer_id: 2, event: "transfer", timestamp: new Date("2026-11-03T11:30:00") },
    { customer_id: 2, event: "logout", timestamp: new Date("2026-11-03T12:00:00") },

    { customer_id: 3, event: "login", timestamp: new Date("2026-11-01T08:00:00") },
    { customer_id: 3, event: "login", timestamp: new Date("2026-11-02T08:30:00") },
    { customer_id: 3, event: "deposit", timestamp: new Date("2026-11-03T09:00:00") },
    { customer_id: 3, event: "withdrawal", timestamp: new Date("2026-11-04T09:30:00") },

    { customer_id: 4, event: "login", timestamp: new Date("2026-11-01T10:00:00") },
    { customer_id: 4, event: "login", timestamp: new Date("2026-11-02T10:00:00") },
    { customer_id: 4, event: "transfer", timestamp: new Date("2026-11-03T10:00:00") },

    { customer_id: 5, event: "login", timestamp: new Date("2026-11-01T11:00:00") },
    { customer_id: 5, event: "login", timestamp: new Date("2026-11-02T11:00:00") },
    { customer_id: 5, event: "logout", timestamp: new Date("2026-11-03T11:00:00") }

]);

// 3. DISPLAY ALL DOCUMENTS
db.activity_logs.find();

// 4. COUNT DOCUMENTS
db.activity_logs.countDocuments();

// 5. FIND CUSTOMER 1 ACTIVITY
db.activity_logs.find({ customer_id: 1 });

// 6. FIND ALL LOGIN EVENTS
db.activity_logs.find({ event: "login" });

// 7. SORT LATEST ACTIVITY FIRST
db.activity_logs.find().sort({ timestamp: -1 });

// 8. LAST FIVE LOGIN EVENTS OF CUSTOMER 1
db.activity_logs.find({
    customer_id: 1,
    event: "login"
})
    .sort({ timestamp: -1 })
    .limit(5);
