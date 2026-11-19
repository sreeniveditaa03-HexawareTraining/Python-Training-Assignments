// Task 5: Single-document atomic stock reservation using conditional $inc.
function reserveStock(product, qty) {

    if(qty <= 0)
        throw new Error("Quantity must be positive");

    const r = d.retailProducts.findOneAndUpdate(
        {
            productId:product,
            stockQty:{$gte:qty}
        },
        {$inc:{stockQty:-qty}},
        {returnDocument:"after"}
    );

    if(!r)
        print("Stock reservation rejected: unavailable/insufficient");
    else
        print("Reserved stock:",r);

    return r;
}

reserveStock(2,4);

// Task 1: Order, lines and stock updates are multi-document.
// A transaction ensures all-or-nothing consistency.
function order(customer, lines) {

    transact("Retail order", sd => {

        const prepared = [];

        for(const l of lines) {

            const p = sd.retailProducts.findOne({
                productId:l.productId,
                stockQty:{$gte:l.quantity}
            });

            if(!p)
                throw new Error("Insufficient stock for product " + l.productId);

            if(sd.retailProducts.updateOne(
                {
                    productId:l.productId,
                    stockQty:{$gte:l.quantity}
                },
                {$inc:{stockQty:-l.quantity}}
            ).modifiedCount !== 1)
                throw new Error("Stock update failed");

            prepared.push({
                productId:p.productId,
                name:p.name,
                quantity:l.quantity,
                unitPrice:p.price
            });
        }

        const o = sd.retailOrders.insertOne({
            customerName:customer,
            status:"PLACED",
            orderDate:new Date()
        });

        sd.retailOrderLines.insertMany(
            prepared.map(x => ({
                orderId:o.insertedId,
                ...x
            }))
        );
    });
}

// Successful order example.
order("Demo customer",[
    {productId:1,quantity:1},
    {productId:3,quantity:2}
]);

// Deliberate insufficient-stock rollback demonstration.
order("Rollback demo",[
    {productId:1,quantity:999}
]);

print("Stock after order/rollback:");

d.retailProducts.find().forEach(print);

// Task 2: Correlated-category-average equivalent using $lookup.
d.retailProducts.aggregate([
    {
        $lookup:{
            from:"retailProducts",
            let:{cat:"$categoryId"},
            pipeline:[
                {
                    $match:{
                        $expr:{
                            $eq:["$categoryId","$$cat"]
                        }
                    },
                },
                {
                    $group:{
                        _id:null,
                        avgStock:{$avg:"$stockQty"}
                    }
                }
            ],
            as:"categoryAverage"
        }
    },
    {$unwind:"$categoryAverage"},
    {
        $match:{
            $expr:{
                $lt:["$stockQty","$categoryAverage.avgStock"]
            }
        }
    },
    {
        $project:{
            productId:1,
            name:1,
            categoryId:1,
            stockQty:1,
            avgStock:"$categoryAverage.avgStock"
        }
    }
]).forEach(print);

// Tasks 3 and 4: Category ranking among products with order lines.
d.retailOrderLines.aggregate([
    {
        $group:{
            _id:"$productId",
            unitsSold:{$sum:"$quantity"},
            revenue:{
                $sum:{
                    $multiply:["$quantity","$unitPrice"]
                }
            }
        }
    },
    {
        $lookup:{
            from:"retailProducts",
            localField:"_id",
            foreignField:"productId",
            as:"product"
        }
    },
    {$unwind:"$product"},
    {
        $setWindowFields:{
            partitionBy:"$product.categoryId",
            sortBy:{unitsSold:-1,revenue:-1},
            output:{
                categoryRank:{$rank:{}}
            }
        }
    },
    {$match:{categoryRank:{$lte:3}}},
    {$sort:{"product.categoryId":1,categoryRank:1}}
]).forEach(print);

// SQL file contains the LEAD/LAG month-to-month report.
// MongoDB can use $setWindowFields with $shift after grouping by month.
// Single-document stock update is atomic and cheaper.
// Transactions are warranted when stock, order and order-line changes
// must commit together across documents.

print("Day 8 combined MongoDB script finished.");
