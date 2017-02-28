# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140815143816) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "apps", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "version",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "children", force: :cascade do |t|
    t.string   "first_name",                                            null: false
    t.string   "last_name",                                             null: false
    t.integer  "family_id",                                             null: false
    t.integer  "playcelet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "color",                   default: "FFFFFF",            null: false
    t.string   "color_name"
    t.string   "mac_address",             default: "01:23:45:67:89:ab", null: false
    t.string   "playcelet"
    t.integer  "app_id"
    t.datetime "located_at"
    t.integer  "last_app_id"
    t.integer  "default_play_network_id"
    t.index ["app_id"], name: "index_children_on_app_id", using: :btree
    t.index ["family_id"], name: "index_children_on_family_id", using: :btree
    t.index ["mac_address"], name: "index_children_on_mac_address", using: :btree
    t.index ["playcelet_id"], name: "index_children_on_playcelet_id", using: :btree
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "event_logs", force: :cascade do |t|
    t.string   "event_type"
    t.string   "record_type"
    t.integer  "record_id"
    t.string   "initiator_type"
    t.integer  "initiator_id"
    t.integer  "family1_id"
    t.integer  "family2_id"
    t.integer  "parent1_id"
    t.integer  "parent2_id"
    t.integer  "child1_id"
    t.integer  "child2_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mode_type"
    t.string   "details"
    t.index ["mode_type"], name: "index_event_logs_on_mode_type", using: :btree
  end

  create_table "families", force: :cascade do |t|
    t.string   "type",       default: "Family", null: false
    t.string   "name",                          null: false
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "infos", force: :cascade do |t|
    t.integer  "app_id"
    t.integer  "message_id"
    t.string   "message_type"
    t.string   "status",             default: "new", null: false
    t.datetime "message_time",                       null: false
    t.datetime "received_at"
    t.integer  "sender_app_id"
    t.string   "message_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "invitation_id"
    t.integer  "family_id"
    t.integer  "invited_family_id"
    t.string   "invitation_type"
    t.string   "light_mode"
    t.string   "color"
    t.integer  "child_id"
    t.integer  "recipient_child_id"
    t.string   "display_type"
    t.index ["app_id", "message_time"], name: "index_infos_on_app_id_and_message_time", using: :btree
    t.index ["app_id", "status"], name: "index_infos_on_app_id_and_status", using: :btree
    t.index ["app_id"], name: "index_infos_on_app_id", using: :btree
    t.index ["display_type"], name: "index_infos_on_display_type", using: :btree
    t.index ["message_id"], name: "index_infos_on_message_id", using: :btree
    t.index ["recipient_child_id", "status"], name: "index_infos_on_recipient_child_id_and_status", using: :btree
    t.index ["recipient_child_id"], name: "index_infos_on_recipient_child_id", using: :btree
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "app_id",                             null: false
    t.integer  "message_id"
    t.string   "message_type"
    t.string   "status",             default: "new", null: false
    t.datetime "message_time"
    t.datetime "received_at"
    t.integer  "recipient_app_id"
    t.string   "message_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "invitation_id"
    t.integer  "family_id"
    t.integer  "invited_family_id"
    t.string   "invitation_type"
    t.datetime "accepted_at"
    t.integer  "child_id"
    t.integer  "recipient_child_id"
    t.integer  "duration"
    t.datetime "end_time"
    t.index ["app_id"], name: "index_messages_on_app_id", using: :btree
    t.index ["message_id"], name: "index_messages_on_message_id", using: :btree
    t.index ["recipient_child_id", "status"], name: "index_messages_on_recipient_child_id_and_status", using: :btree
    t.index ["recipient_child_id"], name: "index_messages_on_recipient_child_id", using: :btree
  end

  create_table "neighbors_families_links", force: :cascade do |t|
    t.integer  "family_id",               null: false
    t.integer  "neighbor_family_id",      null: false
    t.integer  "neighbors_invitation_id", null: false
    t.boolean  "initiator",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["family_id"], name: "index_neighbors_families_links_on_family_id", using: :btree
    t.index ["initiator"], name: "index_neighbors_families_links_on_initiator", using: :btree
    t.index ["neighbor_family_id"], name: "index_neighbors_families_links_on_neighbor_family_id", using: :btree
    t.index ["neighbors_invitation_id"], name: "index_neighbors_families_links_on_neighbors_invitation_id", using: :btree
  end

  create_table "neighbors_invitations", force: :cascade do |t|
    t.integer  "family_id",                         null: false
    t.integer  "invited_family_id",                 null: false
    t.string   "status",            default: "new", null: false
    t.integer  "user_id",                           null: false
    t.string   "invitation_text",                   null: false
    t.datetime "invited_at",                        null: false
    t.integer  "respond_by_id"
    t.string   "response_text"
    t.datetime "respond_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["family_id"], name: "index_neighbors_invitations_on_family_id", using: :btree
    t.index ["invited_family_id"], name: "index_neighbors_invitations_on_invited_family_id", using: :btree
    t.index ["respond_by_id"], name: "index_neighbors_invitations_on_respond_by_id", using: :btree
    t.index ["user_id"], name: "index_neighbors_invitations_on_user_id", using: :btree
  end

  create_table "play_invitations", force: :cascade do |t|
    t.integer  "app_id"
    t.string   "invitation_text"
    t.datetime "invited_at"
    t.string   "status",            null: false
    t.integer  "respond_by_id"
    t.string   "response_text"
    t.datetime "respond_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "notified_at"
    t.integer  "child_id"
    t.integer  "invited_child_id"
    t.integer  "place_id"
    t.datetime "end_time"
    t.integer  "duration"
    t.integer  "proposed_duration"
    t.datetime "proposed_end_time"
    t.index ["app_id"], name: "index_play_invitations_on_app_id", using: :btree
    t.index ["end_time"], name: "index_play_invitations_on_end_time", using: :btree
    t.index ["invited_child_id", "status"], name: "index_play_invitations_on_invited_child_id_and_status", using: :btree
    t.index ["invited_child_id"], name: "index_play_invitations_on_invited_child_id", using: :btree
    t.index ["respond_by_id"], name: "index_play_invitations_on_respond_by_id", using: :btree
  end

  create_table "play_networks", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "play_nodes", force: :cascade do |t|
    t.integer  "child_id"
    t.integer  "play_network_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["child_id"], name: "index_play_nodes_on_child_id", using: :btree
    t.index ["play_network_id"], name: "index_play_nodes_on_play_network_id", using: :btree
  end

  create_table "supervisors", force: :cascade do |t|
    t.string   "type",       null: false
    t.string   "first_name", null: false
    t.string   "last_name",  null: false
    t.integer  "family_id"
    t.integer  "user_id",    null: false
    t.integer  "app_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password"
    t.index ["app_id"], name: "index_supervisors_on_app_id", using: :btree
    t.index ["family_id"], name: "index_supervisors_on_family_id", using: :btree
    t.index ["user_id"], name: "index_supervisors_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",                           null: false
    t.string   "encrypted_password",     default: "",                           null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,                            null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role",                   default: "parent"
    t.string   "authentication_token"
    t.string   "time_zone",              default: "Pacific Time (US & Canada)"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
