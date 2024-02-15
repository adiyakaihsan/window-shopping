class Product < ApplicationRecord
    belongs_to :category
    has_one_attached :image
    validates :image, :presence => true
    has_many :impressions, :as=>:impressionable

    def impression_count
        impressions.size
    end

    def unique_impression_count
        # impressions.group(:ip_address).size gives => {'127.0.0.1'=>9, '0.0.0.0'=>1}
        # so getting keys from the hash and calculating the number of keys
        impressions.group(:request_id).size.keys.length #TESTED
    end
end
