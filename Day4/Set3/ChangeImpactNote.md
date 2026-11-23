# Change Impact Note – E-Learning Platform

**Project:** E-Learning Platform  
**Sprint:** Sprint 01 – Learning Experience  
**Change Request:** CR-001  
**Requested On:** Day 6  
**Requested By:** Product Owner  
**New Feature:** Certificate Download

## 1. Change Request Overview

On Day 6 of the 10-day sprint, the Product Owner requests a Certificate Download feature for the upcoming platform launch.

**New Jira Story:** ELP-109 – Certificate Download  
**Priority:** Highest  
**Estimated Size:** 5 SP

### User Story

As a learner who has successfully completed a course, I want to download a completion certificate so that I can retain proof of my achievement.

### Acceptance Criteria

- Certificates are available only after successful course completion.
- Certificates contain the correct learner name, course name, and completion date.
- Certificates can be downloaded in PDF format.
- Unauthorized certificate downloads are rejected.
- Certificate generation and download tests pass.

## 2. Sprint Scope Before Change

| Jira Key | User Story | SP | Day 6 Status |
|---|---|---:|---|
| ELP-101 | Course Enrollment | 8 | Done |
| ELP-102 | Video Lesson Player | 8 | Done |
| ELP-103 | Quiz and Assessment | 5 | In Progress |
| ELP-104 | Learning Progress Tracking | 5 | In Progress |
| ELP-105 | Course Rating and Feedback | 4 | To Do |
| **Total** | | **30** | |

**Completed on Day 6:** 16 SP  
**Remaining Work:** 14 SP

## 3. Change Impact Analysis

| Factor | Assessment |
|---|---|
| New Request | ELP-109 – Certificate Download (5 SP) |
| Business Priority | Highest – Upcoming Launch |
| Sprint Day | Day 6 of 10 |
| Available Time | 4 working days after Day 6 |
| Candidate for Removal | ELP-105 – Course Rating (4 SP) |
| Sprint Goal Impact | Must preserve enrollment, video, quiz, and progress features |
| Main Risk | Missing certificate-generation API contract |

### What Can Be Swapped Out?

ELP-105 – Course Rating and Feedback (4 SP) is a suitable candidate because it is not essential to the Sprint Goal and has not started.

It can be returned to the Product Backlog for future prioritization.

### What Must Wait?

ELP-106 – Discussion Forum, ELP-107 – Email Notifications, and ELP-108 – Learner Profile Customization remain in the Product Backlog.

The Product Owner must also consider deferring ELP-109 if the team cannot complete the certificate feature safely within the remaining sprint.

### Revised Scope Proposal

| Action | Story | SP |
|---|---|---:|
| Remove from Sprint | ELP-105 – Course Rating | -4 |
| Add to Sprint | ELP-109 – Certificate Download | +5 |
| Net Scope Change | | +1 |

**Revised Sprint Scope: 31 SP**

This is not an equal-point exchange. The change increases estimated scope by 1 SP.

## 4. Sprint Goal Protection

The original Sprint Goal remains unchanged:

Deliver course enrollment, video lessons, quizzes, and learning progress tracking.

The Developers and Product Owner agree that the four goal-critical stories retain priority.

**Decision:** Conditionally approve ELP-109 for Sprint 01 only if the API contract is clarified and the Developers judge the remaining work feasible.

If the dependency cannot be resolved promptly, ELP-109 stays in the Product Backlog for the next sprint.

The Product Owner orders the backlog, while the Developers negotiate the Sprint Backlog changes with the Product Owner. The Scrum Master facilitates this discussion.

## 5. Day 6 – Developer Stand-up Update

**Developer:** Dev 5  
**Affected Story:** ELP-109 – Certificate Download

**Yesterday:**
- Reviewed certificate generation requirements.
- Identified required learner and course completion data.
- Prepared a proposed certificate download API request.

**Today:**
- Clarify the API response contract with the backend developer.
- Prepare PDF certificate layout and validation scenarios.
- Continue work that does not depend on the missing API contract.

**Impediment:**
- Certificate-generation API contract is not finalized.
- Endpoint details, response fields, and error handling are unclear.
- End-to-end integration cannot proceed.

## 6. Scrum Master Follow-Up

| Action | Owner | Target |
|---|---|---|
| Record and flag ELP-109 as blocked | Dev 5 | Day 6 |
| Arrange API contract discussion | Scrum Master | Day 6 |
| Confirm endpoint, payload, and error responses | Backend Developer | Day 7 |
| Review revised scope feasibility | Developers and Product Owner | Day 7 |
| Escalate unresolved dependency | Scrum Master | Day 7 |

The Scrum Master facilitates the removal of the impediment by connecting the relevant Developers, clarifying ownership, and escalating unresolved dependencies.

The Scrum Master does not independently approve scope changes or guarantee delivery.

## 7. Short Note – Automation and Definition of Done

Automation supports the Definition of Done by providing repeatable quality checks throughout development.

| Automation | Purpose | DoD Contribution |
|---|---|---|
| Unit Tests | Validate enrollment, quiz scoring, progress calculation, and certificate eligibility | Required functionality passes automated tests |
| Linting | Detect coding-standard violations and common code issues | Code satisfies agreed quality checks |
| CI Pipeline | Run automated checks when changes are pushed or pull requests are created | Required checks pass before merge |

**Proposed Workflow:**

Code Commit → Lint → Unit Tests → Build → Code Review → Merge

For ELP-109, automated tests should verify course completion eligibility, correct certificate details, and rejection of unauthorized requests.

Automation supports the Definition of Done but does not replace integration testing, code review, or validation against acceptance criteria.

## 8. Change Decision Summary

**Requested:** Certificate Download – 5 SP  
**Proposed Removal:** Course Rating – 4 SP  
**Potential Revised Scope:** 31 SP  
**Sprint Goal:** Unchanged  
**Current Decision:** Conditional – Pending API Contract and Feasibility Review

The team protects the Sprint Goal by prioritizing goal-critical work and avoiding an unconditional commitment to the new feature.
