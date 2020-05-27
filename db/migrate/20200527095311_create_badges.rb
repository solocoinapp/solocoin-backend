class CreateBadges < ActiveRecord::Migration[5.2]
  def change
    create_table :badges do |t|
      t.integer :level
      t.integer :min_points
      t.string :name
      t.string :one_liner
      t.string :color

      t.timestamps
    end
  end
end
