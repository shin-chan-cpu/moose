# Redis data transfer example

This example shows how a MOOSE-based application can exchange data with a
local Redis database. A custom `RedisValueFunction` reads a boundary
condition from Redis, and a `RedisPostprocessor` writes a computed value
back to Redis.

## Prerequisites
1. Install Redis and the hiredis development library:
   ```bash
   sudo apt-get install redis-server libhiredis-dev
   ```
2. Start a Redis instance and define an input value:
   ```bash
   redis-server --daemonize yes
   redis-cli SET bc 10
   ```

## Build and run
```bash
make            # build the application
./redis_app-opt -i redis_transfer.i
```
After the simulation, the average solution value is stored under the key
`avg`:
```bash
redis-cli GET avg
```
Stop the server with `redis-cli SHUTDOWN` when finished.
