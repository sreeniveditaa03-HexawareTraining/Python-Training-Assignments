
// Day 10 - Set 1
// MongoDB Change Stream - Retail Price Change Audit

const { MongoClient } = require("mongodb");

const uri = "mongodb://localhost:27017/?replicaSet=rs0";

async function watchPriceChanges() {
    const client = new MongoClient(uri);

    try {
        await client.connect();

        const database = client.db("RetailAuditDB");
        const products = database.collection("products");

        console.log("Watching for product price changes...");

        const changeStream = products.watch(
            [
                {
                    $match: {
                        operationType: "update",
                        "updateDescription.updatedFields.price": {
                            $exists: true
                        }
                    }
                }
            ],
            {
                fullDocument: "updateLookup"
            }
        );

        for await (const change of changeStream) {
            console.log("\nPrice Change Detected");

            console.log("Product ID:", change.documentKey._id);

            console.log(
                "New Price:",
                change.fullDocument?.price
            );

            console.log(
                "Updated Fields:",
                change.updateDescription.updatedFields
            );

            console.log("Operation:", change.operationType);

            console.log("Time:", new Date(change.clusterTime.getHighBits() * 1000));
        }

    } catch (error) {
        console.error("Change Stream Error:", error);
    } finally {
        await client.close();
    }
}

watchPriceChanges();
