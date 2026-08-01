# COMP 3311 — Lecture 18 Exercises: B+-tree Index and Hash Index

## Exercise 5: B+-tree with Bulk Loading

**Given:**
- 1,000,000 records, each **25 bytes**
- Primary key: **4 bytes**
- All pointers: **4 bytes**
- Page size: **128 bytes**
- Bulk loading with **minimum occupancy** where possible

---

### (a) Blocking factor of the data file

The blocking factor is the number of records that fit in one page:

$$\text{bf}_{\text{dataFile}} = \left\lfloor \frac{\text{page size}}{\text{record size}} \right\rfloor = \left\lfloor \frac{128}{25} \right\rfloor = \lfloor 5.12 \rfloor = \mathbf{5}$$

---

### (b) Number of pages needed for the data file

$$B_{\text{dataFile}} = \left\lceil \frac{\text{number of records}}{\text{bfr}} \right\rceil = \left\lceil \frac{1{,}000{,}000}{5} \right\rceil = \mathbf{200{,}000}$$

---

### (c) Maximum number of values in each page of the B+-tree index

**Leaf node** — contains $(n-1)$ key–pointer pairs (4 + 4 = 8 bytes each) plus 1 next-leaf pointer (4 bytes):

$$(n-1) \times 8 + 4 \leq 128$$
$$8(n-1) \leq 124$$
$$n-1 \leq 15.5 \quad\Rightarrow\quad n-1 = 15$$

Maximum values in a leaf page = **15**

**Internal node** — contains $n$ tree pointers (4 bytes each) plus $(n-1)$ keys (4 bytes each):

$$n \times 4 + (n-1) \times 4 \leq 128$$
$$8n - 4 \leq 128$$
$$8n \leq 132 \quad\Rightarrow\quad n \leq 16.5$$

Maximum values (keys) in an internal page = $n-1 =$ **15**

---

### (d) Fan-out $n$ of the B+-tree

From part (c), the maximum number of pointers per node:

$$n = \mathbf{16}$$

(This is the same for both internal and leaf nodes.)

---

### (e) Minimum occupancy for internal pages (bulk loading)

Under bulk loading with minimum fill, each internal node holds $\lceil n/2 \rceil$ pointers:

$$\text{Minimum pointers} = \lceil 16/2 \rceil = 8$$

$$\text{Minimum key values} = 8 - 1 = \mathbf{7}$$

---

### (f) Minimum occupancy for leaf pages (bulk loading)

For leaf nodes, minimum fill is $\lceil (n-1)/2 \rceil$ entries:

$$\text{Minimum entries} = \lceil 15/2 \rceil = \mathbf{8}$$

Each leaf node contains at least 8 key–pointer pairs.

---

### (g) Height of the B+-tree and pages at each level

With minimum occupancy during bulk loading:

- Each **leaf** holds **8** entries
- Each **internal** node points to **8** children

Building bottom-up from the leaf level:

| Level | Description | Pages | Calculation |
|:-----:|-------------|------:|-------------|
| 0 | Root | **1** | $4 \leq 8$, so a single root suffices |
| 1 | Internal | **4** | $\lceil 31 / 8 \rceil$ |
| 2 | Internal | **31** | $\lceil 245 / 8 \rceil$ |
| 3 | Internal | **245** | $\lceil 1{,}954 / 8 \rceil$ |
| 4 | Internal | **1,954** | $\lceil 15{,}625 / 8 \rceil$ |
| 5 | Internal | **15,625** | $\lceil 125{,}000 / 8 \rceil$ |
| 6 | **Leaf** | **125,000** | $\lceil 1{,}000{,}000 / 8 \rceil$ |

**Height = 7 levels** (levels 0–6, i.e., 6 edges from root to leaf).

Total index pages:

$$1 + 4 + 31 + 245 + 1{,}954 + 15{,}625 + 125{,}000 = \mathbf{142{,}860}$$

---

## Exercise 6: Hash Index Page I/O Cost

**Given:**
- Customer file hashed on `customerId` (records physically scattered by `customerId`)
- Secondary hash index on `country` (one index entry per country)
- 12,000 customers per country on average
- 120 countries
- A page holds **120 record pointers**

---

### Step 1 — Read the hash-index bucket

The secondary hash index maps each country to a bucket of record pointers. For a country with 12,000 customers, the bucket must hold all 12,000 record pointers.

Pages needed for one country's bucket:

$$\left\lceil \frac{12{,}000}{120} \right\rceil = 100 \text{ pages}$$

→ **100 page I/Os** to read all the pointer pages for that country.

---

### Step 2 — Access the actual data records

The data file is hashed on `customerId`, **not** on `country`. The 12,000 customers of a given country are therefore **randomly scattered** across the data file — no physical clustering by country exists.

In the worst case, each of the 12,000 record pointers references a record on a different data page, requiring one page I/O per record.

→ **12,000 page I/Os** to fetch the actual customer records.

---

### Total page I/O cost

$$100 \text{ (index bucket)} \;+\; 12{,}000 \text{ (data records)} = \mathbf{12{,}100 \text{ page I/Os}}$$

---

### Why so many?

| What the index saves you | What the index cannot save you |
|---|---|
| Avoids a full scan of the **entire** data file to find customers of one country | Cannot cluster the matching records physically — the data file is hashed on `customerId`, not `country` |
| 100 index pages replace scanning the whole hash directory | Each qualifying record still requires one random page I/O |

This illustrates the key limitation of a **secondary index on a non-clustering attribute**: it pinpoints *which* records to fetch, but if those records are physically scattered, you still pay one I/O per record. The index is excellent for fetching a single record or a handful, but expensive for retrieving thousands of records that share the same non-clustering attribute value.
