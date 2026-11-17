

// SET 1: RETAIL SALES REPORTING
// MONGODB COMPLETE SCRIPT


use('RetailSalesDB');

// Start with a clean database for this assignment
db.dropDatabase();


// PART 1: CREATE COLLECTIONS

db.createCollection("customers");
db.createCollection("products");
db.createCollection("orders");
db.createCollection("order_items");
db.createCollection("payments");


// PART 2: INSERT SAMPLE DATA


db.customers.insertMany([
    { customer_id: 1, customer_name: "Alice", city: "Chennai" },
    { customer_id: 2, customer_name: "Bob", city: "Chennai" },
    { customer_id: 3, customer_name: "Carol", city: "Bangalore" },
    { customer_id: 4, customer_name: "David", city: "Mumbai" },
    { customer_id: 5, customer_name: "Eva", city: "Bangalore" },
    { customer_id: 6, customer_name: "Frank", city: "Delhi" },
    { customer_id: 7, customer_name: "Grace", city: "Mumbai" },
    { customer_id: 8, customer_name: "Hari", city: "Chennai" }
]);

db.products.insertMany([
    { product_id: 101, product_name: "Laptop", category: "Electronics", price: 50000 },
    { product_id: 102, product_name: "Phone", category: "Electronics", price: 20000 },
    { product_id: 103, product_name: "Chair", category: "Furniture", price: 5000 },
    { product_id: 104, product_name: "Desk", category: "Furniture", price: 10000 },
    { product_id: 105, product_name: "Headphones", category: "Accessories", price: 2000 },
    { product_id: 106, product_name: "Watch", category: "Accessories", price: 8000 },
    { product_id: 107, product_name: "Tablet", category: "Electronics", price: 15000 }
]);

db.orders.insertMany([
    { order_id: 1001, customer_id: 1, order_date: ISODate("2026-01-05") },
    { order_id: 1002, customer_id: 1, order_date: ISODate("2026-01-20") },
    { order_id: 1003, customer_id: 1, order_date: ISODate("2026-02-10") },
    { order_id: 1004, customer_id: 1, order_date: ISODate("2026-03-02") },
    { order_id: 1005, customer_id: 2, order_date: ISODate("2026-01-07") },
    { order_id: 1006, customer_id: 2, order_date: ISODate("2026-02-15") },
    { order_id: 1007, customer_id: 3, order_date: ISODate("2026-01-09") },
    { order_id: 1008, customer_id: 3, order_date: ISODate("2026-03-12") },
    { order_id: 1009, customer_id: 4, order_date: ISODate("2026-02-20") },
    { order_id: 1010, customer_id: 5, order_date: ISODate("2026-03-15") },
    { order_id: 1011, customer_id: 6, order_date: ISODate("2026-03-20") }
]);

db.order_items.insertMany([
    { item_id: 1, order_id: 1001, product_id: 101, quantity: 1, unit_price: 50000 },
    { item_id: 2, order_id: 1001, product_id: 105, quantity: 2, unit_price: 2000 },
    { item_id: 3, order_id: 1002, product_id: 102, quantity: 1, unit_price: 20000 },
    { item_id: 4, order_id: 1002, product_id: 105, quantity: 1, unit_price: 2000 },
    { item_id: 5, order_id: 1003, product_id: 104, quantity: 1, unit_price: 10000 },
    { item_id: 6, order_id: 1004, product_id: 102, quantity: 1, unit_price: 20000 },
    { item_id: 7, order_id: 1004, product_id: 106, quantity: 1, unit_price: 8000 },
    { item_id: 8, order_id: 1005, product_id: 103, quantity: 2, unit_price: 5000 },
    { item_id: 9, order_id: 1006, product_id: 107, quantity: 1, unit_price: 15000 },
    { item_id: 10, order_id: 1007, product_id: 101, quantity: 1, unit_price: 50000 },
    { item_id: 11, order_id: 1008, product_id: 103, quantity: 1, unit_price: 5000 },
    { item_id: 12, order_id: 1008, product_id: 104, quantity: 1, unit_price: 10000 },
    { item_id: 13, order_id: 1009, product_id: 102, quantity: 2, unit_price: 20000 },
    { item_id: 14, order_id: 1010, product_id: 105, quantity: 3, unit_price: 2000 },
    { item_id: 15, order_id: 1011, product_id: 106, quantity: 1, unit_price: 8000 }
]);

db.payments.insertMany([
    { payment_id: 5001, order_id: 1001, amount: 54000 },
    { payment_id: 5002, order_id: 1002, amount: 22000 },
    { payment_id: 5003, order_id: 1003, amount: null },
    { payment_id: 5004, order_id: 1004, amount: 28000 },
    { payment_id: 5005, order_id: 1005, amount: 10000 },
    { payment_id: 5006, order_id: 1007, amount: 50000 },
    { payment_id: 5007, order_id: 1008, amount: 15000 },
    { payment_id: 5008, order_id: 1010, amount: 6000 },
    { payment_id: 5009, order_id: 1011, amount: 8000 }
]);


// PART 3: THREE MONGODB AGGREGATION PIPELINES


// PIPELINE 1: MONTH-WISE SALES

db.orders.aggregate([
    {
        $lookup: {
            from: "order_items",
            localField: "order_id",
            foreignField: "order_id",
            as: "items"
        }
    },
    {
        $unwind: "$items"
    },
    {
        $group: {
            _id: {
                $dateToString: {
                    format: "%Y-%m",
                    date: "$order_date"
                }
            },
            monthly_sales: {
                $sum: {
                    $multiply: [
                        "$items.quantity",
                        "$items.unit_price"
                    ]
                }
            }
        }
    },
    {
        $sort: { _id: 1 }
    },
    {
        $project: {
            _id: 0,
            sales_month: "$_id",
            monthly_sales: 1
        }
    }
]);


// PIPELINE 2: TOP 5 PRODUCTS BY REVENUE

db.order_items.aggregate([
    {
        $group: {
            _id: "$product_id",
            total_revenue: {
                $sum: {
                    $multiply: [
                        "$quantity",
                        "$unit_price"
                    ]
                }
            }
        }
    },
    {
        $sort: {
            total_revenue: -1,
            _id: 1
        }
    },
    {
        $limit: 5
    },
    {
        $lookup: {
            from: "products",
            localField: "_id",
            foreignField: "product_id",
            as: "product"
        }
    },
    {
        $unwind: "$product"
    },
    {
        $project: {
            _id: 0,
            product_name: "$product.product_name",
            total_revenue: 1
        }
    }
]);


// PIPELINE 3: AVERAGE BASKET VALUE PER CITY

db.orders.aggregate([
    {
        $lookup: {
            from: "order_items",
            localField: "order_id",
            foreignField: "order_id",
            as: "items"
        }
    },
    {
        $unwind: "$items"
    },
    {
        $group: {
            _id: {
                order_id: "$order_id",
                customer_id: "$customer_id"
            },
            order_total: {
                $sum: {
                    $multiply: [
                        "$items.quantity",
                        "$items.unit_price"
                    ]
                }
            }
        }
    },
    {
        $lookup: {
            from: "customers",
            localField: "_id.customer_id",
            foreignField: "customer_id",
            as: "customer"
        }
    },
    {
        $unwind: "$customer"
    },
    {
        $group: {
            _id: "$customer.city",
            average_basket_value: {
                $avg: "$order_total"
            }
        }
    },
    {
        $project: {
            _id: 0,
            city: "$_id",
            average_basket_value: {
                $round: ["$average_basket_value", 2]
            }
        }
    },
    {
        $sort: { city: 1 }
    }
]);
