# Simple reaction-only problem to test the reaction kernels
# Solves: α u = 0 with Dirichlet BCs (trivial but tests kernel assembly)

[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 5
  xmin = 0
  xmax = 1
[]

[Variables]
  [u_manual]
    order = FIRST
    family = LAGRANGE
  []
  [u_ad]
    order = FIRST
    family = LAGRANGE
  []
[]

[Kernels]
  [reaction_manual]
    type = DemoReaction
    variable = u_manual
    reaction_rate = 4.0
  []
  [reaction_ad]
    type = ADDemoReaction
    variable = u_ad
    reaction_rate = 4.0
  []
[]

[BCs]
  [left_manual]
    type = DirichletBC
    variable = u_manual
    boundary = left
    value = 2.0
  []
  [right_manual]
    type = DirichletBC
    variable = u_manual
    boundary = right
    value = 1.0
  []
  [left_ad]
    type = ADDirichletBC
    variable = u_ad
    boundary = left
    value = 2.0
  []
  [right_ad]
    type = ADDirichletBC
    variable = u_ad
    boundary = right
    value = 1.0
  []
[]

[Executioner]
  type = Steady
  solve_type = NEWTON
[]

[Outputs]
  exodus = true
  csv = true
[]

[Postprocessors]
  [diff_l2]
    type = NodalL2Norm
    variable = u_manual
    variable2 = u_ad
    execute_on = 'final'
  []
  [max_diff]
    type = NodalMaxValue
    variable = u_manual
    execute_on = 'final'
  []
[]