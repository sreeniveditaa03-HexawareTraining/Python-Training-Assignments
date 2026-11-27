# SET 3 – INSURANCE PREMIUM BANDS

from typing import Any

# Eight applicants
applicants: list[dict[str, Any]] = [
    {"name": "Arun", "age": 25, "weight": 65, "height": 1.70,
     "smoker": False, "term": 10},
    {"name": "Priya", "age": 35, "weight": 80, "height": 1.65,
     "smoker": True, "term": 20},
    {"name": "Kumar", "age": 45, "weight": 70, "height": 1.75,
     "smoker": False, "term": 15},
    {"name": "Meena", "age": 55, "weight": 90, "height": 1.60,
     "smoker": True, "term": 10},
    {"name": "Ravi", "age": 30, "weight": 50, "height": 1.70,
     "smoker": False, "term": 20},
    {"name": "Sara", "age": 40, "weight": 85, "height": 1.68,
     "smoker": False, "term": 15},
    {"name": "John", "age": 65, "weight": 75, "height": 1.72,
     "smoker": True, "term": 10},
    {"name": "Divya", "age": 28, "weight": 55, "height": 1.60,
     "smoker": False, "term": 20}
]

print("INSURANCE PREMIUM CALCULATOR")
print("-" * 75)

for applicant in applicants:

    name: str = applicant["name"]
    age: int = applicant["age"]
    weight: float = applicant["weight"]
    height: float = applicant["height"]
    smoker: bool = applicant["smoker"]
    term: int = applicant["term"]

    # BMI calculation
    bmi: float = weight / (height ** 2)

    # BMI classification and loading
    if bmi < 18.5:
        category: str = "Underweight"
        loading: float = 0.05

    elif bmi < 25:
        category = "Normal"
        loading = 0.00

    elif bmi < 30:
        category = "Overweight"
        loading = 0.10

    else:
        category = "Obese"
        loading = 0.20

    # Base premium based on age and term
    match age:
        case age if age <= 30:
            base_premium: float = 5000
        case age if age <= 40:
            base_premium = 7000
        case age if age <= 50:
            base_premium = 10000
        case age if age <= 60:
            base_premium = 15000
        case _:
            base_premium = 20000

    # Policy term loading
    if term == 10:
        term_loading: float = 0.05
    elif term == 15:
        term_loading = 0.10
    elif term == 20:
        term_loading = 0.15
    else:
        term_loading = 0.0

    # Smoker loading
    smoker_loading: float = 0.25 if smoker else 0.0

    # Logical and arithmetic operators
    # Multiplication is evaluated before addition.
    # Total loading combines BMI, smoker and term loadings.
    total_loading: float = loading + smoker_loading + term_loading

    # Eligibility
    if age < 18 or age > 65 or term <= 0:
        decision: str = "Ineligible"
        premium: float = 0.0

    else:
        premium = base_premium * (1 + total_loading)
        decision = "Eligible"

    print(f"Name          : {name}")
    print(f"Age           : {age}")
    print(f"BMI           : {bmi:.2f}")
    print(f"BMI Category  : {category}")
    print(f"Smoker        : {smoker}")
    print(f"Policy Term    : {term} years")
    print(f"Base Premium  : ₹{base_premium:.2f}")
    print(f"Total Loading : {total_loading:.2%}")
    print(f"Final Premium : ₹{premium:.2f}")
    print(f"Decision      : {decision}")
    print("-" * 75)


# Batch validation mode
print("\nBATCH VALIDATION")
print("-" * 30)

batch_valid: bool = True

for applicant in applicants:

    age: int = applicant["age"]
    height: float = applicant["height"]
    term: int = applicant["term"]

    if age < 18 or age > 65 or height <= 0 or term <= 0:
        print(f"Invalid applicant: {applicant['name']}")
        batch_valid = False
        break

else:
    print("All eight applicants are valid.")


# Type conversion error handling
print("\nINPUT VALIDATION")

try:
    age_input: str = input("Enter age: ")
    age_value: int = int(age_input)

    if age_value < 0:
        print("Age cannot be negative.")
    else:
        print(f"Entered age: {age_value}")

except ValueError:
    print("Conversion error: input must be a valid integer.")

print("Program completed.")
