Capistrano::Configuration.instance(:must_exist).load do

  set :keep_releases, 5 unless exists?(:keep_releases)

  namespace :deploy do
    task :cleanup do
      blue_green.cleanup
    end

    namespace :blue_green do
      desc "Make the current app live"
      task :live, :roles => :app, :except => { :no_release => true } do
        current_live = capture("if [ -L #{deploy_to}/current_live ]; then readlink #{deploy_to}/current_live; fi ").strip
        run "rm -f #{deploy_to}/previous_live && ln -s #{current_live} #{deploy_to}/previous_live" unless current_live.empty?
        run "rm -f #{deploy_to}/current_live && ln -s #{current_release} #{deploy_to}/current_live"
        cleanup
      end

      desc "Rollback to the previous live release"
      task :rollback, :roles => :app, :except => { :no_release => true } do
        previous_live = capture("if [ -L #{deploy_to}/previous_live ]; then readlink #{deploy_to}/previous_live; fi ").strip
        unless previous_live.empty?
          run "rm -f #{deploy_to}/current_live && ln -s #{previous_live} #{deploy_to}/current_live"
        else
          logger.important "no old release to rollback"
        end
      end

      task :cleanup, :except => { :no_release => true } do
        local_releases = capture("ls -xt #{releases_path}").split.reverse

        current_live = capture("readlink #{deploy_to}/current_live | awk -F '/' '{ print $NF }'").strip
        previous_live = capture("readlink #{deploy_to}/previous_live | awk -F '/' '{ print $NF }'").strip
        local_releases.select! { |release| release != current_live && release != previous_live  }

        if keep_releases >= local_releases.length
          logger.important "no old releases to clean up"
        else
          logger.info "keeping #{keep_releases} of #{local_releases.length} deployed releases"
          directories = (local_releases - local_releases.last(keep_releases)).map { |release|
            File.join(releases_path, release) }.join(" ")

          try_sudo "rm -rf #{directories}"
        end
      end
    end
  end
end
