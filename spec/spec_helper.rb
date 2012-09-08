require 'tapp'
require 'rspec'

require File.expand_path(File.dirname(__FILE__) + '/../lib/yubin')

RSpec.configure do |config|
  config.mock_with :rspec
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end

TMP_DIR = File.dirname(__FILE__) + '/../tmp'
FIXTURE_DIR = File.dirname(__FILE__) + '/fixtures'

def tmp_path(filename)
  TMP_DIR + '/' + filename
end

def fixture_path(filename)
  FIXTURE_DIR + '/' + filename
end