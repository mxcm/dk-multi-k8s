const keys = require('./keys');
const redis = require("redis");

// Create redis client. Try to reconnect every 1000ms.
const redisClient = redis.createClient({
    host: keys.redisHost,
    port: keys.redisPort,
    retry_strategy: () => 1000
});

const sub = redisClient.duplicate();

function fib(index) {
    if(index < 2) return 1;
    return fib(index - 1) + fib(index - 2);
}

// https://github.com/NodeRedis/node_redis#publish--subscribe
sub.on('message', (channel, message) => {
    redisClient.hset('fibVals', message, fib(parseInt(message)));
});
// If a new value is inserted into redis, calculate the value and put into redis.
sub.subscribe('insert');