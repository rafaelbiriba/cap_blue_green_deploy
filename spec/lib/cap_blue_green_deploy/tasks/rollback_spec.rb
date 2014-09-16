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
