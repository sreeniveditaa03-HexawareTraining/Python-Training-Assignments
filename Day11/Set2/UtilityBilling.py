# SET 2 – UTILITY BILLING CALCULATOR

from typing import Any

# Electricity slab rates
def calculate_bill(units: float) -> float:

    if units < 0:
        return -1

    if units <= 100:
        bill: float = units * 2.50

    elif units <= 200:
        bill = 100 * 2.50 + (units - 100) * 4.00

    elif units <= 400:
        bill = 100 * 2.50 + 100 * 4.00 + (units - 200) * 5.50

    else:
        bill = (100 * 2.50 + 100 * 4.00
                + 200 * 5.50 + (units - 400) * 7.00)

    return bill


# Consumer category fixed charge
def get_fixed_charge(category: str) -> float:

    match category.lower():
        case "domestic":
            return 50.0
        case "commercial":
            return 100.0
        case "industrial":
            return 250.0
        case _:
            return -1.0


# Calculate final bill
def final_bill(units: float, category: str,
               late: bool, online: bool) -> float:

    energy_charge: float = calculate_bill(units)
    fixed_charge: float = get_fixed_charge(category)

    if energy_charge < 0 or fixed_charge < 0:
        return -1.0

    total: float = energy_charge + fixed_charge

    # Operator precedence: multiplication happens before addition.
    # Late surcharge is calculated as 5% of the bill.
    if late:
        total = total + total * 0.05

    # Online rebate is 2% of the bill after surcharge.
    if online:
        total = total - total * 0.02

    return total


# 12-month consumption statement
consumption: list[float] = [
    100, 120, 150, 180, 200, 220,
    250, 300, 350, 400, 450, 500
]

print("12-MONTH CONSUMPTION STATEMENT")
print("-" * 35)

for month, units in enumerate(consumption, start=1):
    print(f"Month {month:<2} : {units:>7.2f} units")


# Interactive readings
print("\nUTILITY BILLING CALCULATOR")
print("Enter units or q to quit.")

while True:

    reading: str = input("\nEnter consumption units: ")

    if reading.lower() == "q":
        print("Billing session ended.")
        break

    try:
        units: float = float(reading)

        if units < 0:
            print("Invalid reading: units cannot be negative.")
            continue

        category: str = input(
            "Enter category (domestic/commercial/industrial): "
        )

        late_input: str = input("Late payment? (yes/no): ")
        online_input: str = input("Online payment? (yes/no): ")

        late: bool = late_input.lower() == "yes"
        online: bool = online_input.lower() == "yes"

        amount: float = final_bill(units, category, late, online)

        if amount < 0:
            print("Invalid consumer category.")
            continue

        print("\n" + "=" * 40)
        print(f"{'Units Consumed':<22}: {units:>10.2f}")
        print(f"{'Consumer Category':<22}: {category:>10}")
        print(f"{'Total Bill':<22}: ₹{amount:>10.2f}")
        print("=" * 40)

    except ValueError:
        print("Invalid input! Enter a numeric reading.")
