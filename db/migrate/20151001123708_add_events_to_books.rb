class AddEventsToBooks < ActiveRecord::Migration
  def change
    add_column :books, :event, :string
  end
end
