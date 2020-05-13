class AddTypeToQuestion < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :category, :integer, default: 0
    add_index :questions, :category
  end
end
