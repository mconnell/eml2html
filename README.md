# eml2html

This is the source code for the website https://eml2html.com.

## Development

The app is containerised, and there is a `docker-compose.yml` for convenience.

Install Docker (work that bit out yourself), and then from the root directory
of this app run:

```sh
docker compose up --build
```

The app should respond to http://localhost:5678/up

## Testing

There is a default rake task to run the specs. Simply run:

```sh
rake
```

## Deployment

The project uses [Kamal](https://kamal-deploy.org) for deployment.

Before you deploy, you'll need to set an `ENV` var `EML_2_HTML_IP_ADDRESS` to
the IP address of the server you are deploying to. Assuming it has been
setup with Kamal, it's simply a case of running:


```sh
kamal deploy
```
