require 'spec_helper'

describe CapBlueGreenDeploy::Tasks::Common do

  class TestClass
    include CapBlueGreenDeploy::Tasks::Common
  end

  subject do
    TestClass.new
  end

  describe "#fullpath_by_symlink" do
    it "should return fullpath of symlink" do
      fullpath = "fullpath"
      expect(subject).to receive(:capture).with("if [ -L #{fullpath} ]; then readlink #{fullpath}; fi ").and_return(fullpath + " ")
      expect(subject.fullpath_by_symlink(fullpath)).to eq fullpath
    end
  end

  describe "#dirs_inside" do
    it "should return dirs name inside of symlink" do
      path = "path"
      dirs = ["teste1", "teste2"]
      expect(subject).to receive(:capture).with("ls -xt #{path}").and_return(dirs.join(" "))
      expect(subject.dirs_inside(path)).to eq dirs.reverse
    end
  end

  describe "#do_symlink" do
    it "should create new symlink" do
      from = "path1"
      to = "path2"
      expect(subject).to receive(:run).with("rm -f #{to} && ln -s #{from} #{to}")
      subject.do_symlink(from, to)
    end
  end

  describe "#remove_dirs" do
    it "should remove dirs" do
      dirs = "teste1 teste2"
      expect(subject).to receive(:try_sudo).with("rm -rf #{dirs}")
      subject.remove_dirs(dirs)
    end
  end
end
