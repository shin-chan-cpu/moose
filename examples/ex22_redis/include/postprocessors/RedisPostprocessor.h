#pragma once

#include "GeneralPostprocessor.h"
#include <hiredis/hiredis.h>

class RedisPostprocessor : public GeneralPostprocessor
{
public:
  static InputParameters validParams();
  RedisPostprocessor(const InputParameters & params);
  virtual void initialize() override;
  virtual void execute() override;
  virtual void finalize() override;
  virtual Real getValue() override { return _value; }

private:
  const PostprocessorValue & _source;
  std::string _key;
  std::string _host;
  int _port;
  Real _value;
  redisContext * _ctx;
};
