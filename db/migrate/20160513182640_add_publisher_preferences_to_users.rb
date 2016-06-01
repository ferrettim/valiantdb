class AddPublisherPreferencesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pubaftershock, :boolean, null: false, default: true
    add_column :users, :pubaspen, :boolean, null: false, default: true
    add_column :users, :pubavatar, :boolean, null: false, default: true
    add_column :users, :pubblackmask, :boolean, null: false, default: true
    add_column :users, :pubboom, :boolean, null: false, default: true
    add_column :users, :pubdarkhorse, :boolean, null: false, default: true
    add_column :users, :pubdc, :boolean, null: false, default: true
    add_column :users, :pubdynamite, :boolean, null: false, default: true
    add_column :users, :pubidw, :boolean, null: false, default: true
    add_column :users, :pubimage, :boolean, null: false, default: true
    add_column :users, :pubmarvel, :boolean, null: false, default: true
    add_column :users, :pubvaliant, :boolean, null: false, default: true
    add_column :users, :pubvertigo, :boolean, null: false, default: true
    add_column :users, :pubzenescope, :boolean, null: false, default: true
  end
end
