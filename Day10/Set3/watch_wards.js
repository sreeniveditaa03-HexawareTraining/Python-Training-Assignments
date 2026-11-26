
// Day 10 - Set 3
// MongoDB Change Stream - Ward Critical Alerts

use('HospitalAuditDB');

const changeStream = db.ward_alerts.watch([
    {
        $match: {
            operationType: "insert",
            "fullDocument.severity": "critical"
        }
    }
]);

while (true) {
    const change = changeStream.tryNext();

    if (change) {
        print("Critical Ward Alert Detected");

        print("Ward:", change.fullDocument.ward);

        print("Time:", change.fullDocument.created_at);

        printjson(change.fullDocument);
    }
}
