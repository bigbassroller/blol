defmodule Blol do

  @riot_api_key System.get_env("RIOT_API_KEY") ||
      raise """
      environment variable RIOT_API_KEY is missing.
      For example: export RIOT_API_KEY="YOUR-RIOT-API-KEY-GOES-HERE".
      Get one here https://developer.riotgames.com/
      """

  @doc """
  Get Summoner by name.

  ## Examples

      iex> Blol.get_summoner_by_name("caitlyn", "br1")
      %{
        "accountId" => "EPXpLpLBYnmqfJR-RZkoK_FK6NaV7SgRM5H7iigrV-mdABAKoB3ZcNva",
        "id" => "Su0Vun3PT1aqBjAAA-Fycpgh4vueW0f7Zm-NuRBfQ8oH8unX4STe8-xZtQ",
        "name" => "Caitlyn",
        "profileIconId" => 3542,
        "puuid" => "TPdUJh2qog5cavQueDks0CyFq9AqNM0unj5lZuwoM8YutmmPMbs7D0r7ZcerPrrz8rs_NRuijKOB9Q",
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
      ["BR1_2298956627", "BR1_2298915613", "BR1_2298934053", "BR1_2298932595", "BR1_2298931318"]

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

      iex> Blol.get_summoner_participants("caitlyn", "br1", 1)
      [
        %{
          matches_played: [],
          name: "Antielialil",
          puuid: "9bkwL40M-4ZE3_HHAdUwftBuTsac3s8tW9zFFRIy_ZEcTs9CAxupfp5QuKCC895HzgEXl1yuyPzy1w"
        },
        %{
          matches_played: [],
          name: "Sanctum Slayer",
          puuid: "qXjYyajWGV33iX3lNnnAPfupBZAYMDVUkiWWxKIveGuX-q2SO2gTeTaHZ1VoZF74Qk5HZ1jebj7cnA"
        },
        %{
          matches_played: [],
          name: "Rerdy",
          puuid: "9ytv_KhGgTewyMf4ImFjXe9bBNHPGjodf1fOTNHO9llTzXgBZv_tegd4iAD4VsLOfsZ5f6U8duBwVw"
        },
        %{
          matches_played: [],
          name: "Ehadhodl",
          puuid: "OFXE2uAnsHOo2oQHSYFdf3bsG9fzowWiu8ykSJCrh_VDyOeEqSjaz1OXpHCfn4DhtdvekXeTJ0TDLQ"
        },
        %{
          matches_played: [],
          name: "Pernaeliu",
          puuid: "TPdUJh2qog5cavQueDks0CyFq9AqNM0unj5lZuwoM8YutmmPMbs7D0r7ZcerPrrz8rs_NRuijKOB9Q"
        },
        %{matches_played: [], name: "Ezreal", puuid: "BOT"},
        %{matches_played: [], name: "Nasus", puuid: "BOT"},
        %{matches_played: [], name: "Ryze", puuid: "BOT"},
        %{matches_played: [], name: "Alistar", puuid: "BOT"},
        %{matches_played: [], name: "Galio", puuid: "BOT"}
      ]
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
  Lists summoners participants and monitors them for new matches every minute for 1 hour.

  ## Examples

      iex> Blol.monitor_summoner_matches("caitlyn", "br1", 5)
      ["Antielialil", "Sanctum Slayer", "Rerdy", "Ehadhodl", "Pernaeliu", "Gaurrars", "Uballodenth", "Jertarun", "Einglent", "Cathesmaurie", "Valak1z", "Inalisha", "the GazettE", "Osarabrit", "Inthermar", "Jezekoand", "Dikoxo", "Yneanereth", "Inanneevi", "uxsna", "Sievadenysal"]     
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