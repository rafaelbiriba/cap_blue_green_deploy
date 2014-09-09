require 'spec_helper'

describe "init.rb" do
  it "should call tasks module init if capistrano instance exists" do
    config = "config"
    allow(Capistrano::Configuration).to receive(:instance).and_return(config)
    expect(CapBlueGreenDeploy::Tasks).to receive(:load_into).with(config)
    load Gem.find_files("cap_blue_green_deploy/init.rb").first
  end

  it "should not call tasks module init if capistrano instance not exists" do
    allow(Capistrano::Configuration).to receive(:instance).and_return(nil)
    expect(CapBlueGreenDeploy::Tasks).to_not receive(:load_into)
    load Gem.find_files("cap_blue_green_deploy/init.rb").first
  end
end
