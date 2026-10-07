<!--
  Copyright (C) 2026 Prime Materia Commons / Foundry F1 contributors
  SPDX-License-Identifier: AGPL-3.0-only
-->

# sedona-k

**Layer-1 constants of the Sedona Spine, read as a classical Riemann gas over the first sixty-four primes, computed in ngn/k.**

---

## Abstract

The lowest arithmetic layer of the Foundry F1 stack publishes two objects: the Goldilocks prime $p = 2^{64} - 2^{32} + 1$, and a canonical list $P_{64}$ of the first sixty-four primes. The prime list is used upstream as a set of grading coordinates. This repository asks what that same list looks like through the lens of statistical mechanics.

The answer is the *Riemann gas* (also called the primon gas): a system of independent bosonic modes, one per prime, in which the mode attached to $p$ has energy $\ln p$. At inverse temperature $s$ its partition function is the Euler product for the Riemann zeta function. Truncated to $P_{64}$, it becomes a finite product that can be evaluated exactly in double precision, together with the associated free energy, mean energy, entropy, and mode occupations.

sedona-k does exactly that, and nothing more. It is one library file, one driver, one shell wrapper, and a log containing only values the program computed. It is written in [ngn/k](https://codeberg.org/ngn/k), a small interpreter for the K array language, because the computation is a handful of reductions over a 64-element vector and an array language states such reductions directly.

---

## 1. Context: where Layer 1 sits

Foundry F1 describes its stack as the *Sedona Spine*, a sequence of ten layers. The table below is given only to locate this repository; none of the layers other than Layer 1 is implemented here.

| Layer | Name | Role upstream |
|---|---|---|
| 0 | Boot | hardware detection, entropy source, memory checks |
| **1** | **UAC** | **pure arithmetic: Goldilocks field, prime monomial matrices, tensors** |
| 2 | ALP boundary | proof availability and verified transitions |
| 3 | Sigma kernel | resource limits and drift detection |
| 4 | Dissonance engine | contradiction and invariant-violation trapping |
| 5 | Triple-Lock gateway | multi-party approval of work |
| 6 | Execution runtime | execution of approved work |
| 7 | Unified witness | cryptographic evidence per transition |
| 8 | WORM ledger | append-only seal chain |
| 9 | Observability | metrics and audit views |

Layer 1, the Universal Atomic Calculator, is the only layer that is pure mathematics. Its constants live upstream in `include/types.h` and are reproduced exactly in the sibling repository [foundry-j](https://github.com/AHMADALIPARR/foundry-j) (`j/types.ijs`: `GOLDILOCKS_PRIME`, `EPSILON_FOLD`, `P64`). sedona-k takes those three constants and nothing else from the stack.

---

## 2. The Layer-1 constants

### 2.1 The Goldilocks prime and fold constant

$$
p = 2^{64} - 2^{32} + 1 = 18446744069414584321 .
$$

Its defining convenience is the congruence $2^{64} \equiv 2^{32} - 1 \pmod{p}$, which lets a 128-bit product be folded back into the field using the constant

$$
\varepsilon_{\mathrm{fold}} = 2^{32} - 1 = 4294967295 .
$$

sedona-k does no field arithmetic; it exports the prime and the fold constant so that the Layer-1 vocabulary is complete and checkable in one place. Field arithmetic is the business of foundry-j.

### 2.2 The prime spectrum

$$
P_{64} = (2, 3, 5, 7, 11, \ldots, 293, 307, 311).
$$

The list is hard-coded in `sedona.k` exactly as it appears upstream, and the program independently regenerates it by trial division over $2, \ldots, 311$ and compares the two. The comparison result is written to the log as `P64check`.

---

## 3. Primes as a bosonic gas

### 3.1 Modes, energies, temperature

Assign to each prime $p$ an independent bosonic mode with single-quantum energy

$$
E(p) = \ln p ,
$$

and identify the inverse temperature with the real argument of the zeta function, $\beta = s$, with Boltzmann's constant set to one. A state of the gas is a choice of occupation number $k_p \in \lbrace 0, 1, 2, \ldots \rbrace$ for each mode. Its total energy is

$$
E = \sum_p k_p \ln p = \ln \prod_p p^{k_p} = \ln N ,
$$

where $N = \prod_p p^{k_p}$. By unique factorization, multi-mode states are in bijection with the positive integers, and the state labelled $N$ has Boltzmann weight $e^{-sE} = N^{-s}$.

### 3.2 Single-mode and full partition functions

Summing the geometric series over the occupation of one mode gives

$$
z_p(s) = \sum_{k=0}^{\infty} p^{-ks} = \frac{1}{1 - p^{-s}} ,
$$

and independence of the modes makes the full partition function a product. Over all primes, for $s > 1$,

$$
Z(s) = \prod_{p} \frac{1}{1 - p^{-s}} = \sum_{N=1}^{\infty} N^{-s} = \zeta(s).
$$

This is Euler's product formula read physically: the zeta function is the partition function of the primon gas.

### 3.3 Why bosons

The bosonic choice is forced by the arithmetic. Unbounded occupation of each mode is what makes every prime power available, and therefore every integer. Restricting each mode to occupation $0$ or $1$ (fermions) admits only square-free integers and gives a different function:

$$
Z_F(s) = \prod_p \left(1 + p^{-s}\right) = \frac{\zeta(s)}{\zeta(2s)} .
$$

Weighting fermionic states by $(-1)^{\text{number of quanta}}$ gives $\prod_p (1 - p^{-s}) = 1/\zeta(s)$, the Dirichlet series of the Möbius function. Only the bosonic gas reproduces $\zeta(s)$ itself, and that is the one computed here.

### 3.4 Truncation to $P_{64}$

sedona-k keeps only the sixty-four modes in $P_{64}$:

$$
Z_{64}(s) = \prod_{p \in P_{64}} \frac{1}{1 - p^{-s}} .
$$

This is the length-64 partial Euler product. It is not $\zeta(s)$, and the program never claims it is: it prints $Z_{64}(s)$ next to a reference value of $\zeta(s)$ so that the truncation gap is visible. The truncation is deliberate. Upstream, $P_{64}$ is the grading spectrum of Layer 1; keeping the same cutoff means the arithmetic layer and its thermodynamic reading share one finite vocabulary.

---

## 4. Thermodynamic quantities

With $\beta = s$, the standard relations of canonical statistical mechanics give the following quantities. All sums and products run over $p \in P_{64}$.

**Log partition function.**

$$
\ln Z_{64}(s) = -\sum_{p} \ln\left(1 - p^{-s}\right).
$$

**Mean energy.** Differentiating the log partition function with respect to the inverse temperature,

$$
U = -\frac{\partial \ln Z_{64}}{\partial s} = \sum_{p} \frac{p^{-s} \ln p}{1 - p^{-s}} = \sum_{p} \frac{\ln p}{p^{s} - 1} .
$$

**Occupation numbers.** Each term of $U$ is the mode energy times the Bose–Einstein occupation at energy $\ln p$:

$$
n_p = \frac{1}{e^{s \ln p} - 1} = \frac{1}{p^{s} - 1}, \qquad U = \sum_p n_p \ln p .
$$

**Helmholtz free energy.**

$$
F = -\frac{\ln Z_{64}(s)}{s} .
$$

**Entropy.** From $F = U - TS$ with $T = 1/s$,

$$
S = s\,(U - F) = s\,U + \ln Z_{64}(s).
$$

These are the only quantities the program computes. It does not compute heat capacity, fluctuations, or any quantity at complex $s$. In particular, nothing here touches the zeros of $\zeta$ or the critical line; the computation lives entirely on the real half-line $s > 1$, where the Euler product converges absolutely.

### Size of the truncation gap

How far should $Z_{64}(s)$ be from $\zeta(s)$? Since $\ln \zeta(s) - \ln Z_{64}(s) = -\sum_{p > 311} \ln(1 - p^{-s}) \approx \sum_{p > 311} p^{-s}$, and the prime number theorem gives a prime density of about $1/\ln x$ near $x$,

$$
\sum_{p > N} p^{-s} \approx \int_N^{\infty} \frac{x^{-s}}{\ln x}\, dx \approx \frac{N^{1-s}}{(s-1)\ln N} .
$$

With $N = 311$ this predicts a relative gap of roughly $5.6 \times 10^{-4}$ at $s = 2$, $9.0 \times 10^{-7}$ at $s = 3$, and $1.9 \times 10^{-9}$ at $s = 4$. These are analytic order-of-magnitude estimates, not measurements; §7 shows the measured gaps fall in the same ranges.

---

## 5. Implementation in ngn/k

### 5.1 Files

| File | Role |
|---|---|
| `sedona.k` | library: Layer-1 constants, prime check, thermodynamic primitives, zeta references |
| `run.k` | driver: loads the library, prints diagnostics and tables, writes `logs/run-thermo.txt` |
| `run.sh` | wrapper: locates the interpreter, runs the driver, stamps a dated copy of the log |
| `logs/run-thermo.txt` | latest machine-readable table |
| `LICENSE` | GNU AGPL v3 |

### 5.2 The library

| Name | Definition |
|---|---|
| `goldilocksPrimeStr` | exact decimal string `"18446744069414584321"` |
| `goldilocksPrimeF` | floating approximation of $p$ via `exp` and `ln` (see §5.3) |
| `epsilonFold` | `4294967295` |
| `P64` | the 64 primes, hard-coded |
| `ispr`, `genP64`, `checkP64` | trial-division primality, regeneration of the list, and comparison |
| `powf[x;y]` | $x^y$ for positive $x$, as `exp(y * ln x)` |
| `zp[p;s]` | $1/(1 - p^{-s})$ |
| `Zof[P;s]` | product of `zp` over a prime list |
| `logZ`, `Fof`, `Uof`, `Sof`, `nof` | $\ln Z$, $F$, $U$, $S$, $n_p$ as in §4 |
| `row[P;s]` | the bundle `(s; logZ; F; U; S)` |
| `zeta2ref`, `zeta3ref`, `zeta4ref` | $\pi^2/6$, Apéry's constant, $\pi^4/90$ |

The thermodynamic primitives are one line each. For example, the mean energy is

```k
Uof:{[P;s]+/(`ln@P*1.0)%(powf[;s]'P)-1}
```

which reads, right to left: raise each prime to the power $s$, subtract one, divide each $\ln p$ by the result, and sum. `row` computes $\ln Z$ once and derives $F$ and $S$ from it, so the three columns of a table row are mutually consistent by construction.

### 5.3 Dialect notes

A few properties of ngn/k shape the code and are worth knowing before editing it:

- **No power verb.** In ngn/k `^` is not exponentiation, so powers are computed through `` `exp `` and `` `ln ``. This is exact enough for the quantities here but means every power is a floating-point operation.
- **No underscores in identifiers.** The upstream names `P_64` and `GOLDILOCKS_PRIME` are spelled `P64` and `goldilocksPrime…`.
- **Signed 64-bit integers.** The Goldilocks prime exceeds $2^{63} - 1$, so it cannot be held as a K integer. The exact value is carried as a string, and a float approximation is provided for display. A 53-bit mantissa cannot represent $p$ exactly, and the `exp`/`ln` route adds its own rounding; the logged float `1.8446744069414558e19` agrees with $p$ to about fifteen significant digits and differs in the low digits. The console labels it as an approximation.
- **Right-to-left evaluation.** K evaluates right to left with no operator precedence, so `a-b+1` means $a - (b + 1)$. The expression for `goldilocksPrimeF` is written in that form and therefore computes $2^{64} - (2^{32} + 1)$ rather than $2^{64} - 2^{32} + 1$; at double precision the difference of 2 is far below the resolution of a number near $1.8 \times 10^{19}$, so the logged value is unaffected, but anyone extending the code to exact arithmetic should parenthesize.

The fold constant $2^{32} - 1$ and all primes in $P_{64}$ fit comfortably in signed 64-bit integers.

### 5.4 The driver and the wrapper

`run.k` loads the library with `\l sedona.k`, prints the Goldilocks diagnostics, the length of $P_{64}$, the sieve check, and the list itself; evaluates `row[P64;s]` for $s \in \lbrace 2, 3, 4 \rbrace$; prints $Z_{64}(s)$ beside the reference $\zeta(s)$ and their difference; prints occupations for the first eight primes at $s = 2$; and writes a header, the three table rows, and the $Z_{64}$/reference pairs to `logs/run-thermo.txt`.

`run.sh` chooses the interpreter from `K_BIN`, defaulting to `/workspace/bin/k` and falling back to `/workspace/k-src/ngn-k/k`. It runs the driver, fails if no log was written, and copies the log to `logs/run-YYYYMMDD-HHMMSS.txt`. It adds no values of its own.

---

## 6. Building and running

### 6.1 Obtain ngn/k

ngn/k is not vendored in this repository (the binary name `k` is listed in `.gitignore`). Build it from source:

```bash
git clone https://codeberg.org/ngn/k.git /workspace/k-src/ngn-k
cd /workspace/k-src/ngn-k && make
mkdir -p /workspace/bin && cp k /workspace/bin/k
```

Any Linux x86-64 build of ngn/k should work; point `K_BIN` at it if it lives elsewhere.

### 6.2 Run

```bash
./run.sh                          # preferred; writes and stamps the log
K_BIN=/path/to/k ./run.sh         # explicit interpreter
/workspace/bin/k run.k            # driver only; writes logs/run-thermo.txt
```

The driver's first line is a shebang for `/workspace/bin/k`, so `./run.k` also works when the interpreter is at that path.

### 6.3 Expected console shape

The console shows, in order: the Goldilocks string and float, the fold constant, `P64 length = 64`, `P64 check (sieve) = 1`, the list of primes, the `s logZ F U S` table, the three lines comparing $Z_{64}(s)$ with $\zeta(s)$ and their gaps, and the occupation sample. The log file contains the subset listed in §5.4.

---

## 7. Measured results

All values below are copied from [`logs/run-thermo.txt`](logs/run-thermo.txt). The program is deterministic: repeated runs on the same interpreter produce a byte-identical log, and the dated copies that `run.sh` stamps locally match it exactly.

### 7.1 Constants and check

| Key | Logged value |
|---|---|
| `goldilocksPrimeStr` | `18446744069414584321` |
| `goldilocksPrimeF` | `1.8446744069414558e19` |
| `P64check` | `1` |

### 7.2 Thermodynamic table

| $s$ | $\ln Z_{64}$ | $F$ | $U$ | $S$ |
|---|---|---|---|---|
| 2 | 0.49723035924304143 | -0.24861517962152072 | 0.5668427810743075 | 1.6309159213916564 |
| 3 | 0.18403337990634724 | -0.06134445996878241 | 0.16481773695138102 | 0.6784865907604902 |
| 4 | 0.07910987134000454 | -0.019777467835001134 | 0.06366975447524818 | 0.33378888924099726 |

The rows satisfy the identities of §4 to the printed precision. At $s = 2$, for instance, $-\ln Z_{64}/2 = -0.2486\ldots = F$, and $2\,(U - F) = 2\,(0.5668\ldots + 0.2486\ldots) = 1.6309\ldots = S$. As $s$ grows the gas cools: fewer quanta are excited, and $\ln Z_{64}$, $U$, and $S$ all fall toward zero.

### 7.3 Truncated product against $\zeta(s)$

| $s$ | $Z_{64}(s)$ | reference $\zeta(s)$ | difference |
|---|---|---|---|
| 2 | 1.6441612228341203 | 1.6449340668482264 | $7.73 \times 10^{-4}$ |
| 3 | 1.2020559469415657 | 1.202056903159594 | $9.56 \times 10^{-7}$ |
| 4 | 1.0823232318416076 | 1.0823232337111381 | $1.87 \times 10^{-9}$ |

The difference column is the logged reference minus the logged $Z_{64}$ (the console prints the same differences at full precision). Relative to $Z_{64}$, the gaps are about $4.7 \times 10^{-4}$, $8.0 \times 10^{-7}$, and $1.7 \times 10^{-9}$, consistent in order of magnitude with the prime-number-theorem estimate of §4. Every gap is positive, as it must be: each omitted factor $1/(1 - p^{-s})$ exceeds one.

### 7.4 Occupations

At $s = 2$ the occupations of the first eight modes are exact rationals,

$$
n_2 = \tfrac{1}{3},\quad n_3 = \tfrac{1}{8},\quad n_5 = \tfrac{1}{24},\quad n_7 = \tfrac{1}{48},\quad n_{11} = \tfrac{1}{120},\quad n_{13} = \tfrac{1}{168},\quad n_{17} = \tfrac{1}{288},\quad n_{19} = \tfrac{1}{360},
$$

and the console prints their floating-point values (for example `0.12499999999999997` for $n_3$, where the last digits reflect the `exp`/`ln` route to powers). The mode at $p = 2$ carries one third of a quantum on average; by $p = 19$ the occupation has fallen by two orders of magnitude, which is why the truncation to sixty-four modes costs so little at these temperatures.

---

## 8. Limitations

- **Truncated spectrum.** $Z_{64}$ is a partial Euler product. Near $s = 1$ the omitted primes dominate and the truncation becomes a poor approximation of $\zeta$; the demo stays at $s \ge 2$.
- **Floating point throughout.** Powers go through `exp` and `ln` in IEEE-754 double precision. Results are reproducible on a given build but are not exact rationals.
- **Goldilocks prime not representable as a K integer.** It is carried as a string; the float is for display only.
- **Fixed temperatures.** The driver evaluates $s \in \lbrace 2, 3, 4 \rbrace$. Other values require editing `run.k`.
- **Reference values.** $\zeta(2)$ and $\zeta(4)$ are computed from closed forms; $\zeta(3)$ is a stored constant.

---

## 9. Relationship to sibling repositories

| Repository | Relationship |
|---|---|
| [foundry-j](https://github.com/AHMADALIPARR/foundry-j) | Source of the Layer-1 constants (`GOLDILOCKS_PRIME`, `EPSILON_FOLD`, `P64`). foundry-j implements the field, matrix, spectral, and recurrence mathematics; sedona-k implements none of it. |
| [hcalc](https://github.com/AHMADALIPARR/hcalc) | Uses the same $P_{64}$ to build a prime-weighted transform with weights $1/(1 + \ln p)$. The logarithm of a prime appears in both repositories — as a mode energy here and as a damping weight there — but the two constructions are independent and neither depends on the other. |
| [david](https://github.com/AHMADALIPARR/david) | Unrelated product; shares only licensing posture. |

---

## 10. Out of scope

- Layers 0 and 2–9 of the Sedona Spine: boot, proof boundary, kernel, dissonance detection, multi-party gating, execution, witnessing, ledger, and observability.
- Goldilocks field arithmetic, prime monomial matrices, and tensor constructions of Layer 1 (see foundry-j).
- Complex arguments, analytic continuation, and anything concerning the zeros of $\zeta$.
- Heat capacity, fluctuation, and grand-canonical quantities.
- Continuous-integration workflows.

---

## 11. License

Copyright © 2026 Prime Materia Commons / Foundry F1 contributors.

Distributed under the GNU Affero General Public License, **version 3 only** — see [`LICENSE`](LICENSE). SPDX identifier: `AGPL-3.0-only`. ngn/k is itself distributed under the GNU AGPL version 3 only.
