Gem.find_files("cap_blue_green_deploy/tasks/**/*.rb").each { |path| require path }

module CapBlueGreenDeploy::Tasks

  def self.load_into config
    load_libraries config
    load_variables config
    Live.task_load config
    Rollback.task_load config
    Cleanup.task_load config
  end

  def self.load_libraries config
    config.load do
      extend Live
      extend Rollback
      extend Cleanup
    end
  end

  def self.load_variables config
    config.load do
      _cset :keep_releases, 5
    end
  end
end
