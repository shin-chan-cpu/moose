# Steady-state reaction-diffusion problem
# Solves: -∇·(∇u) + α u = 0 with Dirichlet BCs
# Demonstrates both manual and AD reaction kernels

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 10
  ny = 10
  xmin = 0
  xmax = 1
  ymin = 0
  ymax = 1
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
  # Manual Jacobian implementation
  [diff_manual]
    type = Diffusion
    variable = u_manual
  []
  [reaction_manual]
    type = DemoReaction
    variable = u_manual
    reaction_rate = 2.5
  []

  # AD implementation
  [diff_ad]
    type = ADDiffusion
    variable = u_ad
  []
  [reaction_ad]
    type = ADDemoReaction
    variable = u_ad
    reaction_rate = 2.5
  []
[]

[BCs]
  [left_manual]
    type = DirichletBC
    variable = u_manual
    boundary = left
    value = 1.0
  []
  [right_manual]
    type = DirichletBC
    variable = u_manual
    boundary = right
    value = 0.0
  []
  [left_ad]
    type = ADDirichletBC
    variable = u_ad
    boundary = left
    value = 1.0
  []
  [right_ad]
    type = ADDirichletBC
    variable = u_ad
    boundary = right
    value = 0.0
  []
[]

[Executioner]
  type = Steady
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
[]

[Outputs]
  exodus = true
  csv = true
[]

[Postprocessors]
  [diff_manual_ad]
    type = NodalL2Norm
    variable = u_manual
    variable2 = u_ad
    execute_on = 'final'
  []
  [max_manual]
    type = NodalMaxValue
    variable = u_manual
    execute_on = 'final'
  []
  [max_ad]
    type = NodalMaxValue
    variable = u_ad
    execute_on = 'final'
  []
[]