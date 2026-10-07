/ sedona.k - Sedona Spine Layer-1 primes as Riemann-gas thermodynamics (ngn/k)
/ Copyright (C) 2026 Prime Materia Commons / Foundry F1 contributors
/ SPDX-License-Identifier: AGPL-3.0-only
/ .
/ Grounded in Foundry F1:
/   foundry-j/j/types.ijs  (GOLDILOCKS_PRIME, P64)
/   foundry-j/README.md    (Sedona Spine Layer 1 / UAC)
/ .
/ Model (classical Riemann gas / Julia statistical theory of numbers):
/   primes as bosonic modes with E(p)=ln(p), inverse temperature beta=s (s>1)
/   z_p(s)=1/(1-p^{-s}),  Z64(s)=prod z_p,  F=-ln(Z)/s
/   U=sum (ln p)/(p^s-1),  S=s(U-F),  n_p=1/(p^s-1)
/ .
/ NOTE: ngn/k identifiers cannot contain underscores. Canonical C++/J names
/ P_64 and GOLDILOCKS_PRIME are spelled P64 / goldilocksPrime* here.

/ Sedona constants
/ Goldilocks prime p = 2^64 - 2^32 + 1 = 18446744069414584321
/ ngn/k ints are signed 64-bit; this value does not fit. Keep exact decimal
/ string + IEEE-754 float approximation (53-bit mantissa loses low bits).
goldilocksPrimeStr:"18446744069414584321"
goldilocksPrimeF:(`exp@64*`ln@2.0)-(`exp@32*`ln@2.0)+1.0
epsilonFold:4294967295                    / 2^32-1 (fits in signed 64-bit)

/ Canonical P_64 from Foundry types.ijs / types.h (first 64 primes, 2..311)
P64:2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 101 103 107 109 113 127 131 137 139 149 151 157 163 167 173 179 181 191 193 197 199 211 223 227 229 233 239 241 251 257 263 269 271 277 281 283 293 307 311

/ Primality / sieve check
/ i!I is mod with left=modulus: (d!x) = x mod d.  Monadic % is sqrt.
ispr:{$[x<2;0;0=2!x;x=2;(s:_%x)<2;1;&/~0=(2_!1+s)!'x]}
/ First 64 primes by filtering 2..311
genP64:{a:2+!310;a@&ispr'a}
checkP64:{P64~genP64[]}

/ Riemann-gas thermodynamics on a prime list
/ ngn/k has no ^ power verb (^ is null/fill/without); use exp(s*ln p).
powf:{[x;y]`exp@y*`ln@x*1.0}              / x^y for positive x
/ Single-mode partition z_p(s) = 1/(1 - p^{-s})
zp:{[p;s]1%(1-powf[p;-s])}
/ Truncated partition Z(s) = prod z_p
Zof:{[P;s]*/zp[;s]'P}
/ log Z
logZ:{[P;s]`ln@Zof[P;s]}
/ Helmholtz free energy F = -log(Z)/s
Fof:{[P;s](-logZ[P;s])%s}
/ Mean energy U = sum (ln p)/(p^s - 1)
Uof:{[P;s]+/(`ln@P*1.0)%(powf[;s]'P)-1}
/ Entropy S = s(U - F)
Sof:{[P;s]s*(Uof[P;s]-Fof[P;s])}
/ Occupation numbers n_p = 1/(p^s - 1)
nof:{[P;s]1%(powf[;s]'P)-1}
/ Bundle row: (s; logZ; F; U; S)
row:{[P;s]lz:logZ[P;s];F:(-lz)%s;U:Uof[P;s];(s;lz;F;U;s*(U-F))}

/ Z64 is the length-64 Euler product for zeta(s).
/ Closed forms: zeta(2)=pi^2/6, zeta(4)=pi^4/90; zeta(3) approx below.
zeta2ref:(`exp@2*`ln@3.141592653589793)%6.0
zeta4ref:(`exp@4*`ln@3.141592653589793)%90.0
zeta3ref:1.202056903159594
