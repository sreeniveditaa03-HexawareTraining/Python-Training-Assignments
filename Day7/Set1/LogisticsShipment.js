


// STEP 1: Select database
use("Day7_LogisticsMongo");

// STEP 2: Clear previous sample collections
db.hubs.drop();
db.carriers.drop();
db.customers.drop();
db.shipments.drop();
db.deliveryEvents.drop();

// STEP 3: Insert hub details
db.hubs.insertMany([
    {_id:1, name:"Chennai Central", region:"South"},
    {_id:2, name:"Bengaluru Hub", region:"South"},
    {_id:3, name:"Mumbai West", region:"West"},
    {_id:4, name:"Delhi North", region:"North"}
]);

// STEP 4: Insert carrier details
db.carriers.insertMany([
    {_id:1, name:"BlueDart"},
    {_id:2, name:"DHL"},
    {_id:3, name:"Delhivery"},
    {_id:4, name:"FedEx"}
]);

// STEP 5: Insert customer details
db.customers.insertMany([
    {_id:1, name:"Aarav Stores"},
    {_id:2, name:"Bright Retail"},
    {_id:3, name:"City Mart"},
    {_id:4, name:"Delta Traders"}
]);

// STEP 6: Insert shipment details
db.shipments.insertMany([
    {
        _id:101, customerId:1, carrierId:1,
        originHubId:1, destinationHubId:2,
        cost:850,
        promisedDate:ISODate("2026-10-03"),
        deliveredDate:ISODate("2026-10-06")
    },
    {
        _id:102, customerId:2, carrierId:2,
        originHubId:2, destinationHubId:3,
        cost:1200,
        promisedDate:ISODate("2026-10-05"),
        deliveredDate:ISODate("2026-10-05")
    },
    {
        _id:103, customerId:3, carrierId:3,
        originHubId:3, destinationHubId:4,
        cost:950,
        promisedDate:ISODate("2026-10-06"),
        deliveredDate:ISODate("2026-10-10")
    },
    {
        _id:104, customerId:4, carrierId:1,
        originHubId:4, destinationHubId:1,
        cost:700,
        promisedDate:ISODate("2026-10-08"),
        deliveredDate:ISODate("2026-10-07")
    }
]);

// STEP 7: Insert delivery event details
db.deliveryEvents.insertMany([
    {
        _id:1, shipmentId:101,
        type:"PickedUp",
        eventDate:ISODate("2026-10-01")
    },
    {
        _id:2, shipmentId:101,
        type:"Delivered",
        eventDate:ISODate("2026-10-06")
    },
    {
        _id:3, shipmentId:103,
        type:"Delayed",
        eventDate:ISODate("2026-10-08")
    },
    {
        _id:4, shipmentId:103,
        type:"Delivered",
        eventDate:ISODate("2026-10-10")
    }
]);

// STEP 8: Pipeline 1
// Find shipments with their delivery events
db.shipments.aggregate([
    {
        $lookup: {
            from: "deliveryEvents",
            localField: "_id",
            foreignField: "shipmentId",
            as: "deliveryEvents"
        }
    },
    {
        $project: {
            _id:1,
            customerId:1,
            carrierId:1,
            deliveryEvents:1
        }
    }
]);

// STEP 9: Pipeline 2
// Find customers with their shipments
db.customers.aggregate([
    {
        $lookup: {
            from: "shipments",
            localField: "_id",
            foreignField: "customerId",
            as: "shipments"
        }
    },
    {
        $project: {
            name:1,
            shipments:1
        }
    }
]);

// STEP 10: Pipeline 3
// Find carriers with shipment delay statistics
db.carriers.aggregate([
    {
        $lookup: {
            from: "shipments",
            localField: "_id",
            foreignField: "carrierId",
            as: "shipments"
        }
    },
    {
        $project: {
            name:1,
            shipmentCount: {$size:"$shipments"},
            averageDelayDays: {
                $let: {
                    vars: {
                        delivered: {
                            $filter: {
                                input:"$shipments",
                                as:"s",
                                cond: {
                                    $ne:["$$s.deliveredDate", null]
                                }
                            }
                        }
                    },
                    in: {
                        $cond: [
                            {$gt:[{$size:"$$delivered"},0]},
                            {
                                $avg: {
                                    $map: {
                                        input:"$$delivered",
                                        as:"s",
                                        in: {
                                            $dateDiff: {
                                                startDate:"$$s.promisedDate",
                                                endDate:"$$s.deliveredDate",
                                                unit:"day"
                                            }
                                        }
                                    }
                                }
                            },
                            null
                        ]
                    }
                }
            }
        }
    }
]);


