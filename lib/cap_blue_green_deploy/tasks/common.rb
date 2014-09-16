module CapBlueGreenDeploy::Tasks::Common
  def fullpath_by_symlink sym
    capture("if [ -L #{sym} ]; then readlink #{sym}; fi ").strip
  end

  def dirs_inside path
    capture("ls -xt #{path}").split.reverse
  end

  def do_symlink from, to
    run "rm -f #{to} && ln -s #{from} #{to}"
  end

  def remove_dirs dirs
    try_sudo "rm -rf #{dirs}"
  end
end
