

// STEP 1: Select database
use("Day7_RetailReturnsMongo");

// STEP 2: Clear previous sample collections
db.returns.drop();
db.customers.drop();
db.products.drop();
db.stores.drop();
db.returnFeedback.drop();

// STEP 3: Insert customer details
db.customers.insertMany([
    {_id:1, name:"Aarav"},
    {_id:2, name:"Priya"},
    {_id:3, name:"Rahul"},
    {_id:4, name:"Meena"}
]);

// STEP 4: Insert product details
db.products.insertMany([
    {_id:1, name:"Laptop"},
    {_id:2, name:"Headphones"},
    {_id:3, name:"Shoes"}
]);

// STEP 5: Insert store details
db.stores.insertMany([
    {_id:1, name:"Chennai Store", region:"South"},
    {_id:2, name:"Bengaluru Store", region:"South"},
    {_id:3, name:"Mumbai Store", region:"West"}
]);

// STEP 6: Insert return details
db.returns.insertMany([
    {
        _id:401,
        customerId:1,
        productId:1,
        storeId:1,
        returnDate:ISODate("2026-09-10"),
        refundAmount:12000
    },
    {
        _id:402,
        customerId:2,
        productId:2,
        storeId:1,
        returnDate:ISODate("2026-09-11"),
        refundAmount:3000
    },
    {
        _id:403,
        customerId:3,
        productId:3,
        storeId:2,
        returnDate:ISODate("2026-09-12"),
        refundAmount:0
    },
    {
        _id:404,
        customerId:4,
        productId:1,
        storeId:3,
        returnDate:ISODate("2026-09-14"),
        refundAmount:4500
    }
]);

// STEP 7: Insert return feedback
db.returnFeedback.insertMany([
    {
        _id:601,
        returnId:401,
        comment:"Device did not turn on",
        sentiment:"Negative"
    },
    {
        _id:602,
        returnId:402,
        comment:"Product differed from image",
        sentiment:"Negative"
    },
    {
        _id:603,
        returnId:403,
        comment:"Size was too small",
        sentiment:"Neutral"
    }
]);

// STEP 8: Pipeline 1
// Join returns with customer details
db.returns.aggregate([
    {
        $lookup: {
            from:"customers",
            localField:"customerId",
            foreignField:"_id",
            as:"customer"
        }
    },
    {
        $unwind:"$customer"
    },
    {
        $project: {
            returnId:"$_id",
            returnDate:1,
            refundAmount:1,
            customerName:"$customer.name"
        }
    }
]);

// STEP 9: Pipeline 2
// Join returns with product and store details
db.returns.aggregate([
    {
        $lookup: {
            from:"products",
            localField:"productId",
            foreignField:"_id",
            as:"product"
        }
    },
    {
        $lookup: {
            from:"stores",
            localField:"storeId",
            foreignField:"_id",
            as:"store"
        }
    },
    {
        $unwind:"$product"
    },
    {
        $unwind:"$store"
    },
    {
        $project: {
            returnId:"$_id",
            productName:"$product.name",
            storeName:"$store.name",
            refundAmount:1
        }
    }
]);

// STEP 10: Pipeline 3
// Join returns with customer feedback
db.returns.aggregate([
    {
        $lookup: {
            from:"returnFeedback",
            localField:"_id",
            foreignField:"returnId",
            as:"feedback"
        }
    },
    {
        $project: {
            returnId:"$_id",
            customerId:1,
            productId:1,
            refundAmount:1,
            feedback:1
        }
    }
]);

