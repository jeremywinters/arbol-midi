task :default => :test

task :test do
  require 'minitest'
  require 'minitest/ci'
  Dir.glob('./test/**/test_*.rb').each { |file| require file }
end
