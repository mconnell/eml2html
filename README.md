# eml2html

## Development

The app is containerised, and there is a `docker-compose.yml` for convenience.

Install Docker (work that bit out yourself), and then from the root directory of this app run:

```sh
docker compose up --build
```

The app should respond to http://localhost:5678/up

## Testing

There is a default rake task to run the specs. Simply run:

```sh
rake
```
