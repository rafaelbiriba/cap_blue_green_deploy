module CapBlueGreenDeploy::Tasks::Common
  def fullpath_by_symlink sym
    capture("if [ -L #{sym} ]; then readlink #{sym}; fi ").strip
  end

  def dirs_inside path
    Dir.foreach(path).select {|f| !File.directory? f}
  end

  def do_symlink from, to
    run "rm -f #{to} && ln -s #{from} #{to}"
  end
end
