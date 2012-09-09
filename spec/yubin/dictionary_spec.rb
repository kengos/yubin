# coding: utf-8

require 'spec_helper'

describe Yubin::Dictionary do
  let(:output_dir) { TMP_DIR + '/tests' }

  before {
    FileUtils.rm_r(output_dir) if FileTest.exist?(output_dir)
  }

  after {
    FileUtils.rm_r(output_dir) if FileTest.exist?(output_dir)
  }

  describe ".generate" do
    let(:uri) { 'http://www.post.japanpost.jp/zipcode/dl/kogaki/zip/37kagawa.zip' }
    before {
      stub_request(:get, uri).to_return(
        :status => 200,
        :body => lambda {|request| File.new(fixture_path('37kagawa.zip'))}
      )
    }
    let(:expect_files) { %w(760 761 762 763 764 765 766 767 768 769) }
    it do
      Yubin::Dictionary.generate(uri, output_dir)
      expect_files.each do |f|
        FileTest.should be_exist(output_dir + "/yaml/#{f}.yml")
        FileTest.should be_exist(output_dir + "/json/#{f}.json")
      end
    end
  end

  describe ".download" do
    let(:uri) { 'http://www.post.japanpost.jp/zipcode/dl/kogaki/zip/37kagawa.zip' }
    before {
      stub_request(:get, uri).to_return(
        :status => 200,
        :body => lambda {|request| File.new(fixture_path('37kagawa.zip'))}
      )
    }
    it 'should download 37kagawa.zip' do
      output = Yubin::Dictionary.download(uri, output_dir)
      output.should eql File.join(output_dir, '37kagawa.zip')
      FileTest.should be_exist(output)
    end
  end

  describe ".unzip" do
    let(:filename) { fixture_path('37kagawa.zip') }
    it 'should unzip 37kagawa.zip' do
      output = Yubin::Dictionary.unzip(filename, output_dir)
      output.should eql File.join(output_dir, '37kagawa.csv')
      FileTest.should be_exist(output)
    end
  end

  describe ".generate_json" do
    let(:input_dir) { fixture_path('yaml') }
    let(:expect_file) { File.join(output_dir, '760.json') }
    it 'should generate json file from yaml files' do
      Yubin::Dictionary.generate_json(input_dir, output_dir)
      FileTest.should be_exist(expect_file)
      JSON.parse(File.read(expect_file))['7600002'].should == [37, "香川県", "カガワケン", "高松市", "タカマツシ", "茜町", "アカネチョウ"]
    end
  end

  describe ".generate_yaml" do
    let(:filename) { fixture_path('37kagawa.csv') }
    let(:expect_file) { File.join(output_dir, '760.yml') }
    it 'should generate yaml file from csv file' do
      Yubin::Dictionary.generate_yaml(filename, output_dir)
      FileTest.should be_exist(expect_file)
      YAML.load(File.read(expect_file))["7600064"].should == [37, "香川県", "カガワケン", "高松市", "タカマツシ", "朝日新町", "アサヒシンマチ"]
    end
  end

  describe ".parse" do
    context "contains ignore words" do
      let(:data) { ["37201", "760  ", "7600000", "カガワケン", "タカマツシ", "イカニケイサイガナイバアイ", "香川県", "高松市", "以下に掲載がない場合", "0", "0", "0", "0", "0", "0"] }
      it { Yubin::Dictionary.parse(data).should == {"7600000" => [37, '香川県', 'カガワケン', '高松市', 'タカマツシ', '', '']} }
    end

    context "zipcode is integer" do
      let(:data) { ["37201", "760  ", 7600000, "カガワケン", "タカマツシ", "イカニケイサイガナイバアイ", "香川県", "高松市", "以下に掲載がない場合", "0", "0", "0", "0", "0", "0"] }
      it { Yubin::Dictionary.parse(data).should == {"7600000" => [37, '香川県', 'カガワケン', '高松市', 'タカマツシ', '', '']} }
    end
  end
end