class CreateEventLogs < ActiveRecord::Migration
  def change
    create_table :event_logs do |t|
      t.string :event_type
      t.string :record_type
      t.integer :record_id
      t.string :initiator_type
      t.integer :initiator_id
      t.integer :family1_id
      t.integer :family2_id
      t.integer :parent1_id
      t.integer :parent2_id
      t.integer :child1_id
      t.integer :child2_id

      t.timestamps
    end
  end
end
