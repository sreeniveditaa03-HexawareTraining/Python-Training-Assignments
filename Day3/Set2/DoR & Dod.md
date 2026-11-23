# Definition of Ready and Definition of Done

**Project:** Online Grocery Delivery Application

## Definition of Ready (DoR)

The team defined the following readiness criteria for Sprint Planning:

| Area | Team agreement |
|---|---|
| User Story | Clear role, request, and business value |
| Acceptance Criteria | Testable scenarios recorded |
| Dependencies | APIs, stock data, delivery service, and payment dependencies identified |
| Estimation | Developers agree on Fibonacci story points |
| Scope | Small enough to complete within a sprint |
| Priority | Product Owner has ordered the backlog item |
| Clarification | Important open questions have been addressed |

DoR is a helpful team agreement, **not a mandatory Scrum artifact**.

## Definition of Done (DoD)

| Area | Completion standard |
|---|---|
| Implementation | Agreed functionality works |
| Acceptance | All acceptance criteria satisfied |
| Unit tests | Required tests pass |
| Integration tests | Applicable stock, payment, and delivery integrations pass |
| Code quality | Lint and agreed quality checks pass |
| Review | Peer review approved |
| CI / Build | Required pipeline and build checks pass |
| Security | Authentication, authorization, and payment-related checks pass where applicable |
| Merge | Changes integrated into the agreed branch |
| Documentation | Relevant technical and user-facing documentation updated |

**Jira workflow:** Product Backlog → To Do → In Progress → Review / Testing → Done. Exact statuses depend on the project configuration. The team agreed that only items meeting the DoD qualify as Done.

**Example – OGD-105 Add Item to Cart:** The readiness criteria cover stock behavior, acceptance criteria, and the 3-SP estimate. The completion criteria cover successful add-to-cart behavior, out-of-stock rejection, automated testing, peer review, and integration.
