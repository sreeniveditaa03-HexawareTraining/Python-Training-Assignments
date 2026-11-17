



use('InsuranceDB');

// Reset database for this assignment
db.dropDatabase();


// PART 1: CREATE COLLECTION


db.createCollection("claims_notes");


// PART 2: INSERT SAMPLE CLAIM NOTES


db.claims_notes.insertMany([
    {
        claim_id: 1001,
        policy_id: 1,
        claim_date: ISODate("2025-03-10"),
        status: "Settled",
        settlement_date: ISODate("2025-03-20"),
        settlement_amount: 5000,
        damage_category: "Accident",
        notes: "Vehicle accident claim settled successfully"
    },
    {
        claim_id: 1002,
        policy_id: 2,
        claim_date: ISODate("2025-05-15"),
        status: "Settled",
        settlement_date: ISODate("2025-05-25"),
        settlement_amount: 8000,
        damage_category: "Medical",
        notes: "Medical expenses reimbursed"
    },
    {
        claim_id: 1003,
        policy_id: 3,
        claim_date: ISODate("2025-07-01"),
        status: "Approved",
        settlement_date: null,
        settlement_amount: 6000,
        damage_category: "Accident",
        notes: "Claim approved and awaiting settlement"
    },
    {
        claim_id: 1004,
        policy_id: 4,
        claim_date: ISODate("2025-09-10"),
        status: "Settled",
        settlement_date: ISODate("2025-09-15"),
        settlement_amount: 10000,
        damage_category: "Fire",
        notes: "Fire damage claim settled"
    },
    {
        claim_id: 1005,
        policy_id: 5,
        claim_date: ISODate("2025-04-12"),
        status: "Rejected",
        settlement_date: null,
        settlement_amount: 12000,
        damage_category: "Medical",
        notes: "Claim rejected due to policy conditions"
    },
    {
        claim_id: 1006,
        policy_id: 6,
        claim_date: ISODate("2025-10-05"),
        status: "Settled",
        settlement_date: ISODate("2025-10-15"),
        settlement_amount: 4000,
        damage_category: "Accident",
        notes: "Accident repair claim completed"
    },
    {
        claim_id: 1007,
        policy_id: 7,
        claim_date: ISODate("2025-12-10"),
        status: "Open",
        settlement_date: null,
        settlement_amount: 7000,
        damage_category: "Fire",
        notes: "Claim under investigation"
    },
    {
        claim_id: 1008,
        policy_id: 8,
        claim_date: ISODate("2026-01-05"),
        status: "Settled",
        settlement_date: ISODate("2026-01-12"),
        settlement_amount: 9000,
        damage_category: "Medical",
        notes: "Medical claim settled successfully"
    }
]);


// PART 3: THREE MONGODB AGGREGATION PIPELINES



// PIPELINE 1: CLAIMS PER STATUS

db.claims_notes.aggregate([
    {
        $group: {
            _id: "$status",
            total_claims: {
                $sum: 1
            }
        }
    },
    {
        $sort: {
            total_claims: -1
        }
    },
    {
        $project: {
            _id: 0,
            claim_status: "$_id",
            total_claims: 1
        }
    }
]);


// PIPELINE 2: AVERAGE SETTLEMENT TIME

db.claims_notes.aggregate([
    {
        $match: {
            settlement_date: {
                $ne: null
            }
        }
    },
    {
        $project: {
            settlement_days: {
                $dateDiff: {
                    startDate: "$claim_date",
                    endDate: "$settlement_date",
                    unit: "day"
                }
            }
        }
    },
    {
        $group: {
            _id: null,
            average_settlement_time: {
                $avg: "$settlement_days"
            }
        }
    },
    {
        $project: {
            _id: 0,
            average_settlement_time: {
                $round: ["$average_settlement_time", 2]
            }
        }
    }
]);


// PIPELINE 3: TOP THREE DAMAGE CATEGORIES

db.claims_notes.aggregate([
    {
        $group: {
            _id: "$damage_category",
            total_claims: {
                $sum: 1
            },
            total_claim_amount: {
                $sum: "$settlement_amount"
            }
        }
    },
    {
        $sort: {
            total_claims: -1,
            _id: 1
        }
    },
    {
        $limit: 3
    },
    {
        $project: {
            _id: 0,
            damage_category: "$_id",
            total_claims: 1,
            total_claim_amount: 1
        }
    }
]);
