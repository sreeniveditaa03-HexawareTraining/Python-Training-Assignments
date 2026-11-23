# Scrum Documentation – Online Grocery Delivery

**Project:** Online Grocery Delivery Application  
**Backlog:** 3 epics, 12 stories, 47 story points

## 1. Product Vision

Enable customers of a regional supermarket chain to conveniently find available groceries, place secure orders, select delivery slots, and follow delivery progress through one reliable application.

### Scrum Roles and Anti-Patterns

| Role | Responsibility | Anti-pattern |
|---|---|---|
| Product Owner | Orders backlog and maximizes value | Changes priorities without explaining business value |
| Scrum Master | Helps the team use Scrum effectively and remove impediments | Assigns tasks as a command-and-control manager |
| Developers | Plan, build, test, and deliver a usable Increment | Work in isolated silos without shared quality ownership |

## 2. Epics and Stories

The 3 epics are **Browse and Search**, **Cart and Checkout**, and **Delivery Tracking**. Their objectives are in `01_Epics.csv`; all 12 complete **As a / I want / so that** stories, MoSCoW priorities, and estimates are in `02_Product_Backlog.csv`.

## 3. INVEST Review

**I** Independent · **N** Negotiable · **V** Valuable · **E** Estimable · **S** Small · **T** Testable

| Story | I | N | V | E | S | T | Review |
|---|---|---|---|---|---|---|---|
| OGD-101 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Pass after refinement |
| OGD-102 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Pass after refinement |
| OGD-103 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Pass after refinement |
| OGD-104 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Pass after refinement |
| OGD-105 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Pass after refinement |
| OGD-106 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Pass after refinement |
| OGD-107 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Pass after refinement |
| OGD-108 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Pass after refinement |
| OGD-109 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Pass after refinement |
| OGD-110 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Pass after refinement |
| OGD-111 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Pass after refinement |
| OGD-112 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Pass after refinement |

**Rewritten story 1**  
Before: “As a shopper, I want to search, filter, compare, and order every grocery so that shopping is easier.”  
Failure: Too broad; not Small or easily Estimable/Testable.  
After (OGD-102): “As a shopper, I want to search groceries by name so that I can find a specific item quickly.”

**Rewritten story 2**  
Before: “As a shopper, I want to track, cancel, return, and reschedule orders so that I can manage everything.”  
Failure: Multiple workflows; not Small and difficult to estimate.  
After (OGD-109): “As a shopper, I want to view the current status of my grocery order so that I know its delivery progress.”

The INVEST table assesses the **final refined** stories, not the original drafts. Dependencies are identified without requiring every story to be technically isolated.

## 4. Given / When / Then Acceptance Criteria

**OGD-102 – Search Grocery Items**  
Given the shopper is on the grocery catalog  
When the shopper searches for “rice”  
Then matching grocery items are shown.

**Negative scenario:** Given no catalog items match the search term  
When the shopper searches  
Then the application shows “No items found” without an error.

**OGD-105 – Add Item to Cart**  
Given an item is in stock  
When the shopper selects Add to Cart  
Then the item appears in the cart with the correct price and quantity.

**Negative scenario:** Given an item is out of stock  
When the shopper tries to add it  
Then the application rejects the action and shows an availability message.

**OGD-107 – Select Delivery Slot**  
Given delivery slots are available for the shopper's address  
When the shopper selects an open slot  
Then that slot is reserved for checkout according to the configured reservation policy.

**OGD-108 – Secure Checkout**  
Given the cart and delivery details are valid  
When the payment provider confirms successful payment  
Then the order is confirmed and a unique order number is displayed.

**Negative scenario:** Given the payment provider rejects payment  
When checkout receives the failed response  
Then the order is not marked as paid and the shopper sees an error.

**OGD-109 – View Order Status**  
Given the shopper owns an existing grocery order  
When the shopper opens its details  
Then the latest recorded order status is displayed.

**Negative scenario:** Given the shopper does not own the requested order  
When they attempt to view its details  
Then access is denied without revealing another customer's order information.

## 5. MoSCoW and Planning Poker

MoSCoW priorities and Fibonacci estimates are recorded per story in `02_Product_Backlog.csv`. **Must Have** covers core discovery, cart, checkout, and status; **Should Have** covers convenience; **Could Have** covers optional delivery enhancements. **Won't Have for the first release:** subscriptions, coupons, and returns processing.

**Fibonacci scale:** 1, 2, 3, 5, 8, 13.  
**Reference story:** OGD-105 – Add Item to Cart, **3 SP**. It is familiar, narrowly scoped, and independently testable, making it a useful baseline for relative estimation.

| Story | Planning Poker votes | Agreed SP |
|---|---|---:|
| OGD-105 – Add Item to Cart | 3, 3, 3, 5 | 3 |
| OGD-102 – Search Grocery Items | 3, 5, 5, 8 | 5 |
| OGD-107 – Select Delivery Slot | 5, 5, 8, 5 | 5 |
| OGD-108 – Secure Checkout | 5, 8, 8, 13 | 8 |

The estimates were finalized after comparing the votes and discussing differences. The remaining stories use the same reference scale; the CSV contains their final estimates. **Total backlog: 47 SP**, not a sprint commitment.

## 6. Jira Backlog Organization

The backlog was organized into three epics and twelve linked user stories, with MoSCoW priorities, Fibonacci estimates, and acceptance criteria documented. The Definition of Ready and Definition of Done are recorded in `04_DoR_DoD.md`. The accompanying Jira-style board image illustrates the planned issue structure; it is not a Jira publication record.
