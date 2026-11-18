
// STEP 1: Select database
use("Day7_BankLoansMongo");

// STEP 2: Clear previous sample collections
db.loans.drop();
db.customers.drop();
db.repayments.drop();

// STEP 3: Insert customer details
db.customers.insertMany([
    {_id:1, name:"Arun Kumar"},
    {_id:2, name:"Priya Shah"},
    {_id:3, name:"Rahul Das"},
    {_id:4, name:"Meena Iyer"}
]);

// STEP 4: Insert loan details
db.loans.insertMany([
    {
        _id:201,
        customerId:1,
        branch:"Chennai Main",
        principal:500000,
        outstanding:300000
    },
    {
        _id:202,
        customerId:2,
        branch:"Chennai Main",
        principal:300000,
        outstanding:120000
    },
    {
        _id:203,
        customerId:3,
        branch:"Bengaluru Central",
        principal:700000,
        outstanding:650000
    },
    {
        _id:204,
        customerId:1,
        branch:"Bengaluru Central",
        principal:200000,
        outstanding:80000
    }
]);

// STEP 5: Insert repayment details
db.repayments.insertMany([
    {
        _id:1,
        loanId:201,
        paymentDate:ISODate("2026-09-01"),
        amount:10000
    },
    {
        _id:2,
        loanId:201,
        paymentDate:ISODate("2026-10-01"),
        amount:10000
    },
    {
        _id:3,
        loanId:202,
        paymentDate:ISODate("2026-10-15"),
        amount:12000
    },
    {
        _id:4,
        loanId:203,
        paymentDate:ISODate("2026-08-01"),
        amount:15000
    }
]);

// STEP 6: Pipeline 1
// Join loans with customer details
db.loans.aggregate([
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
            loanId:"$_id",
            principal:1,
            outstanding:1,
            customerName:"$customer.name"
        }
    }
]);

// STEP 7: Pipeline 2
// Join loans with all repayment records
db.loans.aggregate([
    {
        $lookup: {
            from:"repayments",
            localField:"_id",
            foreignField:"loanId",
            as:"repayments"
        }
    },
    {
        $project: {
            loanId:"$_id",
            customerId:1,
            repayments:1
        }
    }
]);

// STEP 8: Pipeline 3
// Find the last repayment for each loan
db.loans.aggregate([
    {
        $lookup: {
            from:"repayments",
            let: {
                loanKey:"$_id"
            },
            pipeline: [
                {
                    $match: {
                        $expr: {
                            $eq:["$loanId","$$loanKey"]
                        }
                    }
                },
                {
                    $sort: {
                        paymentDate:-1
                    }
                },
                {
                    $limit:1
                }
            ],
            as:"lastRepayment"
        }
    },
    {
        $project: {
            loanId:"$_id",
            customerId:1,
            outstanding:1,
            lastRepayment:1
        }
    }
]);


