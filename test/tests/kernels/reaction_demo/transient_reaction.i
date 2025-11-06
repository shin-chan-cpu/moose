# Transient reaction-diffusion problem
# Solves: ∂u/∂t - ∇·(∇u) + α u = 0 with Dirichlet BCs
# Demonstrates time integration with both manual and AD reaction kernels

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 8
  ny = 8
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

[ICs]
  [ic_manual]
    type = ConstantIC
    variable = u_manual
    value = 0.0
  []
  [ic_ad]
    type = ConstantIC
    variable = u_ad
    value = 0.0
  []
[]

[Kernels]
  # Manual Jacobian implementation
  [time_manual]
    type = TimeDerivative
    variable = u_manual
  []
  [diff_manual]
    type = Diffusion
    variable = u_manual
  []
  [reaction_manual]
    type = DemoReaction
    variable = u_manual
    reaction_rate = 1.5
  []

  # AD implementation
  [time_ad]
    type = ADTimeDerivative
    variable = u_ad
  []
  [diff_ad]
    type = ADDiffusion
    variable = u_ad
  []
  [reaction_ad]
    type = ADDemoReaction
    variable = u_ad
    reaction_rate = 1.5
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
  type = Transient
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  start_time = 0.0
  end_time = 2.0
  dt = 0.1
[]

[Outputs]
  exodus = true
  csv = true
  time_step_interval = 5
[]

[Postprocessors]
  [diff_manual_ad]
    type = NodalL2Norm
    variable = u_manual
    variable2 = u_ad
    execute_on = 'TIMESTEP_END'
  []
  [avg_manual]
    type = ElementAverageValue
    variable = u_manual
    execute_on = 'TIMESTEP_END'
  []
  [avg_ad]
    type = ElementAverageValue
    variable = u_ad
    execute_on = 'TIMESTEP_END'
  []
[]