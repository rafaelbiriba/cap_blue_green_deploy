module CapBlueGreenDeploy::Tasks::Live
  def live_task_run
    current_live = capture("if [ -L #{deploy_to}/current_live ]; then readlink #{deploy_to}/current_live; fi ").strip
    run "rm -f #{deploy_to}/previous_live && ln -s #{current_live} #{deploy_to}/previous_live" unless current_live.empty?
    run "rm -f #{deploy_to}/current_live && ln -s #{current_release} #{deploy_to}/current_live"
    deploy.cleanup
  end
end
