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

- Experience with Linux and CLI 


<details>
<summary>1. You will need all the services, we will start by cloning them all</summary>
    <blockquote>

$ mkdir wolke-casa && cd wolke-casa

$ git clone git@github.com:wolke-casa/api.git

$ git clone git@github.com:wolke-casa/bot.git
    </blockquote>
</details>
<br>
<details>
<summary>2. We need to configure and start the API</summary>
    <blockquote>

$ cd api

$ mv .env.example .env
    </blockquote>
    <p>
        Configuration of the API is done via an environment file named `.env` 
        <br>
        <br>
        Edit this as needed and to fit your needs. Each key has a brief description and example.
        <br>
        <br>
        Once configured, we can build and run the API
    </p>
    <blockquote>

$ soonTM
    </blockquote>
</details>
