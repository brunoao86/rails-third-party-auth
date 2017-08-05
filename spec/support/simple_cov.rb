# SimpleCov configuration
# run: rake SIMPLE_COV=true to get the covered results report at /coverage/index.html
if ENV['SIMPLE_COV'] == 'true'
  require 'simplecov'
  SimpleCov.start 'rails'
end
