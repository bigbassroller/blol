defmodule Blol do

  @riot_api_key Application.get_env(:blol, :riot_api_key)

  @doc """
  Get Summoner by name.

  ## Examples

      iex> Blol.get_summoner_by_name("caitlyn", "br1")
      %{
        "accountId" => "smX0o8Z_BH83ovCdqw0Dp-9Y3Wwo56jaAmR5nAjsfpXn0KJvOqBnQHm4",
        "id" => "oZQlmQJo2GxL3k0_hhA24tyo7QGeSAmMV2ACFjT0WVc3YTBB8Go_LBWJwQ",
        "name" => "Caitlyn",
        "profileIconId" => 3542,
        "puuid" => "SDiyDhiGtOPeCVqoSZFY7UefS-9qhujyYppQYgAASdeeUtYdYE066Aak1SLfOry2XwVYvIW0lUgX7w",
        "revisionDate" => 1628245913000,
        "summonerLevel" => 30
      }

  """
  def get_summoner_by_name(name, region) do
    HTTPoison.get!("https://#{region}.api.riotgames.com/lol/summoner/v4/summoners/by-name/#{name}?api_key=#{@riot_api_key}")
    |> Map.get(:body)
    |> Poison.decode!
  end

  @doc """
  Get Summoner matches.

  ## Examples

      iex> Blol.get_summoner_matches("caitlyn", "br1", 5)
          ["BR1_2298956627", "BR1_2298915613", "BR1_2298934053", "BR1_2298932595",
           "BR1_2298931318"]

  """
  def get_summoner_matches(name, region, limit) do
    puuid = get_summoner_by_name(name, region) |> Map.get("puuid")
  
    HTTPoison.get!("https://americas.api.riotgames.com/lol/match/v5/matches/by-puuid/#{puuid}/ids?start=0&count=#{limit}&api_key=#{@riot_api_key}")
    |> Map.get(:body)
    |> Poison.decode!
  end

  @doc """
  Gets participants from summoner's previous matches and returns a list of maps with name and puuids.

  ## Examples

      iex> Blol.get_summoner_participants("caitlyn", "br1", 5)
      %{
        name: "Antielialil",
        puuid: "9bkwL40M-4ZE3_HHAdUwftBuTsac3s8tW9zFFRIy_ZEcTs9CAxupfp5QuKCC895HzgEXl1yuyPzy1w"
      },
      ...
  """
  def get_summoner_participants(name, region, limit) do
    get_summoner_matches(name, region, limit)
    |> Enum.map(fn match ->
      HTTPoison.get!("https://americas.api.riotgames.com/lol/match/v5/matches/#{match}?api_key=#{@riot_api_key}") 
      |> Map.get(:body)
      |> Poison.decode!
      |> Enum.find_value(fn participants ->  
        elem(participants, 1)
        |> Map.get("participants")
        |> Enum.map(fn participant ->  
          name = Map.get(participant, "summonerName")
          puuid = Map.get(participant, "puuid")
          %{
            puuid: puuid,
            name: name,
            matches_played: []
          }
        end)
      end)
    end)
    |> List.flatten
    |> Enum.uniq
  end

  @doc """
  Montitors summoners participants for new matches for 1 hour.

  ## Examples

      iex> Blol.monitor_summoner_matches("caitlyn", "br1", 5)
      ["Antielialil", "..."]
      Later on...
      "Summoner Vno nameV completed match NA1_4142031064"     
  """
  def monitor_summoner_matches(name, region, limit) do
    summoners = get_summoner_participants(name, region, limit)
    |> Enum.filter(&Map.get(&1, :puuid) !== "BOT")
  
    start_time = System.system_time(:second)
    {:ok, pid} = GenServer.start_link(Blol.Monitor, {start_time, summoners})
  
    :timer.kill_after(3_600_000, pid) # kill after 1 hour (3_600_000)

    summoners
    |> Enum.map(&Map.get(&1, :name))
  end

  @doc false
  def check_summoner_matches(state) do
    limit = 1
    start_time = elem(state, 0)
    summoners = state |> elem(1)

    summoners
    |> Enum.map(fn summoner ->
      puuid = Map.get(summoner, :puuid)
      name = Map.get(summoner, :name)
   
      HTTPoison.get!("https://americas.api.riotgames.com/lol/match/v5/matches/by-puuid/#{puuid}/ids?startTime=#{start_time}&start=0&count=#{limit}&api_key=#{@riot_api_key}")
      |> Map.get(:body)
      |> Poison.decode!
      |> case do
        [] -> update_matches_played(summoners, name, '')

        match_id -> 
          matches_played = update_matches_played(summoners, name, "Summoner #{name} completed match #{match_id}")
          
          Map.get(matches_played, :matches_played)
          |> List.first
          |> IO.inspect()
        
          matches_played
      end
    end)
  end

  defp update_matches_played(summoners, name, msg) do
    Enum.find_value(summoners, fn summoner ->
      if summoner[:name] == name  do
        Map.update!(summoner, :matches_played,  fn matches_played ->  
          [msg  | matches_played]
          |> List.flatten
          |> Enum.uniq
        end)     
      end
    end)
  end
end