<!--
  Copyright (C) 2026 Prime Materia Commons / Foundry F1 contributors
  SPDX-License-Identifier: AGPL-3.0-only
-->

# sedona-k

Sedona Spine **Layer 1** as classical Riemann-gas thermodynamics over the
first 64 primes, in [ngn/k](https://codeberg.org/ngn/k).

This is **not** the full ten-layer Sedona spine (boot, ALP, Sigma, Triple-Lock,
WORM, …). It exports the Layer-1 Goldilocks constant and canonical \(P_{64}\),
treats each prime as a bosonic mode with energy \(E(p)=\ln p\), and prints a
truncated partition table for \(s\in\{2,3,4\}\).

Goldilocks field prime and spectrum:

\[
p = 2^{64}-2^{32}+1 = 18446744069414584321,
\qquad
P_{64}=\{2,3,5,\ldots,311\}.
\]

Truncated partition and mean energy:

\[
Z_{64}(s)=\prod_{p\in P_{64}}\frac{1}{1-p^{-s}},
\qquad
U=\sum_{p\in P_{64}}\frac{\ln p}{p^{s}-1}.
\]

Also computed: \(\log Z\), Helmholtz \(F=-\ln(Z)/s\), entropy \(S=s(U-F)\),
occupations \(n_p=1/(p^{s}-1)\).

## Quick start

Needs an ngn/k binary (repo ships a local `k`, or set `K_BIN`).

```bash
./run.sh                 # stamps logs/run-YYYYMMDD-HHMMSS.txt
# or:
./run.k                  # writes logs/run-thermo.txt
K_BIN=/path/to/k ./run.sh
```

## Measured results

From [`logs/run-thermo.txt`](logs/run-thermo.txt):

| Key | Value |
|-----|-------|
| `goldilocksPrimeStr` | `18446744069414584321` |
| `P64check` | `1` |

| \(s\) | \(\log Z\) | \(F\) | \(U\) | \(S\) |
|------|------------|-------|-------|-------|
| 2 | 0.49723035924304143 | -0.24861517962152072 | 0.5668427810743075 | 1.6309159213916564 |
| 3 | 0.18403337990634724 | -0.06134445996878241 | 0.16481773695138102 | 0.6784865907604902 |
| 4 | 0.07910987134000454 | -0.019777467835001134 | 0.06366975447524818 | 0.33378888924099726 |

| \(s\) | \(Z_{64}(s)\) | \(\zeta(s)\) ref |
|------|---------------|------------------|
| 2 | 1.6441612228341203 | 1.6449340668482264 |
| 3 | 1.2020559469415657 | 1.202056903159594 |
| 4 | 1.0823232318416076 | 1.0823232337111381 |

## Layout

```
sedona-k/
  LICENSE
  README.md
  sedona.k          constants + thermo primitives
  run.k             driver
  run.sh            wrapper (locate k, stamp log)
  k                 optional local ngn/k binary
  logs/             measured tables only
```

## Limitations

ngn/k integers are signed 64-bit; Goldilocks \(p\) does not fit. The exact
decimal is kept in `goldilocksPrimeStr`; `goldilocksPrimeF` is IEEE-754
(low bits inexact). Thermo uses double `` `ln `` / `` `exp ``. Identifiers
cannot contain `_` (`P64`, not `P_64`). \(Z_{64}\) is the partial Euler
product over \(P_{64}\), not \(\zeta(s)\).

## License

Copyright © 2026 Prime Materia Commons / Foundry F1 contributors.
**AGPL-3.0-only** — see [`LICENSE`](LICENSE). ngn/k is also AGPL-3.0-only.
