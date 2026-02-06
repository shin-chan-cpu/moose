# Mathematical Analysis of Reaction Kernel Implementation

## Problem Statement

We implement the reaction term:
```
R(u) = α u
```

where:
- `u` is the solution variable
- `α` is the reaction rate coefficient

## Weak Form

The weak form is obtained by multiplying by test function `ψ_i` and integrating:
```
∫_Ω ψ_i (α u) dΩ
```

Using numerical quadrature:
```
∑_q w_q ψ_i(x_q) α u(x_q)
```

In MOOSE notation: `_test[_i][_qp] * _reaction_rate * _u[_qp]`

## Jacobian Computation

### Manual Implementation

For the manual Jacobian, we need to compute:
```
∂R/∂u_j = ∂/∂u_j (∫ ψ_i α u dΩ) = ∫ ψ_i α (∂u/∂u_j) dΩ
```

Since `u = ∑_j u_j φ_j`, we have `∂u/∂u_j = φ_j`:
```
∂R/∂u_j = ∫ ψ_i α φ_j dΩ
```

In MOOSE notation: `_test[_i][_qp] * _reaction_rate * _phi[_j][_qp]`

### AD Implementation

With automatic differentiation, we only need to provide the residual:
```cpp
ADReal computeQpResidual() {
    return _test[_i][_qp] * _reaction_rate * _u[_qp];
}
```

MOOSE automatically computes the Jacobian using forward-mode AD:
- `_u[_qp]` contains both the value and derivatives
- The derivative of `_u[_qp]` w.r.t. `u_j` is `_phi[_j][_qp]`
- Chain rule gives the same result as manual computation

## Verification

Both implementations should produce identical:
1. **Residuals**: Same weak form evaluation
2. **Jacobian**: Same derivative computation (manual vs automatic)
3. **Solutions**: Same nonlinear solve results

## Code Comparison

### Manual Kernel
```cpp
Real computeQpResidual() {
    return _test[_i][_qp] * _reaction_rate * _u[_qp];
}

Real computeQpJacobian() {
    return _test[_i][_qp] * _reaction_rate * _phi[_j][_qp];
}
```

### AD Kernel
```cpp
ADReal computeQpResidual() {
    return _test[_i][_qp] * _reaction_rate * _u[_qp];
}
// Jacobian computed automatically!
```

## Benefits of AD

1. **Reduced code complexity**: No need to manually derive Jacobians
2. **Reduced errors**: Automatic derivatives are always correct
3. **Easier maintenance**: Changes to residual automatically propagate to Jacobian
4. **Complex expressions**: AD handles complex nonlinearities effortlessly

## Performance Considerations

- **AD**: Slightly higher memory usage, but often faster for complex expressions
- **Manual**: Potentially faster for simple expressions, but more error-prone
- **Hybrid approach**: Use AD for complex terms, manual for simple ones

This demo serves as a baseline for understanding AD in MOOSE before moving to more complex physics.