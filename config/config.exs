# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configures the endpoint
config :blol,
  riot_api_key: System.get_env("RIOT_API_KEY") ||
      raise """
      environment variable RIOT_API_KEY is missing.
      For example: "RGAPI-f21a6b8d-7df4-464f-a4de-c880466abbc3".
      Get one here https://developer.riotgames.com/
      """

# import_config "#{config_env()}.exs"