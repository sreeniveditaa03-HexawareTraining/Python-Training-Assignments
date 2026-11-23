# Definition of Ready and Definition of Done

**Project:** Online Shopping Application  
**Framework:** Scrum

## 1. Definition of Ready (DoR)

A story is ready for Sprint Planning when:

| Criterion | Requirement |
|---|---|
| Story | Clear **As a / I want / so that** description |
| Value | Business purpose understood |
| Acceptance | Testable acceptance criteria defined |
| Dependencies | Relevant APIs, data, and external dependencies identified |
| Estimate | Developers agree on Fibonacci story points |
| Size | Small enough to complete within one sprint |
| Priority | Product Owner has ordered the story |
| Clarification | Major open questions resolved |

DoR is a team-agreed refinement aid, not a mandatory Scrum artifact.

## 2. Definition of Done (DoD)

| Area | Completion Requirement |
|---|---|
| Functionality | Agreed behavior implemented |
| Acceptance | All applicable acceptance criteria satisfied |
| Unit Tests | Relevant automated unit tests pass |
| Integration | Relevant integration tests pass |
| Code Quality | Linting and agreed coding standards pass |
| Review | Peer code review completed |
| Build / CI | Required build and pipeline checks pass |
| Security | Applicable authorization and data-protection checks pass |
| Merge | Approved code integrated into agreed branch |
| Documentation | Necessary documentation updated |

A story is **Done** only when all applicable DoD requirements are met.

## 3. Jira Workflow

**Backlog → To Do → In Progress → Review / Testing → Done**

Exact statuses depend on Jira configuration. A story is moved to **Done** only after meeting the DoD.

## 4. Example – OSA-105 Add to Cart

**DoR:** Clear user story, stock-validation acceptance criteria, known cart dependencies, and a 3 SP estimate.  
**DoD:** Product is added only when available, relevant tests and CI checks pass, code review is complete, and changes are merged.
