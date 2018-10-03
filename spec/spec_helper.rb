if ENV['CI']
  require 'simplecov'
  SimpleCov.start
end

VCR.configure do |config|
  config.ignore_hosts 'codeclimate.com' if ENV['CI']
  config.cassette_library_dir = File.join(ManageIQ::Providers::Telefonica::Engine.root, 'spec/vcr_cassettes')
end

NotificationType.seed

Dir[Rails.root.join("spec/shared/**/*.rb")].each { |f| require f }
Dir[ManageIQ::Providers::Telefonica::Engine.root.join("spec/support/**/*.rb")].each { |f| require f }

module EvmSpecHelper
  def self.stub_amqp_support
    require 'manageiq/providers/telefonica/legacy/events/telefonica_rabbit_event_monitor'
    allow(TelefonicaRabbitEventMonitor).to receive(:available?).and_return(true)
    allow(TelefonicaRabbitEventMonitor).to receive(:test_connection).and_return(true)
  end
end
