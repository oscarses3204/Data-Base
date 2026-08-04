# SQL & MQL Functions – Complete Reference

## Table of Contents
1. [Oracle SQL Functions](#oracle-sql-functions)
   - [String Functions](#string-functions)
   - [Numeric Functions](#numeric-functions)
   - [Date Functions](#date-functions)
   - [Conversion Functions](#conversion-functions)
   - [Aggregate Functions](#aggregate-functions)
   - [Window Functions](#window-functions)
   - [Conditional Functions](#conditional-functions)
2. [MongoDB MQL Functions](#mongodb-mql-functions)
   - [Basic Query Methods](#basic-query-methods)
   - [Update Operators](#update-operators)
   - [Aggregation Stage Operators](#aggregation-stage-operators)
   - [Aggregation Accumulators](#aggregation-accumulators)
   - [Comparison Operators](#comparison-operators)
   - [Boolean Operators](#boolean-operators)
   - [Array Operators](#array-operators)
   - [String Operators](#string-operators)
   - [Arithmetic Operators](#arithmetic-operators)
   - [Conditional Operators](#conditional-operators)
   - [Set Operators](#set-operators)
   - [Date Operators](#date-operators)
   - [System Variables](#system-variables)

---

# Oracle SQL Functions

## String Functions

| Function                         | Purpose                                                         | Example                                             |
|----------------------------------|-----------------------------------------------------------------|-----------------------------------------------------|
| `lower(string)`                  | Converts string to lowercase                                    | `select lower(lastName) from Student;`             |
| `upper(string)`                  | Converts string to uppercase                                    | `select upper(lastName) from Student;`             |
| `initcap(string)`                | Capitalises first letter of each word                           | `select initcap(courseName) from Course;`          |
| `substr(string, pos, length)`    | Returns substring from position                                 | `select substr('Hello', 2, 3) from dual;`          |
| `concat(string1, string2)`       | Concatenates two strings                                        | `select concat('Hello', ' World') from dual;`      |
| `instr(string1, string2)`        | Returns position of string2 in string1                          | `select instr('Hello World', 'World') from dual;`  |
| `length(string)`                 | Returns length of string                                        | `select length(lastName) from Student;`            |
| `lpad(string1, length, string2)` | Left-pads string1 with string2 to given length                  | `select lpad('a', 10, 'b') from dual;`             |
| `rpad(string1, length, string2)` | Right-pads string1 with string2 to given length                 | `select rpad('a', 10, 'b') from dual;`             |
| `ltrim(string)`                  | Removes leading spaces                                          | `select ltrim(' a ') from dual;`                   |
| `rtrim(string)`                  | Removes trailing spaces                                         | `select rtrim(' a ') from dual;`                   |
| `regexp_like(attr, pattern, opt)`| Matches regular expression (e.g., `i` for case‑insensitive)    | `regexp_like(lastName, '([aeiou])\\1', 'i')`       |

## Numeric Functions

| Function                   | Purpose                                     | Example                           |
|----------------------------|---------------------------------------------|-----------------------------------|
| `abs(number)`              | Absolute value                              | `select abs(-5) from dual;`      |
| `ceil(number)`             | Smallest integer ≥ number                   | `select ceil(3.14) from dual;`   |
| `floor(number)`            | Largest integer ≤ number                    | `select floor(3.14) from dual;`  |
| `mod(number1, number2)`    | Remainder (modulo)                          | `select mod(10, 3) from dual;`   |
| `power(number1, number2)`  | Raises number1 to number2                   | `select power(2, 3) from dual;`  |
| `round(number1, number2)`  | Rounds to number2 decimal places            | `select round(3.14159, 2) from dual;` |
| `trunc(number1, number2)`  | Truncates to number2 decimal places         | `select trunc(3.14159, 2) from dual;` |

## Date Functions

| Function                         | Purpose                                    | Example                                                      |
|----------------------------------|--------------------------------------------|--------------------------------------------------------------|
| `add_months(date, number)`       | Adds months to date                        | `select add_months(sysdate, 3) from dual;`                  |
| `next_day(date, weekday)`        | Returns next occurrence of weekday         | `select next_day(sysdate, 'MONDAY') from dual;`             |
| `last_day(date)`                 | Returns last day of the month              | `select last_day(sysdate) from dual;`                       |
| `current_date` / `sysdate`       | Returns current date/time                  | `select current_date from dual;`                            |
| `months_between(date1, date2)`   | Months between two dates                   | `select months_between(sysdate, '01-JAN-24') from dual;`    |
| `new_time(date, zone1, zone2)`   | Converts time zone                         | `select new_time(sysdate, 'EST', 'PST') from dual;`         |
| `to_date(string, format)`        | Converts string to date                    | `select to_date('20 MAR 2026', 'dd mm yyyy') from dual;`    |
| `to_char(date, format_mask)`     | Converts date to formatted string          | `select to_char(sysdate, 'yyyy-mm-dd') from dual;`          |

## Conversion Functions

| Function                            | Purpose                                     | Example                                               |
|-------------------------------------|---------------------------------------------|-------------------------------------------------------|
| `to_char(date, format_mask)`        | Date to string                              | `select to_char(sysdate, 'MM/DD/YYYY') from dual;`   |
| `to_date(string, date_format)`      | String to date                              | `select to_date('20 MAR 2026', 'dd mm yyyy') from dual;`|
| `to_number(string, format)`         | String to number                            | `select to_number('123.45', '999.99') from dual;`    |
| `coalesce(arg1, arg2, …)`           | First non‑null argument                     | `select coalesce(cga, 0) from Student;`              |
| `nvl(arg1, arg2)`                   | Returns arg2 if arg1 is null                | `select nvl(cga, 0) from Student;`                   |
| `decode(expr, search1, result1, …)` | Case‑like conditional                       | `select decode(unitId,'COMP','CS','MATH','MA','Other') from Student;` |

## Aggregate Functions

> All aggregate functions ignore `NULL` except `count(*)`.

| Function          | Purpose                     | Example                                   |
|-------------------|-----------------------------|-------------------------------------------|
| `avg(attr)`       | Average of values           | `select avg(cga) from Student;`          |
| `count(attr)`     | Number of non‑null values   | `select count(studentId) from Student;`  |
| `max(attr)`       | Maximum value               | `select max(cga) from Student;`          |
| `min(attr)`       | Minimum value               | `select min(cga) from Student;`          |
| `stddev(attr)`    | Sample standard deviation   | `select stddev(cga) from Student;`       |
| `sum(attr)`       | Sum of values               | `select sum(cga) from Student;`          |

## Window Functions

### Aggregate Window Functions

| Function                                    | Purpose                             |
|---------------------------------------------|-------------------------------------|
| `avg(expression) OVER (window)`             | Average per partition/window        |
| `count(*) OVER (window)`                    | Count per partition                 |
| `max(expression) OVER (window)`             | Maximum per partition               |
| `min(expression) OVER (window)`             | Minimum per partition               |
| `sum(expression) OVER (window)`             | Sum per partition                   |

### Value Functions

| Function                                                | Purpose                                         |
|---------------------------------------------------------|-------------------------------------------------|
| `first_value(expression) OVER (window)`                 | Value of first row in window frame              |
| `last_value(expression) OVER (window)`                  | Value of last row in window frame               |
| `lag(expression, offset, default) OVER (window)`        | Row n rows before current                       |
| `lead(expression, offset, default) OVER (window)`       | Row n rows after current                        |
| `nth_value(expression, n) OVER (window)`                | Value of nth row in window frame                |

### Ranking Functions

| Function                          | Purpose                                             |
|-----------------------------------|-----------------------------------------------------|
| `row_number() OVER (window)`      | Sequential row number (1‑based)                     |
| `rank() OVER (window)`            | Rank with gaps for ties                             |
| `dense_rank() OVER (window)`      | Rank without gaps                                   |
| `ntile(n) OVER (window)`          | Divides into n buckets                              |
| `percent_rank() OVER (window)`    | Percentile rank in [0,1]                            |
| `cume_dist() OVER (window)`       | Cumulative distribution                             |

### Window Clause Syntax

```sql
<window_function> OVER (
    PARTITION BY column1, column2, ...
    ORDER BY column1 [ASC|DESC], ...
)