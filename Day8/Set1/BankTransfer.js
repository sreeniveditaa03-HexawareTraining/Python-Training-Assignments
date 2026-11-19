/* DAY 8 - COMBINED MONGODB 8.0 MONGOSH FILE - SETS 1, 2, 3
   Transactions require a replica set or sharded cluster (not standalone).
   Demo DB and collections are reset. Use only in a practice environment.
*/

const d = db.getSiblingDB("Day8MongoDemo");

["bankAccounts","bankTransactions","airlineSeats","airlineBookings",
 "retailProducts","retailOrders","retailOrderLines"].forEach(c => d[c].drop());

d.bankAccounts.insertMany([
    {accountId:101, name:"Asha", balance:5000, status:"ACTIVE"},
    {accountId:102, name:"Bala", balance:2500, status:"ACTIVE"},
    {accountId:103, name:"Blocked", balance:800, status:"BLOCKED"}
]);

d.airlineSeats.insertMany([
    {flightId:501, seatNo:"1A", status:"AVAILABLE"},
    {flightId:501, seatNo:"1B", status:"AVAILABLE"},
    {flightId:501, seatNo:"1C", status:"AVAILABLE"},
    {flightId:502, seatNo:"2A", status:"AVAILABLE"}
]);

d.retailProducts.insertMany([
    {productId:1, name:"Laptop", categoryId:10, stockQty:5, price:65000},
    {productId:2, name:"Mouse", categoryId:10, stockQty:50, price:800},
    {productId:3, name:"Keyboard", categoryId:10, stockQty:30, price:1500}
]);

// Utility: run transaction, commit on success, abort on error.
function transact(label, fn) {
    const s = d.getMongo().startSession();

    try {
        s.startTransaction();
        fn(s.getDatabase("Day8MongoDemo"));
        s.commitTransaction();
        print(label + " committed");
    }
    catch(e) {
        try {
            s.abortTransaction();
        } catch(ignore) {}
        print(label + " aborted: " + e.message);
    }
    finally {
        s.endSession();
    }
}

// ============================================================
// SET 1: BANK FUNDS TRANSFER
// ============================================================

// Task 1: Transfer money atomically across account documents.
function transfer(from, to, amount) {
    if(amount <= 0 || from === to)
        throw new Error("Invalid transfer parameters");

    transact("Bank transfer", sd => {

        const src = sd.bankAccounts.findOne({
            accountId:from,
            status:"ACTIVE",
            balance:{$gte:amount}
        });

        const dst = sd.bankAccounts.findOne({
            accountId:to,
            status:"ACTIVE"
        });

        if(!src || !dst)
            throw new Error("Source/destination unavailable or insufficient funds");

        if(sd.bankAccounts.updateOne(
            {accountId:from, status:"ACTIVE", balance:{$gte:amount}},
            {$inc:{balance:-amount}}
        ).modifiedCount !== 1)
            throw new Error("Debit failed");

        if(sd.bankAccounts.updateOne(
            {accountId:to, status:"ACTIVE"},
            {$inc:{balance:amount}}
        ).modifiedCount !== 1)
            throw new Error("Credit failed");

        sd.bankTransactions.insertOne({
            fromAccount:from,
            toAccount:to,
            amount:amount,
            type:"TRANSFER",
            date:new Date()
        });
    });
}

transfer(101,102,500);

// Task 2: Deliberate exception after debit proves rollback restores balance.
transact("Deliberate bank rollback", sd => {

    if(sd.bankAccounts.updateOne(
        {accountId:101, status:"ACTIVE", balance:{$gte:100}},
        {$inc:{balance:-100}}
    ).modifiedCount !== 1)
        throw new Error("Debit unavailable");

    throw new Error("Intentional failure after debit");
});

print("Bank balances after rollback:");

d.bankAccounts.find({
    accountId:{$in:[101,102]}
}).forEach(print);

// Task 3: MongoDB does not support SQL-style SAVEPOINT.
// Transactions are all-or-nothing. Use a separate transaction/design
// if fee posting should be independently retried.

// Task 4: Statement/window-function aggregation example.
d.bankTransactions.aggregate([
    {
        $match:{
            $or:[
                {fromAccount:101},
                {toAccount:101}
            ]
        }
    },
    {
        $set:{
            signedAmount:{
                $cond:[
                    {$eq:["$toAccount",101]},
                    "$amount",
                    {
                        $cond:[
                            {$eq:["$fromAccount",101]},
                            {$multiply:["$amount",-1]},
                            0
                        ]
                    }
                ]
            }
        }
    },
    {
        $setWindowFields:{
            partitionBy:"$fromAccount",
            sortBy:{date:1,_id:1},
            output:{
                rowNumber:{$documentNumber:{}},
                runningAmount:{
                    $sum:"$signedAmount",
                    window:{
                        documents:["unbounded","current"]
                    }
                },
                previousAmount:{
                    $shift:{
                        output:"$signedAmount",
                        by:-1,
                        default:0
                    }
                }
            }
        }
    },
    {$sort:{date:1}}
]).forEach(print);

// Task 5: SQL READ COMMITTED typically permits committed changes between reads.
// SNAPSHOT gives transaction-level version consistency and has version-store costs.
// MongoDB multi-document transfer transaction adds coordination/commit overhead.
