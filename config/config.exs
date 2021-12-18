import Config

config :blol,
  riot_api_key: System.get_env("RIOT_API_KEY") ||
      raise """
      environment variable RIOT_API_KEY is missing.
      For example: export RIOT_API_KEY="YOUR-RIOT-API-KEY-GOES-HERE".
      Get one here https://developer.riotgames.com/
      """

# import_config "#{config_env()}.exs"