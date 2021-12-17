# Blol

**Description**

Monitors League of Legends summoners participants for new matches. Includes some useful functions for working with the LOL API. See the [hex documentation](./doc/index.html) for more details (view locally, link does not work on github). 


## Installation

Get a Riot API Key from https://developer.riotgames.com/ and set it in your terminal:
```bash
export RIOT_API_KEY="RGAPI-f21a6b8d-7df4-464f-a4de-c880466abbc3"
``` 
or hard code it inside `blol/config/config.exs`

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

