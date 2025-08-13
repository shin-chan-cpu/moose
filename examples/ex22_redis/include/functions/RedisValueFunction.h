#pragma once

#include "Function.h"
#include <hiredis/hiredis.h>

class RedisValueFunction : public Function
{
public:
  static InputParameters validParams();
  RedisValueFunction(const InputParameters & params);
  virtual Real value(Real t, const Point & p) const override;

private:
  std::string _key;
  std::string _host;
  int _port;
  Real _val;
};
