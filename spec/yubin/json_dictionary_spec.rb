# coding: utf-8

require 'spec_helper'

describe Yubin::JsonDictionary do
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
      Yubin::JsonDictionary.download(uri, filename) 
    }
    it { FileTest.exist?(filename).should be_true }
  end

  describe ".unzip" do
    let(:filename) { fixture_path('37kagawa.zip') }
    before {
      FileUtils.rm_r(basepath) if FileTest.exist?(basepath)
      Yubin::JsonDictionary.unzip(filename, basepath)
    }
    it { FileTest.exist?(basepath + '/' + '37kagawa.csv').should be_true }
  end

  describe ".generate_tmpfile" do
    let(:filename) { fixture_path('37kagawa.csv') }
    before {
      Yubin::JsonDictionary.generate_tmpfile(filename, basepath)
    }
    it { FileTest.exist?(basepath + '/' + '760.yml').should be_true }
  end

  describe ".parse" do
    context "" do
      let(:data) { ["37201", "760  ", "7600000", "ｶｶﾞﾜｹﾝ", "ﾀｶﾏﾂｼ", "ｲｶﾆｹｲｻｲｶﾞﾅｲﾊﾞｱｲ", "香川県", "高松市", "以下に掲載がない場合", "0", "0", "0", "0", "0", "0"] }
      it { Yubin::JsonDictionary.parse(data).should == {"7600000" => ['香川県', 'カガワケン', '高松市', 'タカマツシ', '', '']} }
    end
  end
end