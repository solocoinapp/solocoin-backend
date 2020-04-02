class AddCountryNameOnUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :country_name, :string
  end
end
