# coding: utf-8

require 'spec_helper'

describe Yubin::JsonGenerator do
  let(:basepath) { TMP_DIR + '/tests' }

  before {
    FileUtils.rm_r(basepath) if FileTest.exist?(basepath)
  }

  after {
    FileUtils.rm_r(basepath) if FileTest.exist?(basepath)
  }

  describe ".download" do
    let(:filename) { basepath + '/' + 'test.zip' }
    let(:uri) { 'http://www.post.japanpost.jp/zipcode/dl/kogaki/zip/37kagawa.zip' }
    before {
      Yubin::JsonGenerator.download(uri, filename) 
    }
    it { FileTest.exist?(filename).should be_true }
  end

  describe ".unzip" do
    let(:filename) { fixture_path('37kagawa.zip') }
    before {
      FileUtils.rm_r(basepath) if FileTest.exist?(basepath)
      Yubin::JsonGenerator.unzip(filename, basepath)
    }
    it { FileTest.exist?(basepath + '/' + '37kagawa.csv').should be_true }
  end
end