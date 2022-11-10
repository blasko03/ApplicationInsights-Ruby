require_relative 'json_serializable'

module AzureApplicationInsights::Channel::Contracts
  class Data
    include JsonSerializable

    attr_accessor :base_type, :base_data

    attribute_mapping(
      base_type: 'baseType',
      base_data: 'baseData'
    )
  end
end
