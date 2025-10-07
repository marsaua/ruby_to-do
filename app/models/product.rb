class Product < ApplicationRecord
    include Product::Notifications

    has_rich_text :description
    validates :name, presence: true
    validates :inventory_count, numericality: { greater_than_or_equal_to: 0 }
end
