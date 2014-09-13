module CapBlueGreenDeploy::Tasks::Cleanup

  def cleanup_task_run
    filter_local_releases!
    if keep_releases >= local_releases.length
      logger.important "no old releases to clean up"
    else
      logger.info "keeping #{keep_releases} of #{local_releases.length} deployed releases"
      remove_dirs local_releases_fullpath
    end
  end

  def local_releases_fullpath
    (local_releases - local_releases.last(keep_releases)).map do |release|
      File.join(releases_path, release)
    end.join(" ")
  end

  def filter_local_releases!
    current_live = File.basename fullpath_by_symlink(blue_green_live_path)
    previous_live = File.basename fullpath_by_symlink(blue_green_previous_path)
    local_releases.select! { |release| release != current_live && release != previous_live  }
  end

  def local_releases
    @local_releases ||= dirs_inside(releases_path)
  end

  def self.task_load config
    config.load do
      namespace :deploy do
        task :cleanup do
          blue_green.cleanup
        end

        namespace :blue_green do
          task :cleanup, :except => { :no_release => true } { cleanup_task_run }
        end
      end
    end
  end
end
