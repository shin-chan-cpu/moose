#include "RedisValueFunction.h"
#include "InputParameters.h"
#include "MooseError.h"

registerMooseObject("redis_appApp", RedisValueFunction);

InputParameters
RedisValueFunction::validParams()
{
  InputParameters params = Function::validParams();
  params.addParam<std::string>("key", "moose:in", "Redis key to read");
  params.addParam<std::string>("host", "127.0.0.1", "Redis server host");
  params.addParam<int>("port", 6379, "Redis server port");
  return params;
}

RedisValueFunction::RedisValueFunction(const InputParameters & params)
  : Function(params),
    _key(getParam<std::string>("key")),
    _host(getParam<std::string>("host")),
    _port(getParam<int>("port")),
    _val(0.0)
{
  redisContext * ctx = redisConnect(_host.c_str(), _port);
  if (!ctx || ctx->err)
    mooseError("Failed to connect to Redis at ", _host, ":", _port);
  redisReply * reply = (redisReply *)redisCommand(ctx, "GET %s", _key.c_str());
  if (reply && reply->type == REDIS_REPLY_STRING)
    _val = std::atof(reply->str);
  if (reply)
    freeReplyObject(reply);
  redisFree(ctx);
}

Real
RedisValueFunction::value(Real /*t*/, const Point & /*p*/) const
{
  return _val;
}
