# Scrum Documentation – Online Shopping Application

**Project:** Online Shopping Application  
**Framework:** Scrum  
**Backlog:** 3 epics, 12 user stories, 47 story points  
**Estimation:** Fibonacci Planning Poker  
**Prioritization:** MoSCoW

## 1. Product Vision

To Deliver a secure, convenient online shopping experience that lets customers discover products, complete purchases, and track deliveries in one place.

## 2. Scrum Roles and Anti-Patterns

| Scrum Role | Responsibility | Anti-Pattern |
|---|---|---|
| Product Owner | Orders the Product Backlog and maximizes product value | Changes priorities without explaining business impact |
| Scrum Master | Helps the team apply Scrum and remove impediments | Assigns tasks as a line manager |
| Developers | Build, test, and deliver usable increments | Work in silos without shared quality ownership |

## 3. Epic and Backlog Structure

| Epic ID | Epic | Stories | Points |
|---|---|---|---:|
| EPIC-01 | Browse and Search | OSA-101 to OSA-104 | 16 |
| EPIC-02 | Cart and Checkout | OSA-105 to OSA-108 | 17 |
| EPIC-03 | Delivery Tracking | OSA-109 to OSA-112 | 14 |
| **Total** | **3 epics** | **12 stories** | **47** |

The full **As a / I want / so that** descriptions, MoSCoW priorities, and Fibonacci estimates are recorded in `02_Product_Backlog.csv`. Epic descriptions are in `01_Epics.csv`.

## 4. INVEST Review

**INVEST:** Independent, Negotiable, Valuable, Estimable, Small, Testable.

| Story | I | N | V | E | S | T | Result |
|---|---|---|---|---|---|---|---|
| OSA-101 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Pass |
| OSA-102 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Pass after rewrite |
| OSA-103 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Pass |
| OSA-104 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Pass |
| OSA-105 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Pass |
| OSA-106 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Pass |
| OSA-107 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Pass |
| OSA-108 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Pass |
| OSA-109 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Pass after rewrite |
| OSA-110 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Pass |
| OSA-111 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Pass |
| OSA-112 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Pass |

**Rewrite 1 – OSA-102**  
Before: As a customer, I want to search, filter, compare, and review products so that I can shop easily.  
**Failed:** Small, Estimable, Testable (too many capabilities).  
After: As a customer, I want to search products by keyword so that I can quickly locate an item.

**Rewrite 2 – OSA-109**  
Before: As a customer, I want to track, cancel, return, and manage deliveries so that I can control my orders.  
**Failed:** Independent, Small, Estimable (multiple workflows).  
After: As a customer, I want to view my order status so that I can track its progress.

## 5. Acceptance Criteria – Given / When / Then

### OSA-102 – Search Products

**Positive:** Given the customer is on the search page, when they search for an available product keyword, then matching products are displayed.  
**Negative:** Given no product matches the keyword, when the search is submitted, then a "No products found" message is displayed.

### OSA-105 – Add to Cart

**Positive:** Given a product is in stock, when the customer selects Add to Cart, then the product appears in the cart.  
**Negative:** Given a product is out of stock, when the customer attempts to add it, then the addition is prevented and an availability message appears.

### OSA-107 – Secure Payment

**Positive:** Given a valid checkout order, when the payment gateway confirms payment, then the order is marked paid and a receipt is recorded.  
**Negative:** Given the gateway rejects payment, when the customer submits the transaction, then the order remains unpaid and an error is displayed.

### OSA-108 – Order Confirmation

Given payment succeeds, when the order is created, then the customer sees an order number and order summary.

### OSA-109 – View Order Status

**Positive:** Given a customer has placed an order, when they open its details, then its current status is displayed.  
**Negative:** Given a customer does not own an order, when they request its details, then access is denied without revealing order information.

## 6. MoSCoW Prioritization

**Must Have:** OSA-101, OSA-102, OSA-104, OSA-105, OSA-107, OSA-108, OSA-109.  
**Should Have:** OSA-103, OSA-106, OSA-110.  
**Could Have:** OSA-111, OSA-112.  
**Won't Have (current release):** Product comparison, order cancellation, returns management.

All 12 priorities are recorded against individual stories in `02_Product_Backlog.csv`.

## 7. Planning Poker and Reference Story

**Fibonacci scale:** 1, 2, 3, 5, 8, 13.  
**Reference:** OSA-105 – Add to Cart = **3 SP**, chosen because its scope is clear, familiar, and independently testable. Developers compare other stories against this baseline.

| Story | Example Developer Votes | Agreed Estimate |
|---|---|---:|
| OSA-105 – Add to Cart | 3, 3, 3, 5 | 3 |
| OSA-102 – Search Products | 3, 5, 5, 8 | 5 |
| OSA-107 – Secure Payment | 5, 8, 8, 13 | 8 |
| OSA-109 – View Order Status | 2, 3, 3, 5 | 3 |

Differences are discussed before the team agrees on estimates. Final Fibonacci estimates for **all 12 stories** are in the backlog CSV. These votes illustrate the estimation exercise; they are not an actual recorded meeting.

## 8. Jira Publication

The three Epic issues and twelve Story issues in the Jira project, link each story to its epic, and record the estimates, MoSCoW labels, and acceptance criteria.  The actual Jira Backlog or Board view as `05_Jira_Board.png`. Jira-generated issue keys may differ from the planning references used here.
