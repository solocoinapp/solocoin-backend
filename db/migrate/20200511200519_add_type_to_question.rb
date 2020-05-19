class AddTypeToQuestion < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :category, :integer, default: 0
  end
end
