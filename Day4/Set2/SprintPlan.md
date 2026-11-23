# Sprint Plan – Airline Web Check-in

**Project:** Airline Web Check-in  
**Project Key:** AWC  
**Sprint:** Sprint 01 – Check-in Improvements  
**Duration:** 8 Working Days  
**Team Size:** 6 Members  
**Focus Factor:** 70%  
**Sprint Status:** In Progress 

## 1. Team Capacity Calculation

The team consists of six members working for eight days with a 70% focus factor.

Assuming 8 working hours per day:

**Total Available Hours = Team Members × Working Days × Hours per Day**

= 6 × 8 × 8 = 384 hours

**Effective Capacity = Total Available Hours × Focus Factor**

= 384 × 0.70 = **268.8 hours**

The team has approximately 269 focused hours available for sprint activities.

### Story Point Commitment

Since historical velocity is not provided, the team assumes a planning rate of approximately 10 focused team-hours per story point for this simulation.

Estimated Capacity = 268.8 / 10 = 26.88 SP

**Initial Sprint Commitment: 26 Story Points**

The team selects 26 points based on the assumed planning rate, story complexity, and capacity. This is a provisional planning estimate, not a standard conversion between hours and story points.

## 2. Sprint Goal

By the end of the 8-day sprint, deliver a tested web check-in experience that enables passengers to retrieve bookings, select available seats, generate boarding passes, and complete eligible seat upgrades using a payment-gateway sandbox, with committed stories meeting their acceptance criteria and Definition of Done.

## 3. Selected Sprint Backlog

| Jira Key | User Story | Priority | SP | Assignee | Initial Status |
|---|---|---|---:|---|---|
| AWC-101 | Retrieve Passenger Booking | Highest | 5 | Dev 1 | To Do |
| AWC-102 | Seat Selection | High | 8 | Dev 2 | To Do |
| AWC-103 | Seat Upgrade Payment | High | 8 | Dev 3 | To Do |
| AWC-104 | Generate Boarding Pass | High | 5 | Dev 4 | To Do |
| **Total** | | | **26** | | |

The selected stories support the web check-in workflow.

## 4. User Stories and Acceptance Criteria

### AWC-101 – Retrieve Passenger Booking (5 SP)

**User Story:** As a passenger, I want to retrieve my booking using my PNR and surname so that I can begin web check-in.

**Acceptance Criteria:**
- Valid PNR and surname retrieve the correct booking.
- Invalid booking details display an appropriate error.
- Only eligible bookings can proceed to check-in.

### AWC-102 – Seat Selection (8 SP)

**User Story:** As a passenger, I want to view and select available seats so that I can choose my preferred seat during check-in.

**Acceptance Criteria:**
- Available and occupied seats are displayed correctly.
- Occupied seats cannot be selected.
- Selected seats are saved against the correct booking.
- Concurrent requests cannot assign the same seat twice.

### AWC-103 – Seat Upgrade Payment (8 SP)

**User Story:** As a passenger, I want to pay for an eligible seat upgrade so that I can confirm a premium seat.

**Acceptance Criteria:**
- Eligible upgrades display the correct price.
- Payment is processed through the sandbox gateway.
- Successful payment confirms the upgraded seat.
- Failed payment does not confirm the upgrade.
- Duplicate payment callbacks do not create duplicate charges.

### AWC-104 – Generate Boarding Pass (5 SP)

**User Story:** As a checked-in passenger, I want to generate a boarding pass so that I can access my flight and seat information.

**Acceptance Criteria:**
- Boarding pass is generated for a successfully checked-in passenger.
- Passenger name, flight details, and assigned seat are correct.
- Boarding pass is available for download.
- Invalid or incomplete check-in does not generate a valid boarding pass.

## 5. Definition of Ready Verification

The Definition of Ready (DoR) is a team-agreed refinement practice used to assess whether a story is sufficiently understood before development. It is not a mandatory Scrum artifact.

| Story | Clear Requirements | Acceptance Criteria | Estimated | Dependencies Identified | Ready at Planning |
|---|---|---|---|---|---|
| AWC-101 | Yes | Yes | 5 SP | Booking test data available | Yes |
| AWC-102 | Yes | Yes | 8 SP | Seat inventory API available | Yes |
| AWC-103 | Yes | Yes | 8 SP | Payment sandbox confirmed available at planning | Yes |
| AWC-104 | Yes | Yes | 5 SP | Booking and seat data available | Yes |

**Readiness Decision:** All four stories are considered ready at Sprint Planning.

The payment sandbox becomes unavailable during sprint execution. This is a newly occurring impediment, not a known readiness failure at planning.

## 6. Mid-Sprint Dependency Status

**Blocked Story:** AWC-103 – Seat Upgrade Payment

**Issue:** Payment-gateway sandbox becomes unavailable during the sprint.

**Impact:** End-to-end payment validation and upgrade confirmation cannot be completed.

**Immediate Response:**
- Developer 3 flags AWC-103 as blocked.
- Scrum Master escalates the sandbox outage.
- Developers continue independent validation using mock gateway responses.
- Product Owner is informed about the risk to the Sprint Goal.

**Sprint Scope:** 26 SP remains the initial commitment.

The team does not automatically remove or replace AWC-103. Any Sprint Backlog adjustment requires discussion between the Developers and Product Owner while protecting the Sprint Goal.

## 7. Next Sprint Backlog Refinement

**Session:** Backlog Refinement – Day 6  
**Participants:** Product Owner, Developers, Scrum Master  
**Purpose:** Clarify, split, and estimate the top five Product Backlog stories for the next sprint.

### Top Five Backlog Items

| Priority | Story Key | Story | Initial SP |
|---|---|---|---:|
| 1 | AWC-105 | Flight Change Management | 13 |
| 2 | AWC-106 | Baggage Allowance Display | 5 |
| 3 | AWC-107 | Check-in Confirmation Email | 3 |
| 4 | AWC-108 | Passenger Contact Updates | 3 |
| 5 | AWC-109 | Mobile Check-in Optimization | 8 |

### Oversized Story Identification

**AWC-105 – Flight Change Management (13 SP)**

The team identifies this story as too large for predictable implementation within one sprint because it combines flight search, eligibility checks, and booking updates.

### Story Splitting

| New Story Key | Refined Story | SP |
|---|---|---:|
| AWC-110 | Search Eligible Alternative Flights | 5 |
| AWC-111 | Validate Flight Change Rules | 3 |
| AWC-112 | Confirm Flight Change and Update Booking | 5 |
| **Total** | | **13** |

### Refinement Outcome

- AWC-105 is split into three smaller stories.
- Each new story receives separate acceptance criteria.
- Dependencies between the stories are identified.
- The original 13-point estimate is replaced by three estimates of 5, 3, and 5 points.
- The total remains 13 SP, but each story can now be planned and tracked separately.

The Product Owner updates the Product Backlog order. The Developers refine estimates and implementation dependencies.



## 8. Sprint Planning Summary

| Parameter | Result |
|---|---|
| Effective Capacity | 268.8 hours |
| Planning Commitment | 26 SP |
| Selected Stories | 4 |
| Initially Ready Stories | 4 |
| Blocked During Sprint | AWC-103 |
| Refined Next-Sprint Stories | 5 original items reviewed |
| Oversized Story Split | AWC-105 into 3 stories |


<img width="1737" height="637" alt="image" src="https://github.com/user-attachments/assets/b706970d-070f-4a10-9dad-ba3b878785a4" />
