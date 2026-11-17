
// =====================================================
// HEXAWARE - DAY 5 ASSIGNMENT
// SET 1: RETAIL INVENTORY AND PRODUCT REVIEWS
// TASK 5: MONGODB OPERATIONS
// =====================================================


// STEP 1: Create / Switch to Database
use RetailReviewsDB;


// STEP 2: Create Reviews Collection with JSON Schema Validator
db.createCollection("reviews", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: [
                "SKU",
                "customerName",
                "rating",
                "reviewText",
                "reviewDate"
            ],
            properties: {
                SKU: {
                    bsonType: "string",
                    description: "Product SKU must be a string"
                },
                customerName: {
                    bsonType: "string",
                    description: "Customer name is mandatory"
                },
                rating: {
                    bsonType: "int",
                    minimum: 1,
                    maximum: 5,
                    description: "Rating must be between 1 and 5"
                },
                reviewText: {
                    bsonType: "string",
                    description: "Review text must be a string"
                },
                reviewDate: {
                    bsonType: "date",
                    description: "Review date must be a valid date"
                },
                verifiedPurchase: {
                    bsonType: "bool"
                }
            }
        }
    },
    validationLevel: "strict",
    validationAction: "error"
});


// STEP 3: Insert 10 Product Reviews using insertMany()
db.reviews.insertMany([
    {
        SKU: "P101",
        customerName: "Arun",
        rating: NumberInt(5),
        reviewText: "Excellent laptop with great performance.",
        reviewDate: ISODate("2026-11-10"),
        verifiedPurchase: true
    },
    {
        SKU: "P102",
        customerName: "Priya",
        rating: NumberInt(4),
        reviewText: "Good quality and comfortable T-shirt.",
        reviewDate: ISODate("2026-11-11"),
        verifiedPurchase: true
    },
    {
        SKU: "P103",
        customerName: "Rahul",
        rating: NumberInt(5),
        reviewText: "Rice quality is very good.",
        reviewDate: ISODate("2026-11-12"),
        verifiedPurchase: true
    },
    {
        SKU: "P104",
        customerName: "Sneha",
        rating: NumberInt(3),
        reviewText: "Chair is comfortable but slightly expensive.",
        reviewDate: ISODate("2026-11-12"),
        verifiedPurchase: false
    },
    {
        SKU: "P105",
        customerName: "Karthik",
        rating: NumberInt(4),
        reviewText: "Smart watch has useful features.",
        reviewDate: ISODate("2026-11-13"),
        verifiedPurchase: true
    },
    {
        SKU: "P106",
        customerName: "Divya",
        rating: NumberInt(5),
        reviewText: "Very comfortable sports shoes.",
        reviewDate: ISODate("2026-11-13"),
        verifiedPurchase: true
    },
    {
        SKU: "P107",
        customerName: "Vikram",
        rating: NumberInt(4),
        reviewText: "Good notebook paper quality.",
        reviewDate: ISODate("2026-11-14"),
        verifiedPurchase: true
    },
    {
        SKU: "P108",
        customerName: "Meena",
        rating: NumberInt(3),
        reviewText: "Mixer works well but is noisy.",
        reviewDate: ISODate("2026-11-14"),
        verifiedPurchase: false
    },
    {
        SKU: "P109",
        customerName: "Ajay",
        rating: NumberInt(5),
        reviewText: "Great football for outdoor games.",
        reviewDate: ISODate("2026-11-15"),
        verifiedPurchase: true
    },
    {
        SKU: "P110",
        customerName: "Anitha",
        rating: NumberInt(4),
        reviewText: "Nice face cream with a pleasant texture.",
        reviewDate: ISODate("2026-11-15"),
        verifiedPurchase: true
    }
]);


// STEP 4: Retrieve All Reviews using find()
db.reviews.find();


// STEP 5: Find Reviews for a Specific Product
db.reviews.find({ SKU: "P101" });


// STEP 6: Find Reviews with Rating Greater Than or Equal to 4
db.reviews.find({
    rating: { $gte: 4 }
});


// STEP 7: Update a Review using updateOne()
// Change Arun's laptop rating from 5 to 4
db.reviews.updateOne(
    {
        SKU: "P101",
        customerName: "Arun"
    },
    {
        $set: {
            rating: NumberInt(4),
            reviewText: "Good laptop with excellent performance."
        }
    }
);


// STEP 8: Verify Updated Review
db.reviews.find({
    SKU: "P101",
    customerName: "Arun"
});


// STEP 9: Delete a Review using deleteOne()
// Remove Ajay's review for product P109
db.reviews.deleteOne({
    SKU: "P109",
    customerName: "Ajay"
});


// STEP 10: Verify Deleted Review
db.reviews.find({
    SKU: "P109",
    customerName: "Ajay"
});


// STEP 11: Test JSON Schema Validation
// This insertion should FAIL because rating cannot exceed 5
db.reviews.insertOne({
    SKU: "P101",
    customerName: "Test Customer",
    rating: NumberInt(8),
    reviewText: "Invalid rating test",
    reviewDate: ISODate("2026-11-16"),
    verifiedPurchase: true
});


// STEP 12: Count Remaining Reviews
db.reviews.countDocuments();


// STEP 13: Display All Remaining Reviews
db.reviews.find();
