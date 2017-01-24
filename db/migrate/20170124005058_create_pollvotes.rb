class CreatePollvotes < ActiveRecord::Migration[5.0]
  def change
    create_table :pollvotes do |t|
      t.references :user, foreign_key: true
      t.references :pollvote_option, foreign_key: true
      t.timestamps
    end
    add_index :pollvotes, [:pollvote_option_id, :user_id], unique: true
  end
end
