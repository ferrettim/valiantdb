class AddPubarchieToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pubarchie, :boolean, null: false, default: true
  end
end
