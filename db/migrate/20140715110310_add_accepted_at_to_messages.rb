class AddAcceptedAtToMessages < ActiveRecord::Migration
  def change
  	add_column :messages, :accepted_at, :datetime, null: true
  end
end
