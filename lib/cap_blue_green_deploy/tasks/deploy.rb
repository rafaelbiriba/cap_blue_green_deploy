module CapBlueGreenDeploy::Tasks::Deploy
  def self.task_load config
    config.load do
      namespace :deploy do
        namespace :blue_green do
          desc "Deploy your project to pre environment"
          task :pre, :roles => :app, :except => { :no_release => true } {}
        end
      end

      after "deploy:blue_green:pre", "deploy"
    end
  end
end
