import os
import sys

def add_numbers(a, b):
  return a + b

def greet_user(name):
  print(f"Hello, {name}! Welcome to the Noisecut test suite.")

if __name__ == "__main__":
  x = 10
  y = 20
  sum_result = add_numbers(x, y)
  print(f"The calculation result: {x} + {y} = {sum_result}")
  user_name = "Developer"
  greet_user(user_name)
