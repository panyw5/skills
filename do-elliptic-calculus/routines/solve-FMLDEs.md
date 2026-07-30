# TASK DESCRIPTION
Given a set of flavored modular linear differential equations (FMLDEs), find the set of common solutions as $q$ series

# ALGORITHM
overall idea is simple: solve the equations order by order

1. ansatz is controlled by `chorder`, e.g., `ch = q^\[Alpha] Sum[aaa[l][b[1]] q^(l/2), {l, 0, chorder}]`
2. start with `chorder=0`, then $ch = q^\alpha aaa[0][b[1]]$, plug it into the equations (expanded to some higher `order = chorder + 3` to avoid missing terms when expansion order too low), algebraically solve the `\[Alpha]` and `aaa[0][b[1]]` and its derivatives
3. For each `\[Alpha]`, solve the lowest order ODE satisfied by `aaa[0][b[1]]`
4. For each `\[Alpha]`, raise `chorder = 1`, plug in `\[Alpha]` and `aaa[0][b[1]]` solution into the ansatz, repeat the above procedure until `aaa[1][b[1]]` or its derivatives are algebraically solved
5. Solve the lowest order ODE for `aaa[1][b[1]]`
6. repeat

# example
see [solve-FMLDEs.wls](solve-FMLDEs.wls)
