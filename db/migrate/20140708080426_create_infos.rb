class CreateInfos < ActiveRecord::Migration
  def change
    create_table :infos do |t|
      t.references :playcelet, null: false
      t.references :app, null: false
      t.references :message, null: true
      t.string :message_type
      t.string :status, null: false, default: 'new'
      t.datetime :message_time, null: false
      t.datetime :received_at
      t.references :app
      t.references :playcelet
      t.integer :sender_app_id, null: true
      t.string :message_text, null: true
      
      t.timestamps
    end

    add_index :infos, :playcelet_id
    add_index :infos, :app_id
    add_index :infos, [:playcelet_id, :status]
    add_index :infos, [:app_id, :status]
    add_index :infos, [:app_id, :message_time]
    add_index :infos, :message_id
  end
end
