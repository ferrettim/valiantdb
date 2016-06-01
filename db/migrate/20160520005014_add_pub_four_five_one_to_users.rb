class AddPubFourFiveOneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pubfourfiveone, :boolean, null: false, default: true
  end
end
