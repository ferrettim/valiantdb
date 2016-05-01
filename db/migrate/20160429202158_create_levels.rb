class CreateLevels < ActiveRecord::Migration
  def self.up
    create_table :levels do |t|
      t.integer :number
      t.string :display_name
      t.integer :required_score, :default => 0
      t.timestamps
    end
  end
  def self.down
  	drop_table :levels
  end
end

