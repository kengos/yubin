# coding: utf-8

require 'spec_helper'

describe Yubin::Katakana do
  it { Yubin::Katakana::VOICED.size.should eql 26 }
  it { Yubin::Katakana::VOICELESS.size.should eql 55 }

  it 'should convert HANKAKU' do
    Yubin::Katakana.to_hankaku('Cambodia カンボジア かんぼじあ').tapp.should eql 'Cambodia ｶﾝﾎﾞｼﾞｱ かんぼじあ'
  end

  it 'should convert ZENKAKU' do
    Yubin::Katakana.to_zenkaku('Cambodia ｶﾝﾎﾞｼﾞｱ かんぼじあ').should eql 'Cambodia カンボジア かんぼじあ'
  end
end