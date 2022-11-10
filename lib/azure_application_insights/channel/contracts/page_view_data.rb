require_relative 'json_serializable'

module AzureApplicationInsights::Channel::Contracts
  class PageViewData
    include JsonSerializable

    attr_accessor :ver, :url, :name, :duration, :properties, :measurements

    attribute_mapping(
      ver: 'ver',
      url: 'url',
      name: 'name',
      duration: 'duration',
      properties: 'properties',
      measurements: 'measurements'
    )

    def ver
      @ver ||= 2
    end

    def properties
      @properties ||= {}
    end

    def measurements
      @measurements ||= {}
    end
  end
end
