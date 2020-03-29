class AddIndexToStatusInSessions < ActiveRecord::Migration[5.2]
  def change
    add_index(:sessions, :status)
  end
end
