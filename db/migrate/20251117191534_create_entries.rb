class CreateEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :entries do |t|
      t.integer :status, null: false, default: 0
      t.references :user, null: false, foreign_key: true, index: false
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end

    add_index :entries, %i[user_id event_id], unique: true
  end
end
