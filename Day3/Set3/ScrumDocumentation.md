# Scrum Documentation – Hospital Appointment Booking Application

**Project:** Hospital Appointment Booking Application  
**Project key (proposed):** HAB  
**Backlog:** 4 epics, 12 stories, **46 story points**

## 1. Product Vision and Stakeholders

**Vision:** Provide patients with a reliable mobile experience for finding doctors, booking, rescheduling and cancelling appointments, and receiving timely reminders, while giving hospital staff accurate control of doctor availability.

| Stakeholder | Scrum role / relationship | Interest |
|---|---|---|
| Hospital digital-services representative | Product Owner | Product value, backlog order and release priorities |
| Agile delivery facilitator | Scrum Master | Scrum effectiveness and impediment removal |
| Mobile engineers, backend engineers, QA and UX specialists | Developers | Usable, tested increments |
| Patients | Customer | Convenient and reliable appointments |
| Doctors | Customer / domain stakeholder | Accurate schedule and appointment visibility |
| Reception and scheduling staff | Customer / operational stakeholder | Correct slot availability and changes |
| Hospital management | Customer / business stakeholder | Adoption, operational efficiency and service quality |

The Scrum Team roles are Product Owner, Scrum Master and Developers; customers and hospital stakeholders provide requirements and feedback.

## 2. Epics and User Stories

Four epics were defined: **Appointment Booking (EP-01)**, **Rescheduling and Cancellation (EP-02)**, **Appointment Reminders (EP-03)**, and **Doctor Schedule Management (EP-04)**. Three stories were specified for each epic. Their full “As a / I want / so that” descriptions, value scores, estimates and priorities are recorded in `01_Epics.csv` and `02_Prioritised_Backlog.csv`.

## 3. INVEST Review

INVEST = Independent, Negotiable, Valuable, Estimable, Small, Testable. The final story set was reviewed against all six qualities.

| Story | I | N | V | E | S | T | Result |
|---|---|---|---|---|---|---|---|
| HAB-101 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Ready for refinement |
| HAB-102 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Ready for refinement |
| HAB-103 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Ready for refinement |
| HAB-104 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Ready for refinement |
| HAB-105 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Ready for refinement |
| HAB-106 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Ready for refinement |
| HAB-107 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Ready for refinement |
| HAB-108 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Ready for refinement |
| HAB-109 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Ready for refinement |
| HAB-110 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Ready for refinement |
| HAB-111 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Ready for refinement |
| HAB-112 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Ready for refinement |

**Rewrite 1 – independence:** Original: “As a patient, I want to book an appointment and receive a reminder so that I can visit the doctor.” This coupled booking to notifications. **Revised HAB-103:** “As a patient, I want to reserve an available appointment slot so that I can receive a confirmed consultation.” Reminder delivery was separated into HAB-108.

**Rewrite 2 – testability:** Original: “As a patient, I want easy appointment cancellation so that I am not inconvenienced.” “Easy” was not objectively testable. **Revised HAB-105:** “As a patient, I want to cancel a future appointment so that the slot becomes available to others.” Testable outcomes include cancellation status and slot release.

The INVEST review is a planning assessment; integration dependencies between stories remain visible during refinement.

## 4. Acceptance Criteria – Given / When / Then

### HAB-103 – Book an Appointment

**Successful booking**  
Given a patient is signed in and an available doctor slot is displayed  
When the patient confirms that slot  
Then the appointment is created with a unique confirmation and the slot becomes unavailable to other patients.

**Negative: slot already taken**  
Given a slot has already been reserved by another patient  
When a second patient attempts to confirm the same slot  
Then the booking is rejected, no duplicate appointment is created, and the patient is asked to choose another slot.

**Invalid booking**  
Given a patient has not selected a valid slot  
When the patient submits the booking request  
Then the request is rejected with a clear validation message.

### HAB-105 – Cancel Appointment

**Successful cancellation**  
Given a patient has a confirmed future appointment eligible for cancellation  
When the patient confirms cancellation  
Then the appointment status changes to Cancelled and the released slot becomes available for booking.

**Negative: already cancelled**  
Given an appointment is already cancelled  
When the patient attempts to cancel it again  
Then no duplicate cancellation occurs and the current status is shown.

**Negative: unauthorized cancellation**  
Given a patient does not own the appointment  
When that patient attempts to cancel it  
Then the request is denied without changing the appointment.

## 5. Business Value, Effort and Planning Poker

Stories were ranked using a **1–5 business-value score** and relative Fibonacci effort (**3 or 5 SP** in this backlog). Higher-value core booking and schedule stories received priority; value-to-effort ratio was used as a supporting comparison rather than the sole decision rule. The resulting ranked backlog is in `02_Prioritised_Backlog.csv`.

**Reference story:** HAB-102 – View Available Appointment Slots, **3 SP**. It has a bounded display-and-validation scope, clear expected results, and limited workflow complexity, making it a useful baseline.

| Story | Example Planning Poker votes | Final estimate | Reason |
|---|---|---:|---|
| HAB-102 – View Available Slots | 2, 3, 3, 5 | 3 | Reference story; availability read and display |
| HAB-103 – Book Appointment | 3, 5, 5, 8 | 5 | Concurrent booking and double-booking prevention |
| HAB-105 – Cancel Appointment | 2, 3, 3, 5 | 3 | Status update and slot release |
| HAB-110 – Set Doctor Availability | 3, 5, 5, 8 | 5 | Schedule validation and conflicts |

The estimates represent a planning exercise; they are not a record of an actual voting session.

**Story points versus hours:** A story point expresses *relative effort, complexity and uncertainty*; an hour measures *elapsed working time*. A 5-point story is not automatically five hours, and story points are not converted to hours at a fixed rate.

## 6. Jira Backlog Structure

The backlog is organized under four epics, with 12 associated stories and **46 total story points**. 
