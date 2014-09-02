Capistrano::Configuration.instance(:must_exist).load do

  extend CapBlueGreenDeploy::Tasks

  _cset :keep_releases, 5

  namespace :deploy do
    task :cleanup do
      blue_green.cleanup
    end

    namespace :blue_green do
      desc "Make the current app live"
      task :live, :roles => :app, :except => { :no_release => true } { live_task_run }

      desc "Rollback to the previous live release"
      task :rollback, :roles => :app, :except => { :no_release => true } { rollback_task_run }

      task :cleanup, :except => { :no_release => true } { cleanup_task_run }
    end
  end
end
