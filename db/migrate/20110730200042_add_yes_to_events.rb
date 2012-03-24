class AddYesToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :yes, :decimal
  end

  def self.down
    remove_column :events, :yes
  end
end
