# Blol

**Description**

Monitors League of Legends summoners participants for new matches. Includes some useful functions for working with the LOL API. See the [hex documentation](https://hexdocs.pm/blol/0.1.0/Blol.html) for more details. 


## Installation

Install via Hex

```elixir
defp deps do
  [
    {:blol, "~> 0.1.0"},
  ]
end
```

Get a Riot API Key from https://developer.riotgames.com/ and set it in your terminal:

```bash
export RIOT_API_KEY="YOUR-RIOT-API-KEY-GOES-HERE"
```

or hard code it inside your config file:
```elixir
config :blol,
  riot_api_key: "YOUR-RIOT-API-KEY-GOES-HERE"
```


## How to use

Open up iex terminal:

```bash
iex -S mix
```

In the iex terminal run the Blol.monitor_summoner_matches/3 command

```bash
Blol.monitor_summoner_matches("cloudlightfellow", "na1", 5)
```

## Screenshot
![Alt text](./screenshot.png?raw=true "Optional Title")

