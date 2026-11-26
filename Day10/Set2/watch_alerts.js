
// Day 10 - Set 2
// MongoDB Change Stream - Fraud Alerts

use('BankAuditDB');

db.fraud_alerts.insertOne({
    alert_id: 101,
    account_id: 3,
    alert_type: "Suspicious Transaction",
    message: "Multiple unusual withdrawals detected",
    severity: "High",
    created_at: new Date()
});

const changeStream = db.fraud_alerts.watch([
    {
        $match: {
            operationType: "insert"
        }
    }
]);

while (true) {
    const change = changeStream.tryNext();

    if (change) {
        print("New Fraud Alert Detected");
        printjson(change.fullDocument);
    }
}
