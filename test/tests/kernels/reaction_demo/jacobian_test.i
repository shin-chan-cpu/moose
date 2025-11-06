# Simple test for Jacobian verification
# Minimal problem to focus on reaction kernel Jacobian

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 3
  ny = 3
[]

[Variables]
  [u_manual]
  []
  [u_ad]
  []
[]

[Kernels]
  [reaction_manual]
    type = DemoReaction
    variable = u_manual
    reaction_rate = 3.0
  []
  [reaction_ad]
    type = ADDemoReaction
    variable = u_ad
    reaction_rate = 3.0
  []
[]

[BCs]
  [all_manual]
    type = DirichletBC
    variable = u_manual
    boundary = 'left right top bottom'
    value = 0.0
  []
  [all_ad]
    type = ADDirichletBC
    variable = u_ad
    boundary = 'left right top bottom'
    value = 0.0
  []
[]

[Executioner]
  type = Steady
  solve_type = NEWTON
[]

[Outputs]
  exodus = false
[]