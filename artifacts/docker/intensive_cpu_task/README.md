# Example CPU Intensive application 

This small app spawns a web server that has only one endpoint:

GET /fibo/<N>

For every correct request it calculates the fibo number for N.

It listens on the port 8080 of the container.

## Developers

1. Clone the repo

2. Init the environment:

```bash
make init
``

3. Run the app
```bash
make dev
```
