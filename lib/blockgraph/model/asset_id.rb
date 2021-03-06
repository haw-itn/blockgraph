module BlockGraph
  module Model
    class AssetId < ActiveNodeBase
      property :asset_id

      has_many :in, :outputs, origin: :asset_id, model_class: 'BlockGraph::Model::TxOut'

      validates :asset_id, presence: true

      scope :with_asset_id, ->(asset_id){where(asset_id: asset_id)}

      def self.find_or_create(asset_id)
        a = with_asset_id(asset_id).first
        unless a
          a = new
          a.asset_id = asset_id
          a.save!
        end
        a
      end

      def self.update
        puts "asset ids associate to tx out #{Time.current}"
        self.neo4j_query("USING PERIODIC COMMIT LOAD CSV WITH HEADERS FROM 'file:///open_assets.csv' AS row WITH row.tx_out_uuid AS uuid, row.asset_quantity AS asset_quantity, row.oa_output_type AS output_type
                          MERGE (out:`BlockGraph::Model::TxOut`:`BlockGraph::Model::ActiveNodeBase` {uuid: uuid})
                          ON MATCH SET out.asset_quantity = toInteger(asset_quantity), out.oa_output_type = toInteger(output_type)
                        ")
        self.neo4j_query("USING PERIODIC COMMIT LOAD CSV WITH HEADERS FROM 'file:///open_assets_rel.csv' AS row WITH row.tx_out_uuid AS uuid, row.asset_id AS asset_id
                          WHERE NOT asset_id = ''
                          MATCH (out:`BlockGraph::Model::TxOut`:`BlockGraph::Model::ActiveNodeBase` {uuid: uuid})
                          MERGE (asset:`BlockGraph::Model::AssetId`:`BlockGraph::Model::ActiveNodeBase` {asset_id: asset_id})
                          MERGE (out)-[:asset_id]->(asset)
                        ")
        puts "asset ids associated to tx out #{Time.current}"
      end

      def issuance_txs
        outputs.select{|o| BlockGraph::Constants::OutputType.output_type_label(o.oa_output_type) == 'issuance'}.map(&:transaction)
            .uniq{|tx| tx.txid}.sort{|a, b| b.block.time <=> a.block.time}
      end
    end
  end
end
