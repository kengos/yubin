# Yubin

Japanese:

  郵便事業株式会社よりダウンロードした郵便番号辞書を元にYAML, JSONファイルを生成します。

  YAMLファイル, JSONファイルは郵便番号の先頭3桁 + '.yml' or '.json'で生成されます。

  事業所別は未対応です。

  各yaml, jsonデータはvendor以下に生成済みのものが設置してあります。

  http://www.post.japanpost.jp/zipcode/dl/kogaki-zip.html

## Installation

Add this line to your application's Gemfile:

    gem 'yubin', :git => 'git://github.com/kengos/yubin.git'

And then execute:

    $ bundle

## Usage

Install Json files:

    $ rails g yubin:install

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
