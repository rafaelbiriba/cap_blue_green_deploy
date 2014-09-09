module CapBlueGreenDeploy::Tasks::Rollback
  def rollback_task_run
    previous_live = fullpath_by_symlink blue_green_previous_path
    unless previous_live.empty?
      do_symlink previous_live, blue_green_live_path
    else
      logger.important "no old release to rollback"
    end
  end

  def self.task_load config
    config.load do
      namespace :deploy do
        namespace :blue_green do
          desc "Rollback to the previous live release"
          task :rollback, :roles => :app, :except => { :no_release => true } { rollback_task_run }
        end
      end
    end
  end
end
