# coding: utf-8

module Yubin
  class Dictionary
    require 'net/http'
    require 'uri'
    require 'zip/zip'
    require 'csv'
    require 'json'
    require 'yaml'

    ZIP_CODE_INDEX = 2
    PREFECTURE_CODE_INDEX = 0
    PREFECTURE_NAME_INDEX = 6
    PREFECTURE_NAME_KANA_INDEX = 3
    CITY_NAME_INDEX = 7
    CITY_NAME_KANA_INDEX = 4
    OTHERS_INDEX = 8
    OTHERS_KANA_INDEX = 5
    IGNORE_WORDS = %w(以下に掲載がない場合)
    IGNORE_WORDS_KANA = %w(イカニケイサイガナイバアイ)

    class << self
      def generate(uri, output_dir)
        zipfile = self.download(uri, output_dir)
        csvfile = self.unzip(zipfile, output_dir)
        self.generate_yaml(csvfile, output_dir + '/yaml')
        self.generate_json(output_dir + '/yaml', output_dir + '/json')
      end

      def download(uri, output_dir)
        output = File.join(output_dir, uri.split('/').last)
        FileUtils.mkdir_p(File.dirname(output))
        uri = URI.parse(uri)

        Net::HTTP.start(uri.host, uri.port) do |http|
          req = Net::HTTP::Get.new(uri.request_uri)
          http.request(req) do |response|
            File.open(output, "wb") {|f|
              response.read_body {|data| f.write data}
            }
          end
        end
        output
      end

      def unzip(zipfile, output_dir)
        output = ''
        Zip::ZipFile.open(zipfile) do |zip_file|
          filename = zip_file.first
          output = File.join(output_dir, filename.name.downcase)
          FileUtils.mkdir_p(File.dirname(output))
          zip_file.extract(filename, output)
        end
        output
      end

      def generate_json(input_dir, output_dir)
        Dir::glob(input_dir + "/*.yml").each do |file|
          yaml = YAML.load(File.read(file))
          filename = File.join(output_dir, File.basename(file).gsub('.yml', '.json'))
          FileUtils.mkdir_p(File.dirname(filename))
          File.open(filename, 'w'){|f| f.write JSON.generate(yaml) }
        end
      end

      def generate_yaml(input, output_dir)
        FileUtils.mkdir_p(output_dir)
        datas = {}
        counter = 0
        File.open(input, 'r:Shift_JIS:UTF-8') do |file|
          file.each do |line|
            data = self.parse(CSV.parse(::Yubin::Katakana.to_zenkaku(line)).first)
            filename = data.keys.first[0..2] + '.yml'
            counter += 1
            datas[filename] ||= ''
            datas[filename] << data.to_yaml.gsub("---\n", '')
            if counter == 5000
              write_to_yaml(datas, output_dir)
              counter = 0
              datas = {}
            end
          end
        end
        write_to_yaml(datas, output_dir)
      end

      def parse(data = [])
        zipcode = data[ZIP_CODE_INDEX]
        prefecture_code = data[PREFECTURE_CODE_INDEX][0..1].to_i
        prefecture = data[PREFECTURE_NAME_INDEX]
        prefecture_kana = data[PREFECTURE_NAME_KANA_INDEX]
        city = data[CITY_NAME_INDEX]
        city_kana = data[CITY_NAME_KANA_INDEX]
        others = data[OTHERS_INDEX]
        others_kana = data[OTHERS_KANA_INDEX]

        IGNORE_WORDS.each do |f|
          others = '' if f == others
        end

        IGNORE_WORDS_KANA.each do |f|
          others_kana = '' if f == others_kana
        end

        {zipcode.to_s => [prefecture_code, prefecture, prefecture_kana, city, city_kana, others, others_kana]}
      end

      private
      def write_to_yaml(datas, output_dir)
        datas.each_pair do |filename, str|
          File.open(File.join(output_dir, filename), "a"){|f| f.write str}
        end
      end
    end
  end
end