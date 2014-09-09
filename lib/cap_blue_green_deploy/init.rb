require "capistrano"

capistrano_instance = Capistrano::Configuration.instance
CapBlueGreenDeploy::Tasks.load_into(capistrano_instance) if capistrano_instance
