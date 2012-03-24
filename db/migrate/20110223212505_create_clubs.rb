class CreateClubs < ActiveRecord::Migration
  def self.up
    create_table :clubs do |t|
      t.string :name
      t.string :address
      t.text :info
      t.integer :capacity
      t.string :img_url
      t.integer :city_id

      t.timestamps
    end
  end

  def self.down
    drop_table :clubs
  end
end
