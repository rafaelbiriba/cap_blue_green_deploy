require 'spec_helper'

describe CapBlueGreenDeploy::Tasks::Common do

  class TestClass
    extend CapBlueGreenDeploy::Tasks::Common
  end

  subject do
    TestClass.new
  end

  describe "#fullpath_by_symlink" do
    let :link do
      "link"
    end

    it "should return fullpath if symlink exists" do
      fullpath = "fullpath"
      allow(File).to receive(:exists?).with(link).and_return(true)
      expect(File).to receive(:readlink).with(link).and_return(fullpath)
      expect(TestClass.fullpath_by_symlink(link)).to eq fullpath
    end

    it "should return blank if symlink not exists" do
      allow(File).to receive(:exists?).with(link).and_return(false)
      expect(File).to_not receive(:readlink).with(link)
      expect(TestClass.fullpath_by_symlink(link)).to eq ""
    end
  end
end
