#! /workspace/bin/k
/ run.k - execute Sedona Riemann-gas thermo table and write logs/run-*.txt
/ SPDX-License-Identifier: AGPL-3.0-only
\l sedona.k

`0:"=== Sedona Spine / Riemann-gas thermodynamics (ngn/k) ==="
`0:"K: ngn/k (codeberg.org/ngn/k)  license AGPL-3.0-only"
`0:"goldilocksPrimeStr = ",goldilocksPrimeStr
`0:"goldilocksPrimeF   = ",($goldilocksPrimeF),"  (float approx; exact needs >63-bit int)"
`0:"epsilonFold        = ",($epsilonFold)
`0:"P64 length         = ",($#P64)
`0:"P64 check (sieve)  = ",($checkP64[])
`0:"P64 =",,/" ",'$'P64

ss:2.0 3.0 4.0
`0:""
`0:"s logZ F U S"
`0:"-- ---- - - -"

lines:{[s],/" ",'$'row[P64;s]}'ss
`0:lines 0
`0:lines 1
`0:lines 2
`0:""
`0:"Z64(s) vs reference zeta(s) (Euler product truncated to P64):"
`0:"s=2  Z64=",($Zof[P64;2.0]),"  zeta2ref(pi^2/6)=",($zeta2ref),"  gap=",($zeta2ref-Zof[P64;2.0])
`0:"s=3  Z64=",($Zof[P64;3.0]),"  zeta3ref=",($zeta3ref),"  gap=",($zeta3ref-Zof[P64;3.0])
`0:"s=4  Z64=",($Zof[P64;4.0]),"  zeta4ref(pi^4/90)=",($zeta4ref),"  gap=",($zeta4ref-Zof[P64;4.0])

`0:""
`0:"occupation n_p = 1/(p^s-1) for s=2 (first 8 primes):"
`0:"p =",,/" ",'$'8#P64
`0:"n =",,/" ",'$'8#nof[P64;2.0]

hdr:("Sedona Spine Riemann-gas run";"K=ngn/k";"goldilocksPrimeStr=",goldilocksPrimeStr;"goldilocksPrimeF=",($goldilocksPrimeF);"P64check=",($checkP64[]);"columns: s logZ F U S")
foot:("Z64_2=",($Zof[P64;2.0]);"zeta2ref=",($zeta2ref);"Z64_3=",($Zof[P64;3.0]);"zeta3ref=",($zeta3ref);"Z64_4=",($Zof[P64;4.0]);"zeta4ref=",($zeta4ref))
"logs/run-thermo.txt"0:hdr,lines,foot
`0:""
`0:"wrote logs/run-thermo.txt"
