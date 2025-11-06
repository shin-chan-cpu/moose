//* This file is part of the MOOSE framework
//* https://mooseframework.inl.gov
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "ADDemoReaction.h"

registerMooseObject("MooseTestApp", ADDemoReaction);

InputParameters
ADDemoReaction::validParams()
{
  InputParameters params = ADKernel::validParams();
  params.addClassDescription("AD demo reaction kernel implementing R(u) = α u with automatic differentiation");
  params.addParam<Real>("reaction_rate", 1.0, "Reaction rate coefficient α");
  params.declareControllable("reaction_rate");
  return params;
}

ADDemoReaction::ADDemoReaction(const InputParameters & parameters)
  : ADKernel(parameters), _reaction_rate(getParam<Real>("reaction_rate"))
{
}

ADReal
ADDemoReaction::computeQpResidual()
{
  // R(u) = α u, weak form: (ψ_i, α u_h)
  // AD automatically computes Jacobian: ∂R/∂u_j = α φ_j
  return _test[_i][_qp] * _reaction_rate * _u[_qp];
}