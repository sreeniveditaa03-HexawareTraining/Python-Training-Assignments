# Definition of Ready and Definition of Done

**Project:** Hospital Appointment Booking Application  
**Framework:** Scrum

## Definition of Ready (DoR)

The team documented the following readiness criteria for backlog refinement and Sprint Planning:

-  Story is expressed as “As a / I want / so that.”
-  Business value and intended user are clear.
-  Acceptance criteria are specific and testable.
-  Dependencies on doctor schedules, patient identity and notifications are identified.
-  Required API contracts and sample data are understood.
-  Story has a Fibonacci estimate agreed by Developers.
-  Story is small enough to complete within a sprint.
-  Product Owner has ordered the story in the backlog.

DoR is a team working agreement, not a mandatory Scrum artifact.

## Definition of Done (DoD)

The team documented the following quality conditions for completed work:

-  Implementation meets the agreed story scope.
-  All acceptance criteria are satisfied.
-  Unit tests pass, including relevant validation and failure cases.
-  Integration tests pass for booking, schedule changes or notification interfaces as applicable.
-  Concurrent slot booking cannot create duplicate confirmed reservations.
-  Authentication, authorization and patient-data protection checks pass where applicable.
-  Code review is completed and feedback addressed.
-  Linting, build and required CI checks pass.
-  Approved changes are merged into the agreed integration branch.
-  Required documentation and test evidence are updated.

A story is counted as Done only after all applicable DoD conditions are met. Partially completed stories do not count as completed increments.

## Jira Workflow

**Backlog → Selected for Sprint → To Do → In Progress → Review / Test → Done**

The precise workflow depends on the Jira project configuration. DoR supports selection, while DoD determines whether an item can be marked Done.
