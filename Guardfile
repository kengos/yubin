guard 'rspec', :version => 2, :cli => "--color --format Fuubar --profile", keep_failed: false, all_on_start: false, all_after_pass: false do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/yubin/(.+)\.rb$})     { |m| "spec/yubin/#{m[1]}_spec.rb" }
  watch('lib/yubin.rb') { "spec" }
  watch('spec/spec_helper.rb')  { "spec" }
end