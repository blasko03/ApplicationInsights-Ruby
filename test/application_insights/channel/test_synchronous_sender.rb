require_relative '../../../lib/azure_application_insights/channel/synchronous_sender'
require 'test/unit'

include AzureApplicationInsights::Channel

class TestSynchronousSender < Test::Unit::TestCase
  def test_initialize
    sender = SynchronousSender.new
    assert_equal 'https://dc.services.visualstudio.com/v2/track', sender.service_endpoint_uri
  end
end