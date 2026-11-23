# Impediment Log – Digital Wallet Application

**Project:** Digital Wallet Application  
**Sprint:** Sprint 01  
**Duration:** 10 Working Days  
**Maintained By:** Scrum Master  
**Record Type:** Simulated Sprint Impediment Register

## 1. Objective

To identify, monitor, escalate, and resolve blockers that affect the Developers' ability to achieve the Sprint Goal.

## 2. Sprint Impediment Register

| ID | Day Raised | Impediment | Severity | Owner | Status |
|---|---|---|---|---|---|
| IMP-01 | Day 3 | Wallet test account data unavailable | Medium | Dev 5 | Resolved |
| IMP-02 | Day 3 | Simulated payment gateway configuration pending | High | Dev 3 | Closed – Scope Removed |
| IMP-03 | Day 4 | Refund eligibility rules unclear | High | Product Owner | Resolved |

## 3. Detailed Impediment Tracking

### IMP-01 – Wallet Test Data Unavailable

**Raised By:** Developer 2  
**Affected Story:** DWA-102  
**Impact:** Balance API integration testing is delayed.

**Action Taken:** Developer 5 prepares repeatable test fixtures with wallet accounts and predefined balances.

**Resolution:** Test fixtures are made available on Day 4.

**Status:** Resolved

### IMP-02 – Payment Gateway Configuration Pending

**Raised By:** Developer 3  
**Affected Story:** DWA-103  
**Impact:** Add-money integration testing cannot proceed without simulated gateway responses.

**Action Taken:** The dependency is escalated and recorded.

**Resolution:** On Day 4, DWA-103 is removed from the active sprint after the scope change.

**Status:** Closed for this sprint – Scope Removed

**Note:** The technical dependency remains unresolved and must be reconsidered when DWA-103 is prioritized in a future sprint.

### IMP-03 – Refund Eligibility Rules Unclear

**Raised By:** Developer 3  
**Affected Story:** DWA-119  
**Impact:** Refund implementation cannot be finalized without clear business rules.

**Action Taken:** The Product Owner clarifies eligible transactions, maximum refundable amounts, authorization, and duplicate-refund prevention.

**Resolution:** Acceptance criteria are updated on Day 4.

**Status:** Resolved

## 4. Impediment Summary

| Metric | Result |
|---|---:|
| Total Impediments | 3 |
| Resolved | 2 |
| Closed Due to Scope Removal | 1 |
| Open at Sprint End | 0 |

## 5. Scrum Master Follow-Up

The Scrum Master facilitates blocker resolution, coordinates discussions, and helps the Developers maintain progress toward the Sprint Goal.

Impediments are reviewed during Daily Scrum and followed up with the relevant owners.

<img width="1365" height="595" alt="image" src="https://github.com/user-attachments/assets/668a5c0d-81a3-4fdd-bc17-bda4c122d46f" />
