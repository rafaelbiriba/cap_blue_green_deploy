require 'spec_helper'

describe CapBlueGreenDeploy::Tasks::Deploy do

  class TestClass
    include CapBlueGreenDeploy::Tasks::Deploy
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
      CapBlueGreenDeploy::Tasks::Deploy
    end

    before do
      allow(subject).to receive(:namespace)
      allow(subject).to receive(:desc)
      allow(subject).to receive(:task)
      allow(subject).to receive(:after)
    end

    context "capistrano blue green pre task" do
      before do
        expect(subject).to receive(:namespace).with(:deploy) { |&arg| arg.call }
        expect(subject).to receive(:namespace).with(:blue_green) { |&arg| arg.call }
      end

      it "should define pre task description" do
        expect(subject).to receive(:desc).with("Deploy your project to pre environment")
        subject.task_load(@config)
      end

      it "should set pre task action" do
        expect(subject).to receive(:task).with(:pre, roles: :app, except: { no_release: true })
        subject.task_load(@config)
      end

      it "should create callback to run capistrano deploy after pre action" do
        expect(subject).to receive(:after).with("deploy:blue_green:pre", "deploy")
        subject.task_load(@config)
      end
    end
  end
end
