Gem.find_files("cap_blue_green_deploy/tasks/**/*.rb").each { |path| require path }

module CapBlueGreenDeploy::Tasks
  include Live
  include Rollback
  include Cleanup
end
