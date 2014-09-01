Capistrano::Configuration.instance(:must_exist).load do

  namespace :deploy do
    namespace :blue_green do

      desc "Make the current app live"
      task :live, :roles => :app, :except => { :no_release => true } do
        current_live = capture("if [ -L #{deploy_to}/current_live ]; then readlink #{deploy_to}/current_live; fi ").strip
        run "rm -f #{deploy_to}/previous_live && ln -s #{current_live} #{deploy_to}/previous_live" unless current_live.empty?
        run "rm -f #{deploy_to}/current_live && ln -s #{current_release} #{deploy_to}/current_live"
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

    end
  end
end
