# COMP 3311: Database Management Systems — Tutorial 10 Solutions

> **Tutorial 10: Query Processing**
> **Based on:** COMP3311 Lecture Summary Part 4 (Lectures 16–23)

---

## Exercise 1 — Pipelined Plan

### Given Relations

| Relation | Attributes | Tuples | Pages | B+-tree Clustering Index (4 levels) |
|----------|-----------|--------|-------|--------------------------------------|
| Student | (studentId, sName, gender) | 1,000 | 100 | studentId |
| EnrollsIn | (studentId, courseId, year) | 6,000 | 600 | courseId |
| Course | (courseId, cName, area, credit) | 200 | 40 | area |

- 10 different areas, 20 tuples per area
- All FKs are NOT NULL
- All indexes: B+-tree clustering, HTi = 4
- bfr(Course) = 200/40 = 5 tuples/page
- bfr(EnrollsIn) = 6,000/600 = 10 tuples/page
- bfr(Student) = 1,000/100 = 10 tuples/page

### Query

```sql
SELECT sName
FROM Student S, EnrollsIn E, Course C
WHERE S.studentId = E.studentId
  AND C.courseId = E.courseId
  AND area = 'DB';
```

### Execution Plan (Pipelined, Bottom-Up)

```
                     π sName (on-the-fly)
                          |
              ⋈ S.studentId = E.studentId
              (B+-tree index on S.studentId)
             /                            \
        Student                     ⋈ C.courseId = E.courseId
                                    (B+-tree index on E.courseId)
                                   /                            \
                              EnrollsIn                   σ area='DB'
                                                         (B+-tree index on area)
                                                                |
                                                              Course
```

**Execution order:**
1. **Step 1:** `σ area='DB'(Course)` → result A (pipelined, ~20 tuples)
2. **Step 2:** `result A ⋈ EnrollsIn` on courseId → result B (pipelined, ~600 tuples)
3. **Step 3:** `result B ⋈ Student` on studentId → π sName (on-the-fly)

---

### (a) Estimate the Query Result Size

| Step | Computation | Result |
|------|-------------|--------|
| `σ area='DB'(Course)` | 200 ÷ 10 areas = 20 | **20 tuples** |
| Join with EnrollsIn | 20 courses × (6,000 ÷ 200) = 20 × 30 | **600 tuples** |
| Join with Student | Each tuple has valid FK studentId → exact match with Student PK | **600 tuples** |

> **Answer: 600 tuples**

---

### (b) Estimated Page I/O Cost (Pipelined)

---

#### Step 1: `σ area='DB'(Course)` → result A

**Strategy:** Index lookup using B+-tree clustering index on `area`

- Traverse B+-tree from root to leaf: **HTi = 4** index page I/Os
- Read matching data pages: 20 tuples ÷ 5 tuples/page = **4 data page I/Os**
- No write needed (result is pipelined to Step 2)

> **Step 1 page I/O cost: `8`**

---

#### Step 2: `result A ⋈ EnrollsIn` → result B

**Strategy:** Indexed nested-loop join using B+-tree clustering index on `E.courseId`

- **Outer relation:** result A (20 tuples, pipelined from Step 1 — no extra read cost)
- **Inner relation:** EnrollsIn, probed via B+-tree on courseId (clustering, HTi = 4)
- For each of the 20 courseIds:
  - Index traversal: **4** index page I/Os
  - Matching EnrollsIn tuples: 30 tuples ÷ 10 tuples/page = **3 data page I/Os**
  - **Per-tuple cost (c) = 4 + 3 = 7**
- Total: 20 × 7 = 140

> **Step 2 page I/O cost: `140`**

---

#### Step 3: `result B ⋈ Student` → π sName

**Strategy:** Indexed nested-loop join using B+-tree clustering index on `S.studentId`

