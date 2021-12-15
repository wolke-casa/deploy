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
$ sudo podman build -t wolke_api:latest .
$ sudo podman run --name wolke_api --rm --network http --pod wolke -d wolke_api:latest
```

Congrats! Now the API should be running.

<br>

3. We need to configure and start the Discord bot

```
$ cd bot

$ mv .env.example .env
```

Configuration of the bot is done via an environment file named `.env` just like the API

Once configured, we can build and run the bot

```
$ sudo podman build -t wolke_bot:latest .
$ sudo podman run --name wolke_bot --rm --network http --pod wolke -d wolke_bot:latest
```

Now the bot and API will be running. Note that the bot needs the API up and running so ensure the API is up so the bot can function properly!
