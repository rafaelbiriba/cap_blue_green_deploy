require 'spec_helper'

describe CapBlueGreenDeploy::Tasks do
  subject do
    CapBlueGreenDeploy::Tasks
  end

  before do
    @config = double("config")
    allow(@config).to receive(:load) { |&arg| arg.call }
  end

  describe ".load_into" do
    before do
      allow(subject).to receive(:load_libraries)
      allow(subject).to receive(:load_variables)
      allow(subject::Live).to receive(:task_load)
      allow(subject::Rollback).to receive(:task_load)
      allow(subject::Cleanup).to receive(:task_load)
      allow(subject::Deploy).to receive(:task_load)
    end

    after do
      subject.load_into @config
    end

    it "should call load_libraries" do
      expect(subject).to receive(:load_libraries).with(@config)
    end

    it "should call load_variables" do
      expect(subject).to receive(:load_variables).with(@config)
    end

    it "should call Live.task_load" do
      expect(subject::Live).to receive(:task_load).with(@config)
    end

    it "should call Rollback.task_load" do
      expect(subject::Rollback).to receive(:task_load).with(@config)
    end

    it "should call Cleanup.task_load" do
      expect(subject::Cleanup).to receive(:task_load).with(@config)
    end

    it "should call Cleanup.task_load" do
      expect(subject::Deploy).to receive(:task_load).with(@config)
    end
  end

  describe ".load_libraries" do
    module CapBlueGreenDeploy::Tasks::Live
      def test_live; end
    end

    module CapBlueGreenDeploy::Tasks::Rollback
      def test_rollback; end
    end

    module CapBlueGreenDeploy::Tasks::Cleanup
      def test_cleanup; end
    end

    module CapBlueGreenDeploy::Tasks::Common
      def test_common; end
    end

    module CapBlueGreenDeploy::Tasks::Deploy
      def test_deploy; end
    end

    before do
      subject.load_libraries @config
    end

    it "should load live tasks" do
      expect(subject).to respond_to :test_live
    end

    it "should load rollback tasks" do
      expect(subject).to respond_to :test_rollback
    end

    it "should load cleanup tasks" do
      expect(subject).to respond_to :test_cleanup
    end

    it "should load common tasks" do
      expect(subject).to respond_to :test_common
    end

    it "should load common deploy" do
      expect(subject).to respond_to :test_deploy
    end
  end

  describe ".load_variables" do
    before do
      allow(subject).to receive(:_cset)
      allow(subject).to receive(:deploy_to).and_return(deploy_to)
    end

    let :deploy_to do
      "/home"
    end

    it "should set keep_releases variable" do
      expect(subject).to receive(:_cset).with(:keep_releases) do |&arg|
       expect(arg.call).to eql 5
      end
      subject.load_variables @config
    end

    it "should set blue_green_live_dir variable" do
      expect(subject).to receive(:_cset).with(:blue_green_live_dir) do |&arg|
       expect(arg.call).to eql "#{deploy_to}/current_live"
      end
      subject.load_variables @config
    end

    it "should set blue_green_previous_dir variable" do
      expect(subject).to receive(:_cset).with(:blue_green_previous_dir) do |&arg|
       expect(arg.call).to eql "#{deploy_to}/previous_live"
      end
      subject.load_variables @config
    end
  end
end
