# Impediment Log – Airline Web Check-in

**Project:** Airline Web Check-in  
**Sprint:** Sprint 01  
**Maintained By:** Scrum Master  
**Impediment ID:** IMP-01  
**Affected Story:** AWC-103 – Seat Upgrade Payment

## 1. Impediment Overview

During the sprint, the external payment-gateway sandbox required to test the seat-upgrade payment workflow becomes unavailable.

The Developers cannot complete end-to-end payment validation or confirm the upgrade workflow against the external service.

## 2. Impediment Register

| Field | Details |
|---|---|
| Impediment ID | IMP-01 |
| Jira Story | AWC-103 |
| Description | Payment-gateway sandbox unavailable |
| Raised On | Day 4 |
| Raised By | Developer 3 |
| Severity | High |
| Owner | Scrum Master (coordination) |
| Technical Owner | Developer 3 |
| External Owner | Payment Gateway Support Team |
| Status | Open – Blocked |
| Expected Resolution | Day 6 (Target, unconfirmed) |
| Escalation | Developer → Scrum Master → Integration Lead → Gateway Support |
| Business Escalation | Product Owner informed of Sprint Goal risk |

## 3. Impact Analysis

**Development Impact:** Developers cannot verify actual payment authorization and gateway responses.

**Testing Impact:** End-to-end payment success, failure, timeout, and duplicate-callback scenarios cannot be fully validated against the sandbox.

**Sprint Impact:** The 8-point seat-upgrade story is at risk of remaining incomplete at sprint closure.

**Business Impact:** The seat-upgrade payment workflow may not be demonstrable as a fully integrated feature during the Sprint Review.

## 4. Scrum Master – Impediment Removal Actions

| Day | Action | Responsible | Outcome |
|---|---|---|---|
| Day 4 | Record and flag AWC-103 as blocked | Developer 3 | Blocker visible |
| Day 4 | Contact Integration Lead and Gateway Support | Scrum Master | Escalation raised |
| Day 5 | Request service restoration ETA and credentials check | Integration Lead | Response pending |
| Day 5 | Coordinate mock gateway testing | Developer 3 | Independent tests can continue |
| Day 6 | Review recovery status and sprint risk | Scrum Master and Developers | Reassessment scheduled |

## 5. Escalation Path

```text
Developer 3 identifies sandbox outage
                  |
                  v
       Scrum Master notified
                  |
                  v
      Integration Lead contacted
                  |
                  v
     Payment Gateway Support Team
                  |
                  v
       Restoration / Workaround
                  |
                  v
      Developers verify recovery
                  |
                  v
      AWC-103 testing resumes
```

The Scrum Master facilitates communication, makes the blocker visible, and coordinates resolution. The external support team is responsible for restoring the service, while Developers verify technical recovery.

## 6. Temporary Workaround

The Developers use a mock payment service to test request validation, response handling, timeout behavior, and duplicate-callback protection.

This allows independent implementation and automated testing to continue.

However, mock responses do not replace end-to-end testing against the actual payment-gateway sandbox.

## 7. Expected Resolution and Follow-Up

**Target Resolution:** Day 6  
**Current Status:** Open – Blocked  
**Next Review:** Day 6 Daily Scrum

The target date is an assumption for the simulation and is not a confirmed vendor commitment.

AWC-103 must remain incomplete until its agreed acceptance criteria and Definition of Done are satisfied.

If the sandbox remains unavailable, the Developers and Product Owner will discuss the impact on scope and the Sprint Goal. The team must not mark the story Done merely because mock tests pass.

## 8. Impediment Summary

The sandbox outage is a high-priority external dependency affecting seat-upgrade payment validation.

The Scrum Master helps remove the impediment through escalation, coordination, and alternative testing arrangements.


<img width="1537" height="547" alt="image" src="https://github.com/user-attachments/assets/828765c8-7170-4c63-b278-e8f52c91d086" />
