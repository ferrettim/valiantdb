class AddLevel50ToUsers < ActiveRecord::Migration
  def change
    add_column :users, :level50, :boolean
  end
end
