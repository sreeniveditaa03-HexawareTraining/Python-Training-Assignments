# Sprint Review Agenda – Airline Web Check-in

**Project:** Airline Web Check-in  
**Sprint:** Sprint 01 – Check-in Improvements  
**Review Day:** Day 8  
**Duration:** 45 Minutes  
**Facilitator:** Scrum Master  
**Participants:** Scrum Team and Business Stakeholders  
**Review Status:** Simulated Sprint Review

## 1. Sprint Review Objective

To inspect the completed web check-in functionality, demonstrate working features against acceptance criteria, discuss the impact of the payment-gateway outage, and gather stakeholder feedback for future backlog decisions.

## 2. Sprint Review Agenda

| Time | Agenda Item | Presenter |
|---|---|---|
| 0–5 min | Sprint Goal and scope overview | Product Owner |
| 5–15 min | Booking retrieval demonstration | Developer 1 |
| 15–25 min | Seat selection demonstration | Developer 2 |
| 25–32 min | Boarding pass generation demonstration | Developer 4 |
| 32–37 min | Seat-upgrade blocker and mock-test progress | Developer 3 |
| 37–42 min | Stakeholder feedback and Product Backlog discussion | Product Owner |
| 42–45 min | Summary and next steps | Scrum Master |

## 3. Sprint Completion Summary

| Story | SP | Review Status |
|---|---:|---|
| AWC-101 – Retrieve Passenger Booking | 5 | Done |
| AWC-102 – Seat Selection | 8 | Done |
| AWC-103 – Seat Upgrade Payment | 8 | Blocked / Incomplete |
| AWC-104 – Generate Boarding Pass | 5 | Done |
| **Total Completed** | **18 / 26** | |

The seat-upgrade story remains incomplete because end-to-end gateway validation could not be completed.

The original Sprint Goal is therefore only partially achieved.

## 4. Demonstration Script

### Demo 1 – Retrieve Passenger Booking (AWC-101)

**Presenter:** Developer 1

**Steps:**
1. Open the Airline Web Check-in page.
2. Enter a valid PNR and passenger surname.
3. Select Retrieve Booking.
4. Verify that the correct booking and flight details appear.
5. Enter an invalid PNR and verify that an error message appears.

**Acceptance Criteria Verified:**
- Valid booking retrieval
- Invalid booking handling
- Check-in eligibility validation

**Expected Result:** Correct passenger booking is retrieved securely.

### Demo 2 – Seat Selection (AWC-102)

**Presenter:** Developer 2

**Steps:**
1. Open the seat selection page for the retrieved booking.
2. Display available and occupied seats.
3. Select an available seat.
4. Confirm the seat selection.
5. Attempt to select an occupied seat and verify rejection.

**Acceptance Criteria Verified:**
- Seat availability displayed correctly
- Occupied seats cannot be selected
- Selected seat saved to the correct booking
- Duplicate seat allocation prevented

**Expected Result:** The selected seat is correctly assigned to the passenger.

### Demo 3 – Generate Boarding Pass (AWC-104)

**Presenter:** Developer 4

**Steps:**
1. Open a successfully checked-in booking.
2. Select Generate Boarding Pass.
3. Verify passenger name, flight details, and seat number.
4. Download the boarding pass.
5. Verify that incomplete check-in cannot generate a valid boarding pass.

**Acceptance Criteria Verified:**
- Correct boarding pass information
- Download functionality
- Check-in validation

**Expected Result:** A valid boarding pass is generated for an eligible checked-in passenger.

### Demo 4 – Seat Upgrade Payment (AWC-103)

**Presenter:** Developer 3

**Status:** Blocked – Not Accepted as Done

**Steps:**
1. Explain the intended seat-upgrade workflow.
2. Show the implemented upgrade eligibility and pricing validation.
3. Demonstrate available mock payment response handling.
4. Explain that actual sandbox payment verification remains unavailable.
5. Present the outstanding integration and acceptance checks.

**Outstanding Acceptance Criteria:**
- Actual sandbox payment success validation
- Actual sandbox payment failure validation
- Confirmed upgrade after successful gateway payment
- End-to-end duplicate-callback verification

**Review Result:** Partial implementation may be inspected, but the story is not accepted as complete.

## 5. Stakeholder Feedback

The following feedback is recorded as an illustrative review outcome:

| Feedback | Source | Follow-Up |
|---|---|---|
| Improve seat availability refresh behavior | Business Stakeholder | Review during backlog refinement |
| Provide clearer payment failure messages | Product Owner | Update AWC-103 acceptance criteria |
| Prioritize sandbox integration recovery | Technical Stakeholder | Continue escalation |

## 6. Sprint Review Outcome

**Completed:** AWC-101, AWC-102, AWC-104  
**Incomplete:** AWC-103  
**Completed Story Points:** 18 SP  
**Remaining Story Points:** 8 SP

The Product Owner updates the Product Backlog based on stakeholder feedback and unresolved integration work.

The Developers reassess AWC-103 for future planning. Its remaining work is not automatically carried into a new sprint without a planning decision.

## 7. Conclusion

The Sprint Review demonstrates the completed web check-in features and makes the blocked seat-upgrade functionality transparent.

The team receives stakeholder feedback and identifies the next steps required to finish payment integration.


<img width="590" height="507" alt="image" src="https://github.com/user-attachments/assets/0b817e5c-0918-43b2-a66a-b094c4779fe3" />
