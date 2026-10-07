# Sedona Spine → Riemann-gas thermodynamics (ngn/k)

This repository is an **AGPL-3.0-only** recreation of **Sedona Spine Layer-1** constants from Foundry F1 / Prime Materia Commons, interpreted as a **classical Riemann gas** and executed in [ngn/k](https://codeberg.org/ngn/k). It does not reimplement the full ten-layer Foundry stack. It takes the Layer-1 prime field and the canonical prime list \(P_{64}\), maps them onto bosonic statistical mechanics in the sense of Julia’s statistical theory of numbers, and prints a small, reproducible thermodynamic table.

The layout is deliberately small: one library (`sedona.k`), one driver (`run.k`), one shell wrapper (`run.sh`), and logs that contain **only values this program actually computed**. Digests, timings, and other unmeasured metrics are not invented here.

---

## Sedona Spine context

Foundry F1 organizes its verified computing stack as the **Sedona Spine**: ten layers that run from bare-metal boot through immutable audit. The layers, briefly, are:

| Layer | Name | Role |
| --- | --- | --- |
| 0 | Boot | CPU detection, entropy source, memory verification (`boot.seal`) |
| 1 | **UAC** | Universal Atomic Calculator — Goldilocks field, prime monomial matrices, tensors |
| 2 | ALP Boundary | Proof availability, sorry manifest, verified transitions |
| 3 | Sigma Kernel | Resource limits, entropy tracking, drift detection |
| 4 | Dissonance Engine | Contradiction detection, invariant-violation trapping |
| 5 | Triple-Lock Gateway | Guardian / Examiner / Publisher → `VerifiedManifest` |
| 6 | Execution Runtime | Approved work only; no bypass of Triple-Lock |
| 7 | Unified Witness | Cryptographic evidence per transition (SHA-256 chain) |
| 8 | WORM Ledger | Append-only, tamper-evident seal chain |
| 9 | Observability | Metrics, graphs, audit, real-time telemetry |

Layers 2–9 handle policy, gating, evidence, and observation. **This repository focuses on Layer 1 — UAC.**

### Layer 1 — Universal Atomic Calculator

UAC is the Spine’s pure mathematics engine. Its arithmetic core is the **Goldilocks prime field**

\[
p = 2^{64} - 2^{32} + 1 = 18446744069414584321
\]

(also written `0xFFFFFFFF00000001`). Field elements are reduced modulo \(p\); the reduction identity \(2^{64} \equiv 2^{32}-1 \pmod{p}\) yields the fold constant \(\varepsilon = 2^{32}-1 = 4294967295\). Alongside the field, Foundry publishes a canonical list of the first sixty-four primes,

\[
P_{64} = \{2,3,5,\ldots,311\},
\]

used as grading coordinates for **prime monomial matrices** and related tensor constructions. Authoritative sources for these constants in the Foundry tree are `foundry-j/j/types.ijs` (`GOLDILOCKS_PRIME`, `P64` / `P_64`, `EPSILON_FOLD`) and the Sedona Spine section of `foundry-j/README.md`.

Sedona-k is not a full UAC. It exports the same numeric constants and asks: *what does the truncated Euler product over \(P_{64}\) look like as the partition function of a bosonic gas?*

---

## Why primes as bosonic modes

The **classical Riemann gas** (Julia; statistical theory of numbers) treats each prime \(p\) as an independent bosonic mode whose single-particle energy is the logarithm of the prime:

\[
E(p) = \ln p.
\]

Inverse temperature is identified with the real zeta argument:

\[
\beta = s \qquad (s > 1).
\]

A bosonic mode with energy \(E\) has geometric occupation statistics. The mean occupation of mode \(p\) at inverse temperature \(s\) is

\[
n_p = \frac{1}{e^{s E(p)} - 1} = \frac{1}{p^{s} - 1}.
\]

That is the Bose–Einstein factor with \(E = \ln p\). Independent modes make the grand partition function a product over primes. This bridges Sedona’s Layer-1 prime list and analytic number theory: \(P_{64}\) is a **truncated bosonic spectrum**, not merely a table of small primes.

Why bosons and not fermions? The Euler product for \(\zeta(s)\) expands over all positive integers via unique factorization. Each prime power \(p^k\) carries weight \(p^{-ks}\)—the geometric series of a bosonic mode (unbounded occupation). A fermionic gas would cap occupation at 0 or 1 and yield \(1/\zeta(s)\) instead. The Riemann gas that recovers \(\zeta\) is therefore bosonic.

Sedona’s prime monomial grading already treats primes as free commutative generators. Reading them as bosonic modes is a change of language, not of generators: the same \(P_{64}\) that grades UAC matrices is the mode set of the gas.

---

## Partition product versus \(\zeta(s)\)

For a single prime mode the local partition function is

\[
z_p(s) = \sum_{k=0}^{\infty} e^{-s k \ln p} = \sum_{k=0}^{\infty} p^{-ks} = \frac{1}{1 - p^{-s}}.
\]

The full (infinite) product recovers the Riemann zeta function for \(\operatorname{Re}(s) > 1\):

\[
\zeta(s) = \prod_{p\text{ prime}} \frac{1}{1 - p^{-s}}.
\]

Sedona-k truncates the product to the Foundry spectrum:

\[
Z_{64}(s) = \prod_{p \in P_{64}} z_p(s) = \prod_{p \in P_{64}} \frac{1}{1 - p^{-s}}.
\]

Thus \(Z_{64}(s)\) is the length-64 partial Euler product for \(\zeta(s)\). Absolute convergence needs \(s > 1\); the demo evaluates \(s \in \{2,3,4\}\), where closed or high-precision references exist:

- \(\zeta(2) = \pi^2/6\)
- \(\zeta(3)\) (Apery’s constant; reference value stored in `zeta3ref`)
- \(\zeta(4) = \pi^4/90\)

As \(s\) grows, higher primes contribute less, so \(\zeta(s) - Z_{64}(s)\) shrinks rapidly. The measured table below (from `logs/run-thermo.txt`) shows near-agreement with \(\zeta(4)\) already at \(s=4\); at \(s=2\) the gap is still visible but small. Truncation is intentional: Layer-1 Foundry work is graded by \(P_{64}\), and the Riemann-gas view keeps the same cutoff so UAC constants and thermodynamic outputs share one vocabulary.

---

## Thermodynamic quantities

Once \(Z_{64}(s)\) is defined, the classical thermodynamic potentials follow. With \(k_B = 1\) and \(\beta = s\):

1. **Single-mode partition** — \(z_p(s) = 1/(1 - p^{-s})\).
2. **Truncated partition** — \(Z_{64}(s) = \prod_{p\in P_{64}} z_p(s)\).
3. **Log partition** — \(\log Z = \ln Z_{64}(s)\).
4. **Helmholtz free energy** — \(F = -\ln(Z)/s\).
5. **Mean energy** — \(U = \sum_{p\in P_{64}} (\ln p)/(p^{s}-1)\).
6. **Entropy** — \(S = s(U - F)\).
7. **Occupation** — \(n_p = 1/(p^{s}-1)\).

These are exactly the primitives implemented in `sedona.k` as `zp`, `Zof`, `logZ`, `Fof`, `Uof`, `Sof`, `nof`, and the bundled `row` (which returns `(s; logZ; F; U; S)`).

The mean energy formula is the sum of \(E(p)\, n_p\): each mode contributes \(\ln p\) times its Bose occupation. Entropy follows from the Legendre relation \(S = \beta(U - F)\) with \(\beta = s\). Nothing beyond these definitions is claimed; in particular this demo does not compute heat capacity, pressure, or grand potential beyond \(F\).

---

## How ngn/k implements it

### File layout

```
sedona-k/
├── LICENSE              # GNU AGPL v3 only (unchanged)
├── README.md            # this document
├── .gitignore
├── k                    # local copy of ngn/k binary (optional)
├── sedona.k             # library: constants + thermo primitives
├── run.k                # driver: load library, print table, write log
├── run.sh               # shell wrapper: locate k, stamp dated log
└── logs/
    ├── run-thermo.txt   # latest computed table (overwrite each run)
    └── run-YYYYMMDD-HHMMSS.txt   # stamped copies from run.sh
```

### `sedona.k` — library

Constants (names without underscores; see Limitations):

| Name | Role |
| --- | --- |
| `goldilocksPrimeStr` | Exact decimal string `18446744069414584321` |
| `goldilocksPrimeF` | IEEE-754 float approximation of the Goldilocks prime |
| `epsilonFold` | \(2^{32}-1 = 4294967295\) (fits in signed 64-bit) |
| `P64` | First 64 primes `2 … 311` (canonical Foundry `P_64`) |
| `ispr` / `genP64` / `checkP64` | Trial-division primality and sieve verification |
| `powf` | Positive real power via `` `exp@y*`ln@x `` |
| `zp` `Zof` `logZ` `Fof` `Uof` `Sof` `nof` `row` | Thermo primitives |
| `zeta2ref` `zeta3ref` `zeta4ref` | Reference values for gap reporting |

`checkP64` regenerates the first 64 primes by filtering `2..311` with `ispr` and compares the result to the hardcoded `P64`. A successful run records `P64check=1` in the log.

### `run.k` — driver

`run.k` `\l`-loads `sedona.k`, prints Goldilocks and \(P_{64}\) diagnostics, evaluates `row[P64;s]` for \(s\in\{2,3,4\}\), compares \(Z_{64}(s)\) to zeta references, samples occupations at \(s=2\), and writes `logs/run-thermo.txt`. Only computed values go into that file.

### `run.sh` — wrapper

`run.sh` locates ngn/k (`K_BIN`, default `/workspace/bin/k`, fallback `/workspace/k-src/ngn-k/k`), runs `run.k`, and stamps `logs/run-YYYYMMDD-HHMMSS.txt`. It invents no metrics—only copies what K wrote.

---

## How to run

Requirements: an **ngn/k** binary on Linux x86_64. Preferred path here: `/workspace/bin/k` (from `/workspace/k-src/ngn-k`). Upstream ngn/k is AGPL-3.0-only; the ngn/k README also documents the fork [growler/k](https://codeberg.org/growler/k).

Build ngn/k if needed:

```bash
git clone https://codeberg.org/ngn/k.git /workspace/k-src/ngn-k
cd /workspace/k-src/ngn-k && make
cp k /workspace/bin/k
```

Run the thermodynamics demo from the repository root:

```bash
cd /workspace/sedona-k   # or: cd path/to/sedona-k
./run.sh                 # preferred; stamps logs/run-YYYYMMDD-HHMMSS.txt
# alternatives:
./run.k                  # shebang entry; writes logs/run-thermo.txt
/workspace/bin/k run.k   # explicit interpreter
```

Console output includes Goldilocks diagnostics, `P64 check (sieve) = 1`, the `s logZ F U S` table, \(Z_{64}\) versus zeta references, and a short occupation sample. The machine-readable summary is `logs/run-thermo.txt`.

---

## Measured results

Numbers below are copied verbatim from `logs/run-thermo.txt` after a successful run. They are not fabricated.

**Constants and check**

| Key | Measured value |
| --- | --- |
| `goldilocksPrimeStr` | `18446744069414584321` |
| `goldilocksPrimeF` | `1.8446744069414558e19` |
| `P64check` | `1` |

**Thermodynamic table** (`columns: s logZ F U S`)

| \(s\) | \(\log Z\) | \(F\) | \(U\) | \(S\) |
| --- | --- | --- | --- | --- |
| 2.0 | 0.49723035924304143 | -0.24861517962152072 | 0.5668427810743075 | 1.6309159213916564 |
| 3.0 | 0.18403337990634724 | -0.06134445996878241 | 0.16481773695138102 | 0.6784865907604902 |
| 4.0 | 0.07910987134000454 | -0.019777467835001134 | 0.06366975447524818 | 0.33378888924099726 |

**Truncated partition versus zeta references**

| \(s\) | \(Z_{64}(s)\) | reference \(\zeta(s)\) |
| --- | --- | --- |
| 2 | 1.6441612228341203 | 1.6449340668482264 (\(\pi^2/6\)) |
| 3 | 1.2020559469415657 | 1.202056903159594 |
| 4 | 1.0823232318416076 | 1.0823232337111381 (\(\pi^4/90\)) |

Reading the table: as \(s\) rises (colder gas), \(F\) becomes less negative, \(U\) and \(S\) fall, and \(\log Z\) shrinks toward zero. The printed \(Z_{64}\)–\(\zeta\) gap is larger at \(s=2\) than at \(s=4\). Re-run `./run.sh` and compare a fresh `logs/run-thermo.txt`; do not trust paraphrased secondary numbers.

---

## Mapping summary

| Sedona Spine (Layer 1 / UAC) | Riemann-gas thermodynamics |
| --- | --- |
| Goldilocks field prime \(p = 2^{64}-2^{32}+1\) | Field modulus (documented; bigint note below) |
| \(P_{64}\) = first 64 primes \(2,\ldots,311\) | Bosonic modes with energy \(E(p)=\ln p\) |
| Prime monomial matrices / grading | Occupations \(n_p = 1/(p^{s}-1)\) |
| Inverse temperature | \(\beta = s\) (real \(s>1\) for absolute convergence of the truncated product) |

---

## Limitations

ngn/k and modeling constraints shape what this demo can do.

**Signed 64-bit integers.** ngn/k integers are signed 64-bit; Goldilocks \(p = 2^{64}-2^{32}+1\) does **not** fit. The library keeps the exact decimal in `goldilocksPrimeStr` and an IEEE-754 float in `goldilocksPrimeF` (53-bit mantissa ⇒ low bits inexact; printed `1.8446744069414558e19` is not a bigint). All of \(P_{64}\) (max 311) and `epsilonFold = 4294967295` are exact ints.

**Float thermo.** All thermo quantities use double `` `ln `` / `` `exp ``. There is no multiprecision path. \(\zeta(2)\) / \(\zeta(4)\) comparisons use the float \(\pi\) in `zeta2ref` / `zeta4ref`.

**No underscore names.** ngn/k identifiers cannot contain `_`. Foundry / C++ names `P_64` and `GOLDILOCKS_PRIME` are spelled `P64` and `goldilocksPrime*` here.

**`^` is not power.** In ngn/k, `^` is null/fill/without. Powers use `` `exp@s*`ln@p `` (`powf`). A lone `/` aborts `\l`; comments must be `/ text`.

**Truncation.** \(Z_{64}(s)\) is the correct partial Euler product for spectrum \(P_{64}\), not \(\zeta(s)\). Extending past 311 would leave the Foundry Layer-1 constant set.

**Scope.** Layers 2–9, Goldilocks mulmod, prime monomial matrices, witnesses, and WORM seals belong to Foundry F1. Sedona-k is the Layer-1 constant set read as a Riemann gas in ngn/k.

---

## License

This project is licensed under the **GNU Affero General Public License v3.0 only** (AGPL-3.0-only). See [LICENSE](LICENSE). The LICENSE file is kept as-is; do not relicense to MIT or any other terms. ngn/k is also AGPL-3.0-only; derivatives must meet AGPL-3.0-only obligations, including corresponding source for network use where applicable.
