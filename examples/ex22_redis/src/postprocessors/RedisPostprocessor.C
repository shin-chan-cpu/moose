#include "RedisPostprocessor.h"
#include "InputParameters.h"
#include "MooseError.h"

registerMooseObject("redis_appApp", RedisPostprocessor);

InputParameters
RedisPostprocessor::validParams()
{
  InputParameters params = GeneralPostprocessor::validParams();
  params.addRequiredParam<PostprocessorName>("source", "Postprocessor providing the value to send");
  params.addParam<std::string>("key", "moose:pp", "Redis key to set");
  params.addParam<std::string>("host", "127.0.0.1", "Redis server host");
  params.addParam<int>("port", 6379, "Redis server port");
  return params;
}

RedisPostprocessor::RedisPostprocessor(const InputParameters & params)
  : GeneralPostprocessor(params),
    _source(getPostprocessorValue("source")),
    _key(getParam<std::string>("key")),
    _host(getParam<std::string>("host")),
    _port(getParam<int>("port")),
    _value(0.0),
    _ctx(nullptr)
{
}

void
RedisPostprocessor::initialize()
{
  _ctx = redisConnect(_host.c_str(), _port);
  if (!_ctx || _ctx->err)
    mooseError("Failed to connect to Redis at ", _host, ":", _port);
}

void
RedisPostprocessor::execute()
{
  _value = _source;
}

void
RedisPostprocessor::finalize()
{
  if (!_ctx)
    return;
  redisReply * reply = (redisReply *)redisCommand(_ctx, "SET %s %f", _key.c_str(), _value);
  if (reply)
    freeReplyObject(reply);
  redisFree(_ctx);
  _ctx = nullptr;
}
