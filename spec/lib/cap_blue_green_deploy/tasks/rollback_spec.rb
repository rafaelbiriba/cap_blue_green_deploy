require 'spec_helper'

describe CapBlueGreenDeploy::Tasks::Rollback do

  class TestClass
    include CapBlueGreenDeploy::Tasks::Rollback
  end

  subject do
    TestClass.new
  end

  before do
    @config = double("config")
    allow(@config).to receive(:load) { |&arg| arg.call }
  end

  describe "#rollback_task_run" do
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
    end

    it "should create current live symlink linking to rollback release if exists" do
      previous_live = "link"
      allow(subject).to receive(:fullpath_by_symlink).with(previous_path).and_return(previous_live)
      expect(subject).to receive(:do_symlink).with(previous_live, live_path)
      subject.rollback_task_run
    end

    it "should log if no rollback releases was found" do
      logger = Object
      allow(subject).to receive(:logger).and_return(logger)
      expect(logger).to receive(:important).with("no old release to rollback")
      subject.rollback_task_run
    end
  end

  describe ".task_load" do
    let :subject do
      CapBlueGreenDeploy::Tasks::Rollback
    end

    before do
      allow(subject).to receive(:namespace)
      allow(subject).to receive(:desc)
      allow(subject).to receive(:task)
    end

    context "capistrano blue green rollback task" do
      before do
        expect(subject).to receive(:namespace).with(:deploy) { |&arg| arg.call }
        expect(subject).to receive(:namespace).with(:blue_green) { |&arg| arg.call }
      end

      it "should define rollback task description" do
        expect(subject).to receive(:desc).with("Rollback to the previous live release")
        subject.task_load(@config)
      end

      it "should set rollback task action" do
        expect(subject).to receive(:task).with(:rollback, roles: :app, except: { no_release: true }) { |&arg| arg.call }
        expect(subject).to receive(:rollback_task_run)
        subject.task_load(@config)
      end
    end
  end
end
