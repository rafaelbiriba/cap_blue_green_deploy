require 'spec_helper'

describe CapBlueGreenDeploy::Tasks::Live do

  class TestClass
    include CapBlueGreenDeploy::Tasks::Live
  end

  subject do
    TestClass.new
  end

  before do
    @config = double("config")
    allow(@config).to receive(:load) { |&arg| arg.call }
  end

  describe "#live_task_run" do
    let :live_path do
      "live path"
    end

    let :previous_path do
      "previous path"
    end

    let :current_release do
      "current release"
    end

    before do
      allow(subject).to receive(:do_symlink)
      allow(subject).to receive(:fullpath_by_symlink).and_return("")
      allow(subject).to receive(:blue_green_live_path).and_return(live_path)
      allow(subject).to receive(:blue_green_previous_path).and_return(previous_path)
      allow(subject).to receive(:current_release).and_return(current_release)
    end

    it "should create rollback symlink linking to current live release if exists" do
      current_live = "link"
      allow(subject).to receive(:fullpath_by_symlink).with(live_path).and_return(current_live)
      expect(subject).to receive(:do_symlink).with(current_live, previous_path)
      subject.live_task_run
    end

    it "should create current live symlink linking to the new release" do
      expect(subject).to receive(:do_symlink).with(current_release, live_path)
      subject.live_task_run
    end
  end

  describe ".task_load" do
    let :subject do
      CapBlueGreenDeploy::Tasks::Live
    end

    before do
      allow(subject).to receive(:namespace)
      allow(subject).to receive(:desc)
      allow(subject).to receive(:task)
      allow(subject).to receive(:after)
    end

    it "should create callback to run cleanup after live action" do
      expect(subject).to receive(:after).with("deploy:blue_green:live", "deploy:cleanup")
      subject.task_load(@config)
    end

    context "capistrano blue green live task" do
      before do
        expect(subject).to receive(:namespace).with(:deploy) { |&arg| arg.call }
        expect(subject).to receive(:namespace).with(:blue_green) { |&arg| arg.call }
      end

      it "should define live task description" do
        expect(subject).to receive(:desc).with("Make the current app live")
        subject.task_load(@config)
      end

      it "should set live task action" do
        expect(subject).to receive(:task).with(:live, roles: :app, except: { no_release: true }) { |&arg| arg.call }
        expect(subject).to receive(:live_task_run)
        subject.task_load(@config)
      end
    end
  end
end
