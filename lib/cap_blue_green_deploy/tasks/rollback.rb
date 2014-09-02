module CapBlueGreenDeploy::Tasks::Rollback
  def rollback_task_run
    previous_live = capture("if [ -L #{deploy_to}/previous_live ]; then readlink #{deploy_to}/previous_live; fi ").strip
    unless previous_live.empty?
      run "rm -f #{deploy_to}/current_live && ln -s #{previous_live} #{deploy_to}/current_live"
    else
      logger.important "no old release to rollback"
    end
  end
end
