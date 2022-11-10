require_relative 'azure_application_insights/telemetry_client'
require_relative 'azure_application_insights/unhandled_exception'
require_relative 'azure_application_insights/version'

module AzureApplicationInsights
  module Rack
    autoload :TrackRequest, "azure_application_insights/rack/track_request"
  end
end
