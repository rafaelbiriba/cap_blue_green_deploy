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
