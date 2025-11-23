class AddEntriesCountToEvent < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :entries_count, :integer, default: 0, null: false
  end
end
