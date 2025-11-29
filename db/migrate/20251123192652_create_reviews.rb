class CreateReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :reviews do |t|
      t.integer :rating, null: false
      t.text :comment, null: false
      t.references :user, null: false, foreign_key: true, index: false
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end

    add_index :reviews, %i[user_id event_id], unique: true
  end
end
