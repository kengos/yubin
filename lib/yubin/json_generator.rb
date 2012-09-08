# coding: utf-8

module Yubin
  class JsonGenerator
    require 'net/http'
    require 'uri'
    require 'zip/zip'
    require 'csv'

    class << self
      def run
      end

      def download(uri, destination)
        FileUtils.mkdir_p(File.dirname(destination))
        uri = URI.parse(uri)
        Net::HTTP.start(uri.host, uri.port) do |http|
          req = Net::HTTP::Get.new(uri.request_uri)
          http.request(req) do |response|
            File.open(destination, "wb") {|f|
              response.read_body {|data| f.write data}
            }
          end
        end
      end

      def unzip(filename, destination)
        Zip::ZipFile.open(filename) do |zip_file|
          zip_file.each { |f|
            f_path = File.join(destination, f.name.downcase)
            FileUtils.mkdir_p(File.dirname(f_path))
            zip_file.extract(f, f_path) unless File.exist?(f_path)
          }
        end
      end

      def generate(filename)
        CSV.foreach(filename, 'r:Shift_JIS:UTF-8') do |csv|
        end
      end
    end
  end
end