# continuous-curl-runner

A simple runner to execute curl requests from a list of possible requests

# Usage

Provide the following ENV vars:
 - REQUESTS_INTERVAL - The interval in seconds between curl requests (type: number, default: 5)
 - REQUESTS_SELECTION - The type of request selection from the possible list of requests (type: string, default: random)
   - possible values: random, all
 - REQUESTS_JSON - The list of requests in JSON format (type: string/json, default: "[]")
   - For sample request json format, see [sample-requests.json](./sample-requests.json)

# Build the image

```
docker-compose build
```

# Run using Docker-compose

```
REQUESTS_JSON=$(cat sample-requests.json) docker-compose up  
```