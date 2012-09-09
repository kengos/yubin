# coding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/../yubin')
namespace :yubin do
  desc 'Generate Yubin dictionaries'
  task :generate do
    uri = ENV['URI'] || 'http://www.post.japanpost.jp/zipcode/dl/kogaki/zip/ken_all.zip'
    output_dir = ENV['TO']
    if output_dir.nil?
      puts "Usage: rake yubin:generate TO='./tmp/yubin'"
    else
      ::Yubin::Dictionary.generate(uri, output_dir)
    end
  end
end