- **Outer relation:** result B (600 tuples, pipelined from Step 2 — no extra read cost)
- **Inner relation:** Student, probed via B+-tree on studentId (clustering, HTi = 4)
- For each of the 600 tuples:
  - Index traversal: **4** index page I/Os
  - Matching Student tuple: candidate key → exactly 1 tuple = **1 data page I/O**
  - **Per-tuple cost (c) = 4 + 1 = 5**
- Total: 600 × 5 = 3,000

> **Step 3 page I/O cost: `3,000`**

---

### Query Processing Total (Exercise 1)

| Step | Page I/O Cost |
|------|---------------|
| Step 1: σ area='DB'(Course) | 8 |
| Step 2: result A ⋈ EnrollsIn | 140 |
| Step 3: result B ⋈ Student | 3,000 |
| **Total** | **3,148** |

---

## Exercise 2 — Block Nested-Loop Join + External Sort Projection

### Given

| Parameter | Value |
|-----------|-------|
| Page size | 1,024 bytes |
| Buffer size M | 3 pages |
| R | 10 pages, 300 bytes/tuple |
| S | 100 pages, 500 bytes/tuple |
| Join result (A,B,C,D) | 450 bytes/tuple |
| A is a key for R | True |
| Each S tuple joins with exactly 1 R tuple | True |

**Derived values:**
- `bfr_R = ⌊1024/300⌋ = 3` → |R| = 10 × 3 = **30 tuples**
- `bfr_S = ⌊1024/500⌋ = 2` → |S| = 100 × 2 = **200 tuples**
- Join result: **200 tuples** (one per S tuple)
- `bfr_join = ⌊1024/450⌋ = 2` → join result = **⌈200/2⌉ = 100 pages**

### (a) Join Cost

**Strategy:** Optimized block nested-loop join, eliminating unwanted attributes during the join

- **Outer:** R (smaller relation, 10 pages)
- M = 3 → M − 2 = **1 page available for outer block**
- Scan inner relation S for each outer block

```
Join cost = ⌈B_R / (M−2)⌉ × B_S + B_R
         = ⌈10 / 1⌉ × 100 + 10
         = 10 × 100 + 10
         = 1,010
```

| Item | Page I/O Cost |
|------|--------------|
| **Join page I/O cost** | **1,010** |
| **Write join result page I/O cost** | **100** |

---

### (b) Projection Cost

**Strategy:** External sorting (eliminate unwanted attributes during initial sort, remove duplicates on-the-fly during merge passes)

- Input: B = 100 pages (join result)
- M = 3 buffer pages

**Pass 0 (Create sorted runs):**
- `Number of runs = ⌈B/M⌉ = ⌈100/3⌉ = 34 runs`
- I/O: read 100 + write 100 = **200**

**Merge passes:**
- Fan-in = M − 1 = 2 (2-way merge)
- `Number of merge passes = ⌈log₂(34)⌉ = 6`
- Each pass: read 100 + write 100 = 200
- Total merge I/O: 6 × 200 = **1,200**

> Note: Since A is a key for R and each S tuple joins with exactly 1 R tuple, no duplicates exist — duplicate elimination does not reduce size.

| Item | Page I/O Cost |
|------|--------------|
| **Sort page I/O cost pass 0** | **200** |
| **Merge page I/O cost** | **1,200** |

---

### Query Processing Total (Exercise 2)

| Step | Page I/O Cost |
|------|---------------|
| Join | 1,010 |
| Write join result | 100 |
| Sort pass 0 | 200 |
| Merge passes (×6) | 1,200 |
| **Total** | **2,510** |

---

## Exercise 3 — Materialized Plan with Merge Joins

### Given

- M = **22 buffer pages**
- Intermediate results M1 = `σ area='DB'(Course)` and M2 = `M1 ⋈ EnrollsIn` are **materialized**
- All joins use **merge join**
- Attributes in the same relation all have the same size
- Page size = 1,024 bytes (inferred from bfr values)

### Attribute Size Estimation

| Relation | Attributes | bfr | Tuple Size | Per-Attribute Size |
|----------|-----------|-----|-----------|-------------------|
| Course | 4 | 5 | ≈ 205 bytes | ≈ 51 bytes |
| EnrollsIn | 3 | 10 | ≈ 102 bytes | ≈ 34 bytes |
| Student | 3 | 10 | ≈ 102 bytes | ≈ 34 bytes |

