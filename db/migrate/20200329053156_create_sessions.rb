class CreateSessions < ActiveRecord::Migration[5.2]
  def change
    create_table :sessions do |t|
      t.references :user, foreign_key: true
      t.integer :session_type
      t.integer :status
      t.integer :rewards, default: 0
      t.timestamp :start_time
      t.timestamp :end_time

      t.timestamps
    end
  end
end
