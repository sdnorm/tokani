# Tokani

## Development Things

Testing sending and style of emails locally can be viewed at `localhost:3000/letter_opener`

## Git flow

Feature branch off of `main`. Push feature branch and create a pull request. Pull requests will need to be reviewed before merging.

Use `standardrb`, you can run `standardrb --fix` to automatically fix lint issues.

### Running Localy

All Homebrew dependencies are listed in `Brewfile`, so you can install them all at once like this:

```bash
brew bundle install --no-upgrade
```

Then you can start the database servers:

```bash
brew services start postgresql
brew services start redis
```

#### Initial Setup

Run `bin/setup` to install Rubygem and Javascript dependencies. This will also install `foreman` system wide for you and setup your database.

```bash
bin/setup
```

#### Running the app

To run your application, you'll use the `bin/dev` command:

```bash
bin/dev
```

This starts up Overmind (or fallback to Foreman) running the Procfile.dev config.

We've configured this to run the Rails server, CSS bundling, and JS bundling out of the box. You can add background workers like Sidekiq, the Stripe CLI, etc to have them run at the same time.

Here's a couple of useful Overmind commands:

```sh
# Debugging with byebug: connect to the `web` process to be able to input commands:
overmind connect web
# Then disconnect by hitting [Ctrl+B] (or your tmux prefix) and then [D].

# Restart a process without restarting all the other ones:
overmind restart web

# If something goes wrong, you can kill all running processes:
overmind kill

#### Running with Docker Compose

We include a sample Docker Compose configuration that runs Rails, Postgresql, and Redis for you.

Simply run:

`docker-compose up`

Then open <http://localhost:3000>

#### Running with Docker

If you'd like to run Jumpstart Pro with Docker directly, you can run:

```bash
docker build --tag myapp .
docker run -p 3000:3000 myapp
```

If you'd like to use the fullstaq-ruby or other Dockerfile you can specify them as:

```bash
docker build -f ./Dockerfile.fullstaq-ruby .
```
