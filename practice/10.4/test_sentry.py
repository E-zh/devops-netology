#!/usr/bin/env python3
import sentry_sdk

sentry_sdk.init(
    dsn="https://5e3eb65cdc7849ce9c1aae676d32390b@o4504955573698560.ingest.sentry.io/4504955577434112",

    # Set traces_sample_rate to 1.0 to capture 100%
    # of transactions for performance monitoring.
    # We recommend adjusting this value in production.
    traces_sample_rate=1.0
)

num1 = int(input("Введите любое целое число: "))
num2 = int(input("Введите еще одно число (для проверки Sentry введите ноль): "))

if num2 == 0:
    division_by_zero = num1 / 0
else:
    print(num1 / num2)
