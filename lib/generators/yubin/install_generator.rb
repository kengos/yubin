# coding: utf-8

module Yubin
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Copy Yubin json files"
      source_root File.expand_path('../../../../vendor/assets/javascripts/yubin', __FILE__)

      def copy_initializers
        FileUtils.cp_r File.expand_path('../../../../vendor/assets/javascripts/yubin', __FILE__), 'app/assets/javascripts/'
      end

    end
  end
end