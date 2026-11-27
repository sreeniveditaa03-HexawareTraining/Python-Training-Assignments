# SET 1 – LOAN ELIGIBILITY ENGINE

from typing import Any

# Applicant records
applicants: list[dict[str, Any]] = [
    {"name": "Arun", "age": 25, "income": 50000, "emi": 10000,
     "score": 780, "employment": "salaried", "loans": 1},
    {"name": "Priya", "age": 30, "income": 60000, "emi": 15000,
     "score": 720, "employment": "salaried", "loans": 2},
    {"name": "Kumar", "age": 19, "income": 40000, "emi": 5000,
     "score": 650, "employment": "self-employed", "loans": 0},
    {"name": "Meena", "age": 45, "income": 80000, "emi": 20000,
     "score": 810, "employment": "salaried", "loans": 1},
    {"name": "Ravi", "age": 35, "income": 30000, "emi": 25000,
     "score": 590, "employment": "salaried", "loans": 3},
    {"name": "Sara", "age": 28, "income": 45000, "emi": 10000,
     "score": 680, "employment": "self-employed", "loans": 1},
    {"name": "John", "age": 65, "income": 50000, "emi": 10000,
     "score": 750, "employment": "salaried", "loans": 0},
    {"name": "Anu", "age": 32, "income": 0, "emi": 0,
     "score": 700, "employment": "salaried", "loans": 0},
    {"name": "Vijay", "age": 40, "income": 70000, "emi": 15000,
     "score": 850, "employment": "salaried", "loans": 1},
    {"name": "Divya", "age": 26, "income": 40000, "emi": 8000,
     "score": 630, "employment": "self-employed", "loans": 2}
]

approval_limit: int = 3
approved_count: int = 0

print(f"{'Name':<10}{'Decision':<15}{'Rate':<10}{'Product'}")
print("-" * 55)

for applicant in applicants:

    name: str = applicant["name"]
    age: int = applicant["age"]
    income: int = applicant["income"]
    emi: int = applicant["emi"]
    score: int = applicant["score"]
    employment: str = applicant["employment"]
    loans: int = applicant["loans"]

    # Invalid record handling
    if age < 0 or score < 0 or score > 900 or income < 0 or emi < 0:
        print(f"{name:<10}{'Invalid':<15}{'-':<10}{'Invalid record'}")
        continue

    if income == 0:
        print(f"{name:<10}{'Rejected':<15}{'-':<10}{'Zero income'}")
        continue

    # Age eligibility
    if age < 21 or age > 60:
        decision: str = "Rejected"
        reason: str = "Age not eligible"

    # Income-to-EMI ratio
    elif emi / income > 0.50:
        decision = "Rejected"
        reason = "EMI ratio too high"

    # Credit score
    elif score < 600:
        decision = "Rejected"
        reason = "Low credit score"

    # Employment type
    elif employment not in ("salaried", "self-employed"):
        decision = "Rejected"
        reason = "Invalid employment"

    # Existing loan limit
    elif loans > 3:
        decision = "Rejected"
        reason = "Too many loans"

    else:
        # Nested conditions
        if score >= 750:
            credit_band: str = "Excellent"
        elif score >= 700:
            credit_band = "Good"
        elif score >= 650:
            credit_band = "Average"
        else:
            credit_band = "Low"

        # match/case
        match credit_band:
            case "Excellent":
                rate: float = 8.0
                product: str = "Premium Loan"
            case "Good":
                rate = 9.5
                product = "Standard Loan"
            case "Average":
                rate = 11.0
                product = "Basic Loan"
            case _:
                rate = 13.0
                product = "Restricted Loan"

        decision = "Approved"
        reason = f"{product}, {rate}%"

    if decision == "Approved":
        approved_count += 1

    print(f"{name:<10}{decision:<15}{rate if decision == 'Approved' else '-':<10}{reason}")

    # Daily approval limit
    if approved_count >= approval_limit:
        print(f"\nDaily approval limit of {approval_limit} reached.")
        break

else:
    print("\nAll applicants processed successfully.")

print(f"\nTotal approvals: {approved_count}")
