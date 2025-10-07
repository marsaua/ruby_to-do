class RemoveColumnsFromProducts < ActiveRecord::Migration[8.0]
  def change
    remove_column :products, :surname, :string
    remove_column :products, :age, :string
    remove_column :products, :email, :string
  end
end
