//* This file is part of the MOOSE framework
//* https://mooseframework.inl.gov
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "Kernel.h"

/**
 * Demo kernel implementing a simple reaction term R(u) = α u
 * This demonstrates manual Jacobian computation for educational purposes
 */
class DemoReaction : public Kernel
{
public:
  static InputParameters validParams();

  DemoReaction(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual() override;
  virtual Real computeQpJacobian() override;

private:
  /// Reaction rate coefficient α
  const Real & _reaction_rate;
};