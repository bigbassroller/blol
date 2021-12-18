use Mix.Config

# Configures the endpoint
config :blol,
  riot_api_key: System.get_env("RIOT_API_KEY") ||
      raise """
      environment variable RIOT_API_KEY is missing.
      For example: "RGAPI-f21a6b8d-7df4-464f-a4de-c880466abbc3".
      Get one here https://developer.riotgames.com/
      """
