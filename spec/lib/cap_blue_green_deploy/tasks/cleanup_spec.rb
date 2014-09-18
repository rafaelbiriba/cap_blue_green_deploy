require 'spec_helper'

describe CapBlueGreenDeploy::Tasks::Cleanup do

  class TestClass
    include CapBlueGreenDeploy::Tasks::Cleanup
  end

  subject do
    TestClass.new
  end

  before do
    @config = double("config")
    allow(@config).to receive(:load) { |&arg| arg.call }
  end

  describe "#local_releases_fullpath" do
    let :local_releases do
      ["1", "2", "3"]
    end

    let :releases_path do
      "teste"
    end

    before do
      allow(subject).to receive(:local_releases).and_return(local_releases)
      allow(subject).to receive(:releases_path).and_return(releases_path)
    end

    it "should return full path of local_releases filtering keep_releases" do
      allow(subject).to receive(:keep_releases).and_return(1)
      expect(subject.local_releases_fullpath).to eq("#{releases_path}/1 #{releases_path}/2")
    end

    it "should empty if keep_releases value is greater than local_releases" do
      allow(subject).to receive(:keep_releases).and_return(4)
      expect(subject.local_releases_fullpath).to eq("")
    end
  end

  describe "#filter_local_releases!" do
    let :live_path do
      "live_path"
    end

    let :previous_path do
      "previous_path"
    end

    before do
      allow(subject).to receive(:fullpath_by_symlink).and_return("")
      allow(subject).to receive(:blue_green_live_path).and_return(live_path)
      allow(subject).to receive(:blue_green_previous_path).and_return(previous_path)
    end

    it "should remove current_live release from local releases list" do
      expect(subject).to receive(:fullpath_by_symlink).with(live_path).and_return(live_path)
      subject.instance_variable_set(:@local_releases, [live_path, "teste"])
      expect(subject.filter_local_releases!).to eq ["teste"]
      expect(subject.instance_variable_get(:@local_releases)).to eq ["teste"]
    end

    it "should remove previous_live release from local releases list" do
      expect(subject).to receive(:fullpath_by_symlink).with(previous_path).and_return(previous_path)
      subject.instance_variable_set(:@local_releases, [previous_path, "teste"])
      expect(subject.filter_local_releases!).to eq ["teste"]
      expect(subject.instance_variable_get(:@local_releases)).to eq ["teste"]
    end
  end

  describe "#local_releases" do
    it "should return fir list inside a path" do
      path = "/path"
      dirs = ["dir1", "dir2"]
      allow(subject).to receive(:releases_path).and_return(path)
      expect(subject).to receive(:dirs_inside).with(path).and_return(dirs)
      expect(subject.local_releases).to eq dirs
    end
  end

  describe ".task_load" do
    let :subject do
      CapBlueGreenDeploy::Tasks::Cleanup
    end

    before do
      allow(subject).to receive(:namespace)
      allow(subject).to receive(:desc)
      allow(subject).to receive(:task)
      allow(subject).to receive(:after)
    end

    context "capistrano default cleanup task" do
      before do
        allow(subject).to receive(:blue_green)
        expect(subject).to receive(:namespace).with(:deploy) { |&arg| arg.call }
      end

      it "should define default cleanup task description" do
        expect(subject).to receive(:desc).with("Clean up old releases")
        subject.task_load(@config)
      end

      it "should set default cleanup task action" do
        expect(subject).to receive(:task) { |&arg| arg.call }
        expect(subject).to receive(:cleanup_task_run)
        subject.task_load(@config)
      end
    end

    context "capistrano blue green cleanup task" do
      before do
        expect(subject).to receive(:namespace).with(:deploy) { |&arg| arg.call }
        expect(subject).to receive(:namespace).with(:blue_green) { |&arg| arg.call }
      end

      it "should set live task action" do
        expect(subject).to receive(:task).with(:cleanup, :except => { :no_release => true }) { |&arg| arg.call }
        expect(subject).to receive(:cleanup_task_run)
        subject.task_load(@config)
      end
    end
  end
end
