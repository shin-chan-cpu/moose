//* This file is part of the MOOSE framework
//* https://mooseframework.inl.gov
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "DemoReaction.h"

registerMooseObject("MooseTestApp", DemoReaction);

InputParameters
DemoReaction::validParams()
{
  InputParameters params = Kernel::validParams();
  params.addClassDescription("Demo reaction kernel implementing R(u) = α u with manual Jacobian");
  params.addParam<Real>("reaction_rate", 1.0, "Reaction rate coefficient α");
  params.declareControllable("reaction_rate");
  return params;
}

DemoReaction::DemoReaction(const InputParameters & parameters)
  : Kernel(parameters), _reaction_rate(getParam<Real>("reaction_rate"))
{
}

Real
DemoReaction::computeQpResidual()
{
  // R(u) = α u, weak form: (ψ_i, α u_h)
  return _test[_i][_qp] * _reaction_rate * _u[_qp];
}

Real
DemoReaction::computeQpJacobian()
{
  // ∂R/∂u_j = α φ_j, weak form: (ψ_i, α φ_j)
  return _test[_i][_qp] * _reaction_rate * _phi[_j][_qp];
}