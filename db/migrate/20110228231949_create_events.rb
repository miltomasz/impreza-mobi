class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name
      t.datetime :date
      t.integer :voices_number
      t.integer :club_id

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
