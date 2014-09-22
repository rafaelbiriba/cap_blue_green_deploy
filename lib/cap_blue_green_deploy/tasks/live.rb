module CapBlueGreenDeploy::Tasks::Live
  def live_task_run
    current_live = fullpath_by_symlink blue_green_live_dir
    do_symlink current_live, blue_green_previous_dir unless current_live.empty?
    do_symlink current_release, blue_green_live_dir
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
