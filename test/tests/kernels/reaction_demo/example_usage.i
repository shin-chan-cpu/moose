# Example usage of the AD Reaction Kernel Demo
# This file demonstrates practical usage patterns
# and can be used as a template for custom problems

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 20
  ny = 20
  xmin = 0
  xmax = 2
  ymin = 0
  ymax = 1
[]

# Problem: First-order reaction in a reactor
# ∂c/∂t = D∇²c - k c + S
# where:
# c = concentration
# D = diffusion coefficient  
# k = reaction rate constant
# S = source term

[Variables]
  [concentration]
    order = FIRST
    family = LAGRANGE
    initial_condition = 0.0
  []
[]

[AuxVariables]
  [reaction_rate]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[AuxKernels]
  [set_reaction_rate]
    type = FunctionAux
    variable = reaction_rate
    function = 'x'  # Spatially varying reaction rate
    execute_on = 'INITIAL TIMESTEP_BEGIN'
  []
[]

[Functions]
  [source_function]
    type = ParsedFunction
    value = 'if(x<0.5, 10.0, 0.0)'  # Source on left half
  []
[]

[Kernels]
  [time_derivative]
    type = ADTimeDerivative
    variable = concentration
  []
  
  [diffusion]
    type = ADDiffusion
    variable = concentration
    coefficient = 0.1  # Diffusion coefficient
  []
  
  [reaction]
    type = ADDemoReaction
    variable = concentration
    reaction_rate = 2.0  # Base reaction rate
  []
  
  [source]
    type = ADBodyForce
    variable = concentration
    function = source_function
  []
[]

[BCs]
  [inlet]
    type = ADDirichletBC
    variable = concentration
    boundary = left
    value = 5.0
  []
  
  [outlet]
    type = ADConvectiveFluxBC
    variable = concentration
    boundary = right
    velocity = 1.0
  []
  
  [walls]
    type = ADNeumannBC
    variable = concentration
    boundary = 'top bottom'
    value = 0.0  # No flux
  []
[]

[Materials]
  [reaction_material]
    type = GenericConstantMaterial
    block = 0
    prop_names = 'k_value D_value'
    prop_values = '2.0 0.1'
  []
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  
  start_time = 0.0
  end_time = 10.0
  dt = 0.1
  dtmin = 1e-6
  dtmax = 0.5
  
  # Automatic time stepping
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.1
    optimal_iterations = 10
    iteration_window = 4
    linear_iteration_ratio = 100
  []
[]

[Outputs]
  exodus = true
  csv = true
  print_linear_residuals = false
  time_step_interval = 10
  
  [console]
    type = Console
    max_rows = 10
  []
[]

[Postprocessors]
  [avg_concentration]
    type = ElementAverageValue
    variable = concentration
    execute_on = 'TIMESTEP_END INITIAL'
  []
  
  [max_concentration]
    type = NodalMaxValue
    variable = concentration
    execute_on = 'TIMESTEP_END INITIAL'
  []
  
  [min_concentration]
    type = NodalMinValue
    variable = concentration
    execute_on = 'TIMESTEP_END INITIAL'
  []
  
  [total_mass]
    type = ElementIntegralVariablePostprocessor
    variable = concentration
    execute_on = 'TIMESTEP_END INITIAL'
  []
  
  [reaction_integral]
    type = ElementIntegralMaterialPostprocessor
    mat_prop = k_value
    variable = concentration
    execute_on = 'TIMESTEP_END INITIAL'
  []
[]

[Problem]
  type = FEProblem
  solve = true
  kernel_coverage_check = true
  material_coverage_check = true
[]