class RemoveDescriptionFromProducts < ActiveRecord::Migration[8.0]
  def change
    remove_column :products, :description, :string
  end
end
