<div align="center">
    <h1>💻 Wolke Deploy</h1>
    Here you can find instructions on deploying Wolke. These are meant for official development and we don't support selfhosting.
    <br>
    <br>
</div>

# Deploying

To deploy Wolke you'll need

- Podman

- Git

- Nginx container running to act as a reverse proxy...

...youll also need a pod named `wolke` and a network named `http`. All containers will be started in the 
`wolke` pod and they will all use the network `http`

1. You will need all the services so we will start by cloning them all


```sh
$ mkdir wolke-casa && cd wolke-casa

$ git clone git@github.com:wolke-casa/api.git

$ git clone git@github.com:wolke-casa/bot.git
```

<br>

2. We need to configure and start the API

```
$ cd api

$ mv .env.example .env
```

Configuration of the API is done via an environment file named `.env` 

Edit this as needed and to fit your needs. Each key has a brief description and example.

Once configured, we can build and run the API

```
soonTM
```
