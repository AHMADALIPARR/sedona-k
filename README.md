# Sedona Spine → Riemann-gas thermodynamics (ngn/k)

AGPL-3.0-only recreation of **Sedona Spine Layer-1** (Foundry F1 / Prime Materia Commons)
prime constants as a **classical Riemann gas** (Julia statistical theory of numbers),
implemented in [ngn/k](https://codeberg.org/ngn/k).

## Mapping

| Sedona Spine (Layer 1 / UAC) | Riemann-gas thermodynamics |
| --- | --- |
| Goldilocks field prime \(p = 2^{64}-2^{32}+1\) | Field modulus (documented; see bigint note) |
| \(P_{64}\) = first 64 primes \(2,\ldots,311\) | Bosonic modes with energy \(E(p)=\ln p\) |
| Prime Monomial Matrices / grading | Occupations \(n_p = 1/(p^{s}-1)\) |
| Inverse temperature | \(\beta = s\) (real \(s>1\) for absolute convergence of the truncated product) |

Thermodynamic quantities on the truncated spectrum \(P_{64}\):

1. Single-mode partition: \(z_p(s) = 1/(1-p^{-s})\)
2. Truncated partition: \(Z_{64}(s) = \prod_{p\in P_{64}} z_p(s)\) (partial Euler product for \(\zeta(s)\))
3. Helmholtz free energy: \(F = -\ln(Z)/s\)
4. Mean energy: \(U = \sum_p (\ln p)/(p^{s}-1)\)
5. Entropy: \(S = s(U-F)\)
6. Occupation: \(n_p = 1/(p^{s}-1)\)

Source refs (authoritative constants):

- `/workspace/foundry-j/j/types.ijs` — `GOLDILOCKS_PRIME`, `P64`
- `/workspace/foundry-j/README.md` — Sedona Spine 10-layer stack, Layer 1 UAC

## Requirements

- **ngn/k** binary (this box: `/workspace/bin/k`, built from `/workspace/k-src/ngn-k`)
- Linux x86_64

Build ngn/k (if needed):

```bash
git clone https://codeberg.org/ngn/k.git /workspace/k-src/ngn-k
cd /workspace/k-src/ngn-k && make
cp k /workspace/bin/k
```

Upstream note: ngn/k README points to the maintained fork [growler/k](https://codeberg.org/growler/k);
this install used `codeberg.org/ngn/k` as preferred and it built cleanly (all `make` tests passed).

## How to run

```bash
cd /workspace/sedona-k
./run.sh          # preferred; stamps logs/run-YYYYMMDD-HHMMSS.txt
# or:
./run.k           # shebang entry; writes logs/run-thermo.txt
# or:
/workspace/bin/k run.k
```

`run.k` `\l` loads `sedona.k`, checks \(P_{64}\) via trial division, prints the table for
\(s\in\{2,3,4\}\), compares \(Z_{64}(s)\) to \(\zeta(2)=\pi^2/6\), \(\zeta(3)\) reference,
\(\zeta(4)=\pi^4/90\), and writes **only computed values** under `logs/`.

## Library (`sedona.k`)

| Name | Role |
| --- | --- |
| `goldilocksPrimeStr` | Exact decimal string `18446744069414584321` |
| `goldilocksPrimeF` | Float approximation of Goldilocks prime |
| `epsilonFold` | \(2^{32}-1 = 4294967295\) |
| `P64` | First 64 primes (canonical `P_64`) |
| `ispr` / `genP64` / `checkP64` | Primality check & sieve verification |
| `Zof` `logZ` `Fof` `Uof` `Sof` `nof` `row` | Thermo primitives |

**Identifier note:** ngn/k names cannot contain `_`, so `P_64` / `GOLDILOCKS_PRIME` are
spelled `P64` / `goldilocksPrime*`.

**Power note:** ngn/k `^` is null/fill/without, not exponentiation. Powers use
`` `exp@s*`ln@p ``.

**Comment note:** a line that is only `/` aborts `\l` load; comments use `/ text`.

## Limitations (float / integer)

- ngn/k integers are **signed 64-bit**. Goldilocks \(p=2^{64}-2^{32}+1\) does **not** fit;
  we keep the exact decimal in `goldilocksPrimeStr` and an IEEE-754 float in
  `goldilocksPrimeF` (53-bit mantissa ⇒ low bits inexact). \(P_{64}\) values are exact ints.
- All thermo quantities are computed in double floats via `` `ln `` / `` `exp ``.
- \(Z_{64}(s)\) truncates the Euler product; the gap to \(\zeta(s)\) shrinks rapidly with \(s\).

## License

This project is licensed under the **GNU Affero General Public License v3.0 only**
(AGPL-3.0-only). See [LICENSE](LICENSE).

ngn/k itself is also AGPL-3.0-only.
