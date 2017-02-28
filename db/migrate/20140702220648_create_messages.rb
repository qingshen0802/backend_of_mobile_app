class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :playcelet, null: true
      t.references :app, null: false
      t.references :message, null: true
      t.string :message_type
      t.string :status, null: false, default: 'new'
      t.datetime :message_time, null: true
      t.datetime :received_at, null: true
      t.integer :recipient_app_id, null: true
      t.string :message_text, null: true

      t.timestamps
    end
    add_index :messages, [:playcelet_id, :app_id]
    add_index :messages, :playcelet_id
    add_index :messages, :app_id
    add_index :messages, :message_id
  end
end
