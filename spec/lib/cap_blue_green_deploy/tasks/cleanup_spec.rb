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
