class AddVoicesIndexToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :voices_index, :integer
  end

  def self.down
    remove_column :events, :voices_index
  end
end
