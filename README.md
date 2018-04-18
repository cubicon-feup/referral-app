## CI
### Master
[![Build Status](https://travis-ci.org/cubicon-feup/referral-app.svg?branch=master)](https://travis-ci.org/cubicon-feup/referral-app)
### Develop
[![Build Status](https://travis-ci.org/cubicon-feup/referral-app.svg?branch=develop)](https://travis-ci.org/cubicon-feup/referral-app)

## Setup

#### Install docker
https://docs.docker.com/install/

#### Install nanobox
https://docs.nanobox.io/install/

#### Add a local DNS
```
nanobox dns add local phoenix.local
```

#### Run the app 
```
nanobox run iex -S mix phx.server
```

Go to: ``` phoenix.local:4000 ``` to see your app!

## Other commands

#### drop into a Nanobox console
```nanobox run```

#### where elixir is installed,
```elixir -v```

#### your packages are available,
```mix list```

#### and your code is mounted
```ls```

#### exit the console
```exit```

## GENERATING HTML AND JSON

Example:

```
mix phx.gen.html Blog Post posts title:string content:string
```

then run:

```
mix phx.gen.json Blog Post posts title:string content:string --web Api --no-context --no-schema
```

Other example:
```
mix phx.gen.json Users V1.User users date_of_birth:date deleted:boolean email:string:unique name:string password:string picture_path:string priveleges_level:string
```

then:

```
mix phx.gen.json Users User users date_of_birth:date deleted:boolean email:string:unique name:string password:string picture_path:string priveleges_level:string --web Api --no-context --no-schema
```


Usefull commands:

  * Install dependencies with `mix deps.get`
  * Migrate your database with `mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Return to the root of the project `cd ..`
  * In the root of the project start Phoenix endpoint with `iex -S mix phx.server`

