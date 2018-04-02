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


Usefull commands:

  * Install dependencies with `mix deps.get`
  * Migrate your database with `mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Return to the root of the project `cd ..`
  * In the root of the project start Phoenix endpoint with `iex -S mix phx.server`

