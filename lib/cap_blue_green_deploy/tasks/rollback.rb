module CapBlueGreenDeploy::Tasks::Rollback
  def rollback_task_run
    previous_live = capture("if [ -L #{deploy_to}/previous_live ]; then readlink #{deploy_to}/previous_live; fi ").strip
    unless previous_live.empty?
      run "rm -f #{deploy_to}/current_live && ln -s #{previous_live} #{deploy_to}/current_live"
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
