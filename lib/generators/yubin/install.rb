# coding: utf-8

module Yubin
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Copy Yubin json files"
      source_root File.expand_path('../../../../vendor/assets/javascripts/yubin', __FILE__)

      def copy_initializers
      end

    end
  end
end