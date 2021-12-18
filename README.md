# Blol

**Description**

Monitors League of Legends summoners participants for new matches. Includes some useful functions for working with the LOL API. See the [hex documentation](https://hexdocs.pm/blol/0.1.0/Blol.html) for more details. 


## Installation

Install via Hex

```elixir
defp deps do
  [
    {:blol, "~> 0.1.2"},
  ]
end
```

Get a Riot API Key from https://developer.riotgames.com/ and set it in your terminal:

```bash
export RIOT_API_KEY="YOUR-RIOT-API-KEY-GOES-HERE"
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


## FAQ

Q: I am getting something like "{"status", %{"message" => "Forbidden", "status_code" => 403}}"

A: Make sure you exported RIOT_API_KEY variable <u>before </u> going into `iex -S mix` shell. Otherwise, you'll have to `rm -rf deps && rm -rf _build` and restart again with exporting `RIOT_API_KEY` first then going into `iex -S mix` shell. 

Q: After running `Blol.monitor_summoner_matches/3` command, I don't see updates of summoners joining matches.

A: Wait for it. Matches take about a half hour to complete, so it will take about that time to see anything pop up in the terminal. You can also try to find more active users to test the API with here: https://developer.riotgames.com/apis#spectator-v4/GET_getFeaturedGames. 

