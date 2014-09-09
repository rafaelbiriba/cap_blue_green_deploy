module CapBlueGreenDeploy::Tasks::Cleanup

  def cleanup_task_run
    local_releases = dirs_inside(releases_path).reverse

    current_live = File.basename fullpath_by_symlink(blue_green_live_path)
    previous_live = File.basename fullpath_by_symlink(blue_green_previous_path)
    local_releases.select! { |release| release != current_live && release != previous_live  }

    if keep_releases >= local_releases.length
      logger.important "no old releases to clean up"
    else
      logger.info "keeping #{keep_releases} of #{local_releases.length} deployed releases"
      directories = (local_releases - local_releases.last(keep_releases)).map do |release|
        File.join(releases_path, release)
      end.join(" ")
      try_sudo "rm -rf #{directories}"
    end
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
