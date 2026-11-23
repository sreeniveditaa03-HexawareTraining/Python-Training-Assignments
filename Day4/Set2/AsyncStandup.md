# Asynchronous Daily Scrum – Airline Web Check-in

**Project:** Airline Web Check-in  
**Sprint:** Sprint 01  
**Sprint Day:** Day 5  
**Communication Mode:** Written Asynchronous Update  
**Platform:** Team Chat / Jira Comments (Simulated)

## 1. Distributed Team Details

The team works across two time zones:

| Team Location | Time Zone | Members |
|---|---|---|
| Chennai, India | IST (UTC+5:30) | Developers 1, 2, 3 |
| London, UK | GMT (UTC+0) | Developers 4, 5 and Scrum Master |

The example assumes a date when London observes GMT.

**Update Deadline:** 2:00 PM IST / 8:30 AM GMT

Each member posts progress, planned work, and impediments before the agreed deadline. The Developers review the updates and coordinate changes to the Sprint Backlog.

## 2. Written Daily Scrum Updates

### Developer 1 – Booking Retrieval

**Yesterday:** Completed booking retrieval API tests and validated invalid PNR handling.

**Today:** Support integration between booking retrieval and seat selection.

**Impediment:** None.

**Jira Status:** AWC-101 – Done

### Developer 2 – Seat Selection

**Yesterday:** Completed seat availability checks and prevented occupied-seat selection.

**Today:** Finalize seat assignment validation and regression testing.

**Impediment:** None.

**Jira Status:** AWC-102 – In Progress

### Developer 3 – Seat Upgrade Payment

**Yesterday:** Identified the payment-gateway sandbox outage and reported the blocker.

**Today:** Continue mock gateway testing and coordinate with the Integration Lead.

**Impediment:** Payment-gateway sandbox unavailable. Actual payment integration testing is blocked.

**Jira Status:** AWC-103 – Flagged / In Progress

### Developer 4 – Boarding Pass Generation

**Yesterday:** Implemented boarding pass generation using checked-in passenger data.

**Today:** Validate seat and flight details and test boarding pass download.

**Impediment:** None.

**Jira Status:** AWC-104 – In Progress

### Developer 5 – Quality Assurance

**Yesterday:** Prepared booking retrieval and seat selection test cases.

**Today:** Execute regression tests and prepare mock payment test scenarios.

**Impediment:** Actual gateway test cases remain blocked until sandbox access is restored.

**Jira Status:** Testing tasks – In Progress

### Developer 6 – Integration Support

**Yesterday:** Reviewed API dependencies and payment integration requirements.

**Today:** Support gateway mock configuration and check integration logs.

**Impediment:** Waiting for payment-gateway support response.

**Jira Status:** Integration tasks – In Progress

## 3. Scrum Master Follow-Up

**Daily Scrum Summary – Day 5**

- Booking retrieval is completed.
- Seat selection and boarding pass generation are progressing.
- Seat-upgrade payment integration remains blocked.
- Gateway escalation is active.
- Developers will continue independent testing using mock responses.
- Gateway restoration status will be reviewed on Day 6.

The Scrum Master helps remove the external dependency and supports communication across both locations.

## 4. Async vs Live Daily Scrum

| Aspect | Written Async Stand-up | Live Stand-up |
|---|---|---|
| Communication | Written updates | Real-time discussion |
| Time Zones | Flexible posting window | Requires overlapping availability |
| Blocker Visibility | Recorded in writing | Raised verbally |
| Clarification | Follow-up messages | Immediate discussion |
| Documentation | Automatically retained in chat | Requires notes if records are needed |
| Main Limitation | Delayed responses | Scheduling difficulty |

## 5. Effectiveness and Team Decision

The asynchronous format allows distributed Developers to share progress without requiring all members to attend at the same time.

However, written status updates alone do not guarantee effective Daily Scrum collaboration.

The team should use the updates to inspect progress toward the Sprint Goal and adapt the Sprint Backlog. Urgent blockers should be escalated immediately rather than waiting for the next reporting deadline.

**Team Decision:** Use written asynchronous updates for routine coordination and arrange a short live discussion when urgent dependencies or complex decisions require immediate collaboration.

## 6. Conclusion

The asynchronous Daily Scrum approach supports coordination across IST and GMT while maintaining a written record of progress and impediments.

The payment-gateway blocker is made visible to the distributed team, and follow-up responsibilities are clearly identified.
