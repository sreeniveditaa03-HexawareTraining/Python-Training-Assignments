
// =====================================================
// DAY 9 - SET 3: TELECOM LOW-BALANCE FOLLOW-UP
// MONGODB 8.0
// =====================================================

// Select database

use('TelecomRechargeDB');


// =====================================================
// 1. CREATE NOTIFICATION LOG COLLECTION
// =====================================================

db.notification_log.drop();

db.notification_log.insertMany([

    {
        notification_id: 101,
        subscriber_id: 1,
        subscriber_name: "Arun",
        message: "Low balance alert! Please recharge.",
        is_read: false,
        notification_date: new Date("2026-11-20")
    },

    {
        notification_id: 102,
        subscriber_id: 1,
        subscriber_name: "Arun",
        message: "Your recharge validity is ending.",
        is_read: false,
        notification_date: new Date("2026-11-21")
    },

    {
        notification_id: 103,
        subscriber_id: 2,
        subscriber_name: "Rahul",
        message: "Recharge successful.",
        is_read: true,
        notification_date: new Date("2026-11-20")
    },

    {
        notification_id: 104,
        subscriber_id: 3,
        subscriber_name: "Kumar",
        message: "Your balance is below 50.",
        is_read: false,
        notification_date: new Date("2026-11-21")
    },

    {
        notification_id: 105,
        subscriber_id: 4,
        subscriber_name: "Vijay",
        message: "Recharge reminder.",
        is_read: true,
        notification_date: new Date("2026-11-21")
    },

    {
        notification_id: 106,
        subscriber_id: 5,
        subscriber_name: "Ajay",
        message: "Low balance alert.",
        is_read: false,
        notification_date: new Date("2026-11-22")
    },

    {
        notification_id: 107,
        subscriber_id: 3,
        subscriber_name: "Kumar",
        message: "Recharge reminder.",
        is_read: false,
        notification_date: new Date("2026-11-22")
    }

]);


// =====================================================
// 2. DISPLAY ALL NOTIFICATIONS
// =====================================================

db.notification_log.find();


// =====================================================
// 3. CREATE MONGODB VIEW
// Unread count per subscriber
// =====================================================

db.createView(

    "vw_unread_notification_count",

    "notification_log",

    [

        // Filter unread notifications

        {
            $match: {
                is_read: false
            }
        },

        // Group notifications by subscriber

        {
            $group: {
                _id: "$subscriber_id",

                subscriber_name: {
                    $first: "$subscriber_name"
                },

                unread_count: {
                    $sum: 1
                }
            }
        },

        // Display required fields

        {
            $project: {
                _id: 0,
                subscriber_id: "$_id",
                subscriber_name: 1,
                unread_count: 1
            }
        },

        // Sort by subscriber ID

        {
            $sort: {
                subscriber_id: 1
            }
        }

    ]

);


// =====================================================
// 4. DISPLAY MONGODB VIEW
// =====================================================

db.vw_unread_notification_count.find();


// =====================================================
// 5. ADDITIONAL VERIFICATION
// =====================================================

// Find unread notifications

db.notification_log.find({
    is_read: false
});

// Find notifications of subscriber 1

db.notification_log.find({
    subscriber_id: 1
});

// Count all notifications

db.notification_log.countDocuments();

// Count unread notifications

db.notification_log.countDocuments({
    is_read: false
});

// Mark one notification as read

db.notification_log.updateOne(
    {
        notification_id: 101
    },
    {
        $set: {
            is_read: true
        }
    }
);

// Verify updated view

db.vw_unread_notification_count.find();
