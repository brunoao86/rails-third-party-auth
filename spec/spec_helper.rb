# SimpleCov configuration
# run: rake SIMPLE_COV=true to get the covered results report at /coverage/index.html
if ENV['SIMPLE_COV'] == 'true'
  require 'simplecov'
  SimpleCov.start 'rails'
end

# Rspec configuration
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.filter_run_when_matching :focus

  # Print the 10 slowest examples and example groups
  # config.profile_examples = 10

  config.order = :random

  Kernel.srand config.seed
end
