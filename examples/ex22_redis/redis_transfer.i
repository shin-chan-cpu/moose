[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 10
[]

[Variables]
  [./u]
  [../]
[]

[Kernels]
  [./diff]
    type = Diffusion
    variable = u
  [../]
[]

[BCs]
  [./left]
    type = DirichletBC
    variable = u
    boundary = left
    value = 0
  [../]
  [./right]
    type = DirichletBC
    variable = u
    boundary = right
    function = redis_in
  [../]
[]

[Functions]
  [./redis_in]
    type = RedisValueFunction
    key = bc
  [../]
[]

[Postprocessors]
  [./avg]
    type = ElementAverageValue
    variable = u
  [../]
  [./to_redis]
    type = RedisPostprocessor
    source = avg
    key = avg
  [../]
[]

[Executioner]
  type = Steady
[]

[Outputs]
  exodus = true
[]
