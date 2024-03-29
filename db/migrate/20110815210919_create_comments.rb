class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :name
      t.datetime :entry_date
      t.string :content
      t.integer :event_id

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
