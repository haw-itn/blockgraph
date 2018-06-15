require 'rest-client'
require 'httpclient'

module BlockGraph
  module OpenAssets
    module Model
      class AssetDefinition

        attr_accessor :asset_definition_url

        attr_accessor :asset_ids
        attr_accessor :name_short
        attr_accessor :name
        attr_accessor :contract_url
        attr_accessor :issuer
        attr_accessor :description
        attr_accessor :description_mime
        attr_accessor :type
        attr_accessor :divisibility
        attr_accessor :link_to_website
        attr_accessor :icon_url
        attr_accessor :image_url
        attr_accessor :version
        attr_accessor :proof_of_authenticity

        def initialize
          @asset_ids = []
          @version = '1.0'
          @divisibility = 0
        end

        # Parse the JSON obtained from the json String, and create a AssetDefinition object.
        # @param[String]
        def self.parse_json(json)
          parsed_json = JSON.parse(json)
          definition = new
          definition.asset_ids = parsed_json['asset_ids']
          definition.name_short = parsed_json['name_short']
          definition.name = parsed_json['name']
          definition.contract_url = parsed_json['contract_url']
          definition.issuer = parsed_json['issuer']
          definition.description = parsed_json['description']
          definition.description_mime = parsed_json['description_mime']
          definition.type = parsed_json['type']
          definition.divisibility = parsed_json['divisibility']
          definition.link_to_website = parsed_json['link_to_website']
          definition.icon_url = parsed_json['icon_url']
          definition.image_url = parsed_json['image_url']
          definition.version = parsed_json['version']
          definition
        end

        def include_asset_id?(asset_id)
          return false if asset_ids.nil? || asset_ids.empty?
          asset_ids.include?(asset_id)
        end

      end
    end
  end
end
