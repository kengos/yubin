# coding: utf-8

module Yubin
  class JsonDictionary
    require 'net/http'
    require 'uri'
    require 'zip/zip'
    require 'csv'
    require 'json'

    ZIP_CODE_INDEX = 2
    PREFECTURE_NAME_INDEX = 6
    PREFECTURE_NAME_KANA_INDEX = 3
    CITY_NAME_INDEX = 7
    CITY_NAME_KANA_INDEX = 4
    OTHERS_INDEX = 8
    OTHERS_KANA_INDEX = 5
    IGNORE_WORDS = %w(以下に掲載がない場合)
    IGNORE_WORDS_KANA = %w(ｲｶﾆｹｲｻｲｶﾞﾅｲﾊﾞｱｲ)

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

      def generate(input_dir, output_dir)
      end

      def generate_tmpfile(input, destination)
        CSV.foreach(input, 'r:Shift_JIS:UTF-8') do |row|
          data = self.parse(row)
          filename = File.join(destination, data.keys.first[0..2] + ".txt")
          FileUtils.mkdir_p(File.dirname(filename))
          File.open(filename, "a") {|f| f.write JSON.generate(data) + "\n" }
        end
      end

      def parse(data = [])
        zipcode = data[ZIP_CODE_INDEX]
        prefecture = data[PREFECTURE_NAME_INDEX]
        prefecture_kana = ::Yubin::Katakana.to_zenkaku(data[PREFECTURE_NAME_KANA_INDEX])
        city = data[CITY_NAME_INDEX]
        city_kana = ::Yubin::Katakana.to_zenkaku(data[CITY_NAME_KANA_INDEX])
        others = data[OTHERS_INDEX]
        others_kana = data[OTHERS_KANA_INDEX]

        IGNORE_WORDS.each do |f|
          others = '' if f == others
        end

        IGNORE_WORDS_KANA.each do |f|
          others_kana = '' if f == others_kana
        end
        others_kana = ::Yubin::Katakana.to_zenkaku(others_kana) unless others_kana == ''
        {zipcode => [prefecture, prefecture_kana, city, city_kana, others, others_kana]}
        # "\"#{zipcode}\":[\"#{prefecture}\",\"#{prefecture_kana}\",\"#{city}\",\"#{city_kana}\",\"#{others}\",\"#{others_kana}\"]"
      end
    end
  end
end