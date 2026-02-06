# AD Reaction Kernel Demo

This directory demonstrates the implementation of reaction kernels with both manual and automatic differentiation (AD) approaches.

## Problem Statement

The demo implements a simple reaction term:
```
R(u) = α u
```

where:
- `u` is the solution variable
- `α` is the reaction rate coefficient

The weak form is: `(ψ_i, α u_h)`

## Files

### Kernel Implementations
- `DemoReaction.h/.C` - Manual Jacobian implementation
- `ADDemoReaction.h/.C` - Automatic differentiation implementation

### Input Files
- `steady_reaction.i` - Steady-state reaction-diffusion problem
- `transient_reaction.i` - Transient reaction-diffusion problem  
- `jacobian_test.i` - Minimal problem for Jacobian verification

### Test Files
- `tests` - TestHarness test specifications
- `gold/` - Expected output files (generated during test runs)

## Key Differences

### Manual Implementation (DemoReaction)
```cpp
Real computeQpResidual() {
    return _test[_i][_qp] * _reaction_rate * _u[_qp];
}

Real computeQpJacobian() {
    return _test[_i][_qp] * _reaction_rate * _phi[_j][_qp];
}
```

### AD Implementation (ADDemoReaction)
```cpp
ADReal computeQpResidual() {
    return _test[_i][_qp] * _reaction_rate * _u[_qp];
}
// Jacobian computed automatically!
```

## Usage Examples

### Run steady-state test:
```bash
cd /home/engine/project/test
make -j4
./run_tests -j4 kernels/reaction_demo/steady_comparison
```

### Run Jacobian test:
```bash
./run_tests -j4 kernels/reaction_demo/jacobian_ad
```

## Verification

The tests verify:
1. Both implementations produce identical solutions
2. AD Jacobian is numerically perfect
3. Manual Jacobian matches analytical expectation
4. Different reaction rates work correctly
5. Both steady and transient problems solve successfully

## Educational Value

This demo illustrates:
- How to implement custom kernels in MOOSE
- The difference between manual and AD Jacobian computation
- How to verify Jacobian correctness
- Best practices for kernel testing
- Template-based code reuse patterns in MOOSE