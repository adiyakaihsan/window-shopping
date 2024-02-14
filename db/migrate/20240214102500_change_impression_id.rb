class ChangeImpressionId < ActiveRecord::Migration[7.1]
    def change
        rename_column :impressions, :ip_address, :request_id
    end
end