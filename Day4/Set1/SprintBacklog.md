# Sprint Backlog – Digital Wallet Application

**Project:** Digital Wallet Application  
**Project Key:** DWA  
**Sprint:** Sprint 01 – Wallet Core Features  
**Sprint Duration:** 10 Working Days  
**Team:** 5 Developers  
**Methodology:** Scrum

## 1. Sprint Velocity Calculation

The team uses the previous three sprints to estimate its delivery capacity.

| Previous Sprint | Velocity |
|---|---:|
| Sprint -3 | 21 SP |
| Sprint -2 | 24 SP |
| Sprint -1 | 23 SP |

**Average Velocity = (21 + 24 + 23) / 3 = 22.67 SP**

**Selected Sprint Capacity: 23 Story Points**

The team selects approximately 23 story points based on historical velocity, story priority, and estimated capacity.

## 2. Measurable Sprint Goal

Deliver a tested digital wallet workflow that allows users to authenticate securely, view their wallet balance, add funds using a simulated payment gateway, and view transaction history by the end of the 10-day sprint, with all selected stories meeting the Definition of Done.

## 3. Initial Sprint Backlog – Day 1

| Issue Key | User Story | Priority | SP | Assignee |
|---|---|---|---:|---|
| DWA-101 | User Login and Authentication | Highest | 8 | Dev 1 |
| DWA-102 | View Wallet Balance | High | 5 | Dev 2 |
| DWA-103 | Add Money to Wallet | High | 8 | Dev 3 |
| DWA-104 | Transaction History | Medium | 2 | Dev 4 |
| **Total** | | | **23** | |

**Other Product Backlog Items:** Profile Settings (3 SP) and Transaction Notifications (5 SP) remain outside the sprint.

## 4. Task Breakdown with Hour Estimates

### DWA-101 – Login and Authentication (8 SP)

| Subtask | Description | Estimate |
|---|---|---:|
| DWA-107 | Design login UI | 4h |
| DWA-108 | Implement authentication API | 8h |
| DWA-109 | Implement token validation | 4h |
| DWA-110 | Write authentication tests | 5h |
| Total | | 21h |

### DWA-102 – View Wallet Balance (5 SP)

| Subtask | Description | Estimate |
|---|---|---:|
| DWA-111 | Design wallet balance UI | 3h |
| DWA-112 | Implement balance API | 6h |
| DWA-113 | Integrate frontend and API | 4h |
| DWA-114 | Test balance retrieval | 4h |
| Total | | 17h |

### DWA-103 – Add Money to Wallet (8 SP)

| Subtask | Description | Estimate |
|---|---|---:|
| DWA-115 | Design add-money form | 4h |
| DWA-116 | Implement payment API | 8h |
| DWA-117 | Implement wallet credit logic | 6h |
| DWA-118 | Test payment scenarios | 5h |
| Total | | 23h |

**Total Estimated Effort for Three Stories: 61 Hours**

Story points measure relative complexity; hours estimate task effort.

## 5. Day 3 – Daily Scrum Updates

| Team Member | Yesterday | Today | Impediment |
|---|---|---|---|
| Dev 1 | Completed authentication tests | Support integration review | None |
| Dev 2 | Developed balance API | Integrate balance UI | Test account data unavailable |
| Dev 3 | Reviewed payment API requirements | Prepare payment API contract | Gateway test configuration pending |

The Scrum Master facilitates the removal of identified impediments.

## 6. Day 4 – Mid-Sprint Change Request

**Change Request:** CR-001  
**Requested Feature:** Refund to Wallet  
**New Story:** DWA-119  
**Estimated Size:** 8 SP  
**Priority:** Highest

**User Story:** As a wallet user, I want an eligible transaction refund credited back to my wallet so that I can reuse the refunded amount.

### Acceptance Criteria

- Only eligible completed transactions can be refunded.
- Refund amount must not exceed the remaining refundable amount.
- Wallet balance must update correctly.
- Duplicate refund requests must not credit funds twice.
- Refund transaction must be recorded.
- All relevant automated tests must pass.

### Impact Assessment

| Action | Story | SP |
|---|---|---:|
| Added | DWA-119 – Refund to Wallet | +8 |
| Removed from Sprint | DWA-103 – Add Money | -8 |
| Net Scope Change | | 0 |

DWA-103 returns to the Product Backlog; it is not deleted.

### Decision Authority

The Product Owner orders and prioritizes the Product Backlog. The Developers assess feasibility and negotiate Sprint Backlog changes with the Product Owner. The Scrum Master facilitates the discussion.

The example assumes DWA-103 has not been substantially implemented and that the Developers consider the replacement feasible.

## 7. Revised Sprint Backlog – Day 4

| Issue Key | User Story | SP | Status on Day 4 |
|---|---|---:|---|
| DWA-101 | Login and Authentication | 8 | Done |
| DWA-102 | View Wallet Balance | 5 | In Progress |
| DWA-104 | Transaction History | 2 | To Do |
| DWA-119 | Refund to Wallet | 8 | To Do |
| **Total** | | **23** | |

### Revised Sprint Goal

Deliver a tested digital wallet workflow enabling secure authentication, wallet balance viewing, transaction history, and eligible refunds within the 10-day sprint, with all revised stories meeting the Definition of Done.

**Decision:** The Product Owner and Developers agree to the revised Sprint Goal and scope.

## 8. Sprint Board Status Summary

| Day | To Do | In Progress | Done |
|---|---|---|---|
| Day 1 | DWA-102, 103, 104 | DWA-101 | — |
| Day 3 | DWA-103, 104 | DWA-102 | DWA-101 |
| Day 4 | DWA-104, 119 | DWA-102 | DWA-101 |
| Day 7 | DWA-104 | DWA-119 | DWA-101, 102 |
| Day 10 | — | — | DWA-101, 102, 104, 119 |

<img width="1600" height="752" alt="image" src="https://github.com/user-attachments/assets/1d8a6609-6130-4134-a419-2da1220ba613" />
