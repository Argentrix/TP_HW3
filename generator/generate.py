import csv
import random
import os
import sys

NUM_ROWS = 100


COLUMNS = ["product_id", "price", "stock_quantity", "delivery_type"]

def generate_row():

    return {
        "product_id": random.randint(1000, 9999),
        "price": round(random.uniform(49.0, 899.0), 2),
        "stock_quantity": random.randint(0, 150),
        "delivery_type": random.choice(["Fast", "SuperFast", "Regular"]),
    }

OUTPUT_DIR = sys.argv[1] if len(sys.argv) > 1 else "/data"
OUTPUT_FILE = os.path.join(OUTPUT_DIR, "data.csv")

os.makedirs(OUTPUT_DIR, exist_ok=True)

rows = [generate_row() for _ in range(NUM_ROWS)]

with open(OUTPUT_FILE, "w", newline="", encoding="utf-8") as f:
    writer = csv.DictWriter(f, fieldnames=COLUMNS)
    writer.writeheader()
    writer.writerows(rows)
