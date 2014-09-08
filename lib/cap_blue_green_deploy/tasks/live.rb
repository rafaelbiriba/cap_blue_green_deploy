module CapBlueGreenDeploy::Tasks::Live
  def live_task_run
    current_live = capture("if [ -L #{deploy_to}/current_live ]; then readlink #{deploy_to}/current_live; fi ").strip
    run "rm -f #{deploy_to}/previous_live && ln -s #{current_live} #{deploy_to}/previous_live" unless current_live.empty?
    run "rm -f #{deploy_to}/current_live && ln -s #{current_release} #{deploy_to}/current_live"
    deploy.cleanup
  end

  def self.task_load config
    config.load do
      namespace :deploy do
        namespace :blue_green do
          desc "Make the current app live"
          task :live, :roles => :app, :except => { :no_release => true } { live_task_run }
        end
      end
    end
  end
end
