# PointsApp
The requirements for this application are located in the `requirement.md` file, in the root of the repo

#### Approach
Given the requirements, we need to use a single GenServer for both reading from the DB and writing to the DB thus leading to a potential bottleneck and degraded performance for the
clients

To avoid this issue, the decision was taken to prioritise user response time rather than data consistency (we are not waiting for all the DB to be updated before serving client
requests). In a real world scenario, this decision would be discussed with PO.

From a technical perspective, PointsServer will handle the serving of client requests and handle business logic. DataUpdater will handle only DB updates. Bear in mind that because the
requirements force us to use a single GenServer retrieving user data, this server can become a bottleneck

- A flow diagram depicting the system can be found here:
[https://swimlanes.io/u/nUSxf_QcO](https://swimlanes.io/u/nUSxf_QcO)
- timer tick interval can be set in an ENV var


#### Setup
Prerequirements:
- Postgresql, Elixir, Erlang
- clone repo
- run `mix setup`
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`
- Now you can visit [`localhost:4000`](http://localhost:4000)  from your browser.

Once the server is up and running, you can use [`localhost:4000/doc#`](http://localhost:4000/doc#) to access the Swagger API doc. This will also provide a way to directly test the
endpoint

#### Run in docker
- clone repo
- `docker-compose up`


#### Running tests
- run `MIX_ENV=test mix test`

#### Performance
Although no performance requirements were specified, we can use `ab` to asses that the server is fact responsive for clients.
For 100 conccurent requests and 10k total requests we get the following numbers.
```
Benchmarking 127.0.0.1 (be patient)
Completed 1000 requests
Completed 2000 requests
Completed 3000 requests
Completed 4000 requests
Completed 5000 requests
Completed 6000 requests
Completed 7000 requests
Completed 8000 requests
Completed 9000 requests
Completed 10000 requests
Finished 10000 requests


Server Software:        Cowboy
Server Hostname:        127.0.0.1
Server Port:            4000

Document Path:          /
Document Length:        240 bytes

Concurrency Level:      100
Time taken for tests:   49.771 seconds
Complete requests:      10000
Failed requests:        1634
   (Connect: 0, Receive: 0, Length: 1634, Exceptions: 0)
Keep-Alive requests:    10000
Total transferred:      4918839 bytes
HTML transferred:       2398839 bytes
Requests per second:    200.92 [#/sec] (mean)
Time per request:       497.714 [ms] (mean)
Time per request:       4.977 [ms] (mean, across all concurrent requests)
Transfer rate:          96.51 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.2      0       3
Processing:    77  496 225.7    439    1640
Waiting:       77  496 225.7    439    1640
Total:         78  496 225.7    439    1640

Percentage of the requests served within a certain time (ms)
  50%    439
  66%    462
  75%    479
  80%    492
  90%    609
  95%   1213
  98%   1377
  99%   1462
 100%   1640 (longest request)
```

#### Improvements
- cleanup code of phoenix generator boilerplate
- add telemetry
- add timer cancelation/reset (or some circuit breaker for DB update job)

