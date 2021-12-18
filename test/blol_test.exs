defmodule BlolTest do
  use ExUnit.Case
  doctest Blol

  test "gets summoner profile by name" do
    assert Blol.get_summoner_by_name("caitlyn", "br1") == %{
      "accountId" => "EPXpLpLBYnmqfJR-RZkoK_FK6NaV7SgRM5H7iigrV-mdABAKoB3ZcNva",
      "id" => "Su0Vun3PT1aqBjAAA-Fycpgh4vueW0f7Zm-NuRBfQ8oH8unX4STe8-xZtQ",
      "name" => "Caitlyn",
      "profileIconId" => 3542,
      "puuid" => "TPdUJh2qog5cavQueDks0CyFq9AqNM0unj5lZuwoM8YutmmPMbs7D0r7ZcerPrrz8rs_NRuijKOB9Q",
      "revisionDate" => 1628245913000,
      "summonerLevel" => 30
    }
  end

  test "gets summoner matches" do
    assert Blol.get_summoner_matches("caitlyn", "br1", 5) == ["BR1_2298956627", "BR1_2298915613", "BR1_2298934053", "BR1_2298932595", "BR1_2298931318"]
  end

  test "Gets participants from summoner's previous matches and returns a list of maps with name and puuids." do
    assert Blol.get_summoner_participants("caitlyn", "br1", 1) == [
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
  end

  test "Lists summoners participants and monitors them for new matches every minute for 1 hour." do
    assert Blol.monitor_summoner_matches("caitlyn", "br1", 5) == ["Antielialil", "Sanctum Slayer", "Rerdy", "Ehadhodl", "Pernaeliu", "Gaurrars", "Uballodenth", "Jertarun", "Einglent", "Cathesmaurie", "Valak1z", "Inalisha", "the GazettE", "Osarabrit", "Inthermar", "Jezekoand", "Dikoxo", "Yneanereth", "Inanneevi", "uxsna", "Sievadenysal"]
  end
end
