class AddCompanyAndDesignationToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :company, :string
    add_column :users, :designation, :string
    remove_column :users, :is_admin, :boolean
  end
end
