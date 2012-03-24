class AddNoToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :no, :decimal
  end

  def self.down
    remove_column :events, :no
  end
end
