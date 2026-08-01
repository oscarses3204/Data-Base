# Two-Pass External Merge Sort

Let **B** be the size of a file in pages. How many memory pages **M** do you need to sort the file using one sorting pass and one merge pass (i.e., 2 passes total)?

---

## Pass 0 — Sorting Pass ("Storing Pass")

- You have **M** buffer pages in memory.
- You read the file in chunks of **M** pages, sort each chunk in memory (using an internal sort algorithm), and write each sorted chunk back to disk as a **sorted run**.
- Each sorted run is **M** pages long (except possibly the last one).

$$
\text{Number of sorted runs} = \lceil B / M \rceil
$$

## Pass 1 — Merge Pass

- Now you must merge all sorted runs into a single sorted output **in one pass**.
- To merge *N* runs simultaneously, you need **1 input buffer page per run** plus **1 output buffer page**.
- So with M pages of memory, you can merge at most **M − 1** runs.

$$
\lceil B / M \rceil \leq M - 1
$$

## Solving for M

Assuming B is large enough, drop the ceiling for an approximate bound:

$$
\frac{B}{M} \leq M - 1
$$

$$
B \leq M(M - 1)
$$

$$
B \leq M^2 - M
$$

$$
M^2 - M - B \geq 0
$$

Using the quadratic formula:

$$
M \geq \frac{1 + \sqrt{1 + 4B}}{2}
$$

## Approximate Form

For large files where $B \gg 1$:

$$
\boxed{M \approx \sqrt{B}}
$$

## Example

If $B = 10{,}000$ pages, then $M \approx \sqrt{10{,}000} = 100$ pages.

Checking: with $M = 100$, you create $\lceil 10000/100 \rceil = 100$ runs, and you can merge $M - 1 = 99$ runs — just barely short. You'd need $M = 101$ to comfortably merge all 100 runs in one pass.

## Summary

$$
\boxed{M \approx \sqrt{B} \quad \text{or more precisely} \quad M \geq \left\lceil \frac{1 + \sqrt{1 + 4B}}{2} \right\rceil}
$$

**Key insight:** The number of runs $B/M$ must not exceed the merge capacity $M - 1$, giving the quadratic relationship. In practice, $M \approx \sqrt{B}$ memory pages are needed to sort a file of B pages in just 2 passes.
