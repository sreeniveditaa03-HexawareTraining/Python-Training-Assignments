
// ============================================
// DAY 9: RETAIL ORDER FULFILMENT
// MONGODB 8.0
// ============================================

// Select database

use('RetailFulfilmentDB');

// ============================================
// CREATE ORDERS COLLECTION
// ============================================

db.orders.drop();

db.orders.insertMany([
    {
        order_id: 101,
        customer_name: "Arun",
        order_date: new Date("2026-11-15"),
        status: "Pending",
        total_amount: 50000
    },
    {
        order_id: 102,
        customer_name: "Rahul",
        order_date: new Date("2026-11-16"),
        status: "Shipped",
        total_amount: 1500
    },
    {
        order_id: 103,
        customer_name: "Kumar",
        order_date: new Date("2026-11-17"),
        status: "Pending",
        total_amount: 12000
    },
    {
        order_id: 104,
        customer_name: "Vijay",
        order_date: new Date("2026-11-18"),
        status: "Delivered",
        total_amount: 25000
    },
    {
        order_id: 105,
        customer_name: "Ajay",
        order_date: new Date("2026-11-19"),
        status: "Shipped",
        total_amount: 8000
    },
    {
        order_id: 106,
        customer_name: "Ravi",
        order_date: new Date("2026-11-20"),
        status: "Pending",
        total_amount: 3000
    }
]);


// ============================================
// DISPLAY ALL ORDERS
// ============================================

db.orders.find();


// ============================================
// CREATE MONGODB VIEW
// ============================================

db.createView(
    "vw_order_status_counts",
    "orders",
    [
        {
            $group: {
                _id: "$status",
                total_orders: {
                    $sum: 1
                },
                total_amount: {
                    $sum: "$total_amount"
                }
            }
        },
        {
            $project: {
                _id: 0,
                order_status: "$_id",
                total_orders: 1,
                total_amount: 1
            }
        },
        {
            $sort: {
                order_status: 1
            }
        }
    ]
);


// ============================================
// DISPLAY VIEW RESULTS
// ============================================

db.vw_order_status_counts.find();


// ============================================
// ADDITIONAL VERIFICATION
// ============================================

// Count orders by status

db.orders.aggregate([
    {
        $group: {
            _id: "$status",
            count: { $sum: 1 }
        }
    }
]);

// Display pending orders

db.orders.find({
    status: "Pending"
});

// Display shipped orders

db.orders.find({
    status: "Shipped"
});

// Display total order count

db.orders.countDocuments();
