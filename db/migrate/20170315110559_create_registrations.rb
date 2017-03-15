class CreateRegistrations < ActiveRecord::Migration[5.0]
  def change
    create_table :registrations do |t|
      t.references :user, foreign_key: true
      t.references :event, foreign_key: true
      t.decimal :price
      t.string :status
      t.integer :guests_count

      t.timestamps
    end
  end
end