### Execution Plan

```
                     π sName (on-the-fly)
                          |
              merge join S.studentId = E.studentId
             /                                    \
        Student                            merge join M2
                                          C.courseId = E.courseId
                                         /                    \
                                  M1 = σ area='DB'       EnrollsIn
                                  (B+-tree on area)
                                         |
                                       Course
```

---

### Step 1: Materialize `M1 = σ area='DB'(Course)`

**Strategy:** Index lookup using B+-tree clustering index on `area`, then sort by courseId for merge join

- Read via B+-tree: **4** (index traversal) + **4** (data: 20 tuples ÷ 5/page) = **8 reads**
- M1 fits in memory (4 pages << M=22) → sort by courseId in memory (0 I/O)
- Write M1 to disk (sorted by courseId): **4 writes**

> **Step 1 page I/O cost to materialize M1: `12`**

---

### Step 2: Materialize `M2 = M1 ⋈ courseId EnrollsIn`

**Strategy:** Merge join

- **M1:** 4 pages, sorted by courseId (from Step 1) ✓
- **EnrollsIn:** 600 pages, physically sorted by courseId (clustering B+-tree index) ✓

**M2 size estimation:**
- M2 tuple = Course tuple (4 attrs) + EnrollsIn tuple (3 attrs) − shared courseId attr
  - ≈ 205 + 102 − 51 = **256 bytes**
- `bfr_M2 = ⌊1024/256⌋ = 3 tuples/page`
- M2 tuples = 600 → `⌈600/3⌉ = 200 pages`

**Merge join I/O:**
- Read M1: 4
- Read EnrollsIn: 600
- Write M2 (output in courseId order): 200

> **Step 2 page I/O cost to materialize M2: `804`**

---

### Step 3: Compute `M2 ⋈ studentId Student`

**Strategy:** Merge join — M2 must first be sorted by studentId

**M2 is sorted by courseId** (merge join output), **but needs to be sorted by studentId** for the next merge join.

**Sort M2 (200 pages, M = 22):**

| Phase | Computation | I/O |
|-------|------------|-----|
| Pass 0 | `⌈200/22⌉ = 10 runs` | read 200 + write 200 = **400** |
| Merge | `⌈log₂₁(10)⌉ = 1 pass` | read 200 + write 200 = **400** |
| **Total sort** | | **800** |

**Merge join (both sorted by studentId):**
- Read sorted M2: 200 (or pipelined from sort — counted above)
- Read Student: 100 (sorted by studentId — clustering B+-tree index) ✓
- Merge join read: **300**

> **Step 3 page I/O cost: `800 + 300 = 1,100`**

---

### Query Processing Total (Exercise 3)

| Step | Description | Page I/O Cost |
|------|-------------|---------------|
| Step 1 | Materialize M1 = σ area='DB'(Course) | 12 |
| Step 2 | Materialize M2 = M1 ⋈ EnrollsIn (merge join) | 804 |
| Step 3 | Sort M2 + merge join M2 ⋈ Student | 1,100 |
| **Total** | | **1,916** |

---

## Final Answer Summary

| Exercise | Item | Answer |
|----------|------|--------|
| **1(a)** | Query result size | **600 tuples** |
| **1(b)** | Step 1 I/O | **8** |
| | Step 2 I/O | **140** |
| | Step 3 I/O | **3,000** |
| | **Total** | **3,148** |
| **2(a)** | Join page I/O | **1,010** |
| | Write join result | **100** |
| **2(b)** | Sort pass 0 | **200** |
| | Merge I/O | **1,200** |
| | **Total** | **2,510** |
| **3** | Step 1 (materialize M1) | **12** |
| | Step 2 (materialize M2) | **804** |
| | Step 3 (M2 ⋈ Student) | **1,100** |
| | **Total** | **1,916** |
