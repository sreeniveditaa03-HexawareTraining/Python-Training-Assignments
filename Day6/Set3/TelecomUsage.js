

use('TelecomDB');

// Reset database for this assignment
db.dropDatabase();


// PART 1: CREATE COLLECTION


db.createCollection("usage-events");


// PART 2: INSERT SAMPLE USAGE EVENTS


db["usage-events"].insertMany([
    {
        event_id: 1,
        subscriber_id: 101,
        usage_time: ISODate("2026-10-01T09:00:00Z"),
        usage_mb: 500,
        session_minutes: 20,
        cell_tower: "TOWER_A"
    },
    {
        event_id: 2,
        subscriber_id: 101,
        usage_time: ISODate("2026-10-01T10:00:00Z"),
        usage_mb: 300,
        session_minutes: 15,
        cell_tower: "TOWER_A"
    },
    {
        event_id: 3,
        subscriber_id: 102,
        usage_time: ISODate("2026-10-02T11:00:00Z"),
        usage_mb: 2000,
        session_minutes: 30,
        cell_tower: "TOWER_B"
    },
    {
        event_id: 4,
        subscriber_id: 102,
        usage_time: ISODate("2026-10-03T12:00:00Z"),
        usage_mb: 1500,
        session_minutes: 25,
        cell_tower: "TOWER_B"
    },
    {
        event_id: 5,
        subscriber_id: 103,
        usage_time: ISODate("2026-10-04T13:00:00Z"),
        usage_mb: 8000,
        session_minutes: 45,
        cell_tower: "TOWER_C"
    },
    {
        event_id: 6,
        subscriber_id: 103,
        usage_time: ISODate("2026-10-05T14:00:00Z"),
        usage_mb: 4000,
        session_minutes: 35,
        cell_tower: "TOWER_C"
    },
    {
        event_id: 7,
        subscriber_id: 104,
        usage_time: ISODate("2026-10-06T15:00:00Z"),
        usage_mb: 1000,
        session_minutes: 10,
        cell_tower: "TOWER_A"
    },
    {
        event_id: 8,
        subscriber_id: 104,
        usage_time: ISODate("2026-10-07T16:00:00Z"),
        usage_mb: 1200,
        session_minutes: 15,
        cell_tower: "TOWER_B"
    },
    {
        event_id: 9,
        subscriber_id: 105,
        usage_time: ISODate("2026-10-08T17:00:00Z"),
        usage_mb: 15000,
        session_minutes: 60,
        cell_tower: "TOWER_C"
    },
    {
        event_id: 10,
        subscriber_id: 105,
        usage_time: ISODate("2026-10-09T18:00:00Z"),
        usage_mb: 12000,
        session_minutes: 40,
        cell_tower: "TOWER_C"
    },
    {
        event_id: 11,
        subscriber_id: 106,
        usage_time: ISODate("2026-10-10T09:00:00Z"),
        usage_mb: 400,
        session_minutes: 12,
        cell_tower: "TOWER_A"
    },
    {
        event_id: 12,
        subscriber_id: 107,
        usage_time: ISODate("2026-10-11T10:00:00Z"),
        usage_mb: 6000,
        session_minutes: 25,
        cell_tower: "TOWER_B"
    },
    {
        event_id: 13,
        subscriber_id: 107,
        usage_time: ISODate("2026-10-12T11:00:00Z"),
        usage_mb: 5000,
        session_minutes: 20,
        cell_tower: "TOWER_B"
    },
    {
        event_id: 14,
        subscriber_id: 108,
        usage_time: ISODate("2026-10-13T12:00:00Z"),
        usage_mb: 1800,
        session_minutes: 18,
        cell_tower: "TOWER_A"
    },
    {
        event_id: 15,
        subscriber_id: 109,
        usage_time: ISODate("2026-10-14T13:00:00Z"),
        usage_mb: 20000,
        session_minutes: 55,
        cell_tower: "TOWER_C"
    },
    {
        event_id: 16,
        subscriber_id: 110,
        usage_time: ISODate("2026-10-15T14:00:00Z"),
        usage_mb: 600,
        session_minutes: 10,
        cell_tower: "TOWER_B"
    },
    {
        event_id: 17,
        subscriber_id: 111,
        usage_time: ISODate("2026-11-01T09:00:00Z"),
        usage_mb: 7000,
        session_minutes: 30,
        cell_tower: "TOWER_A"
    },
    {
        event_id: 18,
        subscriber_id: 111,
        usage_time: ISODate("2026-11-01T10:00:00Z"),
        usage_mb: 4000,
        session_minutes: 20,
        cell_tower: "TOWER_A"
    },
    {
        event_id: 19,
        subscriber_id: 112,
        usage_time: ISODate("2026-11-02T11:00:00Z"),
        usage_mb: 1000,
        session_minutes: 15,
        cell_tower: "TOWER_B"
    },
    {
        event_id: 20,
        subscriber_id: 103,
        usage_time: ISODate("2026-11-03T12:00:00Z"),
        usage_mb: 9000,
        session_minutes: 40,
        cell_tower: "TOWER_C"
    }
]);

// PART 3: THREE AGGREGATION PIPELINES



// PIPELINE 1: HOURLY USAGE

db["usage-events"].aggregate([
    {
        $group: {
            _id: {
                $dateToString: {
                    format: "%Y-%m-%d %H:00",
                    date: "$usage_time"
                }
            },
            total_usage_mb: {
                $sum: "$usage_mb"
            },
            total_sessions: {
                $sum: 1
            }
        }
    },
    {
        $sort: {
            _id: 1
        }
    },
    {
        $project: {
            _id: 0,
            usage_hour: "$_id",
            total_usage_mb: 1,
            total_sessions: 1
        }
    }
]);


// PIPELINE 2: AVERAGE SESSION LENGTH

db["usage-events"].aggregate([
    {
        $group: {
            _id: null,
            average_session_length: {
                $avg: "$session_minutes"
            },
            total_sessions: {
                $sum: 1
            }
        }
    },
    {
        $project: {
            _id: 0,
            average_session_length: {
                $round: ["$average_session_length", 2]
            },
            total_sessions: 1
        }
    }
]);


// PIPELINE 3: BUSIEST CELL TOWER

db["usage-events"].aggregate([
    {
        $group: {
            _id: "$cell_tower",
            total_events: {
                $sum: 1
            },
            total_usage_mb: {
                $sum: "$usage_mb"
            }
        }
    },
    {
        $sort: {
            total_events: -1,
            _id: 1
        }
    },
    {
        $limit: 1
    },
    {
        $project: {
            _id: 0,
            cell_tower: "$_id",
            total_events: 1,
            total_usage_mb: 1
        }
    }
]);
