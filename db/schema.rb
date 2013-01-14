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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120305160816) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "domain"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",            :default => true
    t.string   "coupon"
    t.datetime "free_until"
    t.integer  "goal_quantitative", :default => 0
    t.integer  "goal_qualitative",  :default => 0
  end

  add_index "accounts", ["domain"], :name => "index_accounts_on_domain", :unique => true

  create_table "activities", :force => true do |t|
    t.integer  "activitable_id"
    t.string   "activitable_type"
    t.string   "action"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "author_id"
    t.text     "parent"
    t.text     "record"
    t.string   "author_name"
  end

  create_table "addresses", :force => true do |t|
    t.text     "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "kind"
    t.integer  "entity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ["entity_id"], :name => "index_addresses_on_contact_id"

  create_table "campaigns", :force => true do |t|
    t.string   "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "status"
    t.text     "description"
    t.integer  "budget"
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_imports", :force => true do |t|
    t.datetime "imported_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "log"
    t.string   "kind"
  end

  create_table "deals", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "value",                 :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",                :default => "prospect"
    t.string   "value_type"
    t.integer  "duration",              :default => 0
    t.integer  "assigned_to_id"
    t.datetime "status_last_change_at"
    t.integer  "probability",           :default => 50
  end

  create_table "emails", :force => true do |t|
    t.string   "address"
    t.string   "kind"
    t.integer  "entity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "emails", ["entity_id"], :name => "index_emails_on_contact_id"

  create_table "entities", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "company_id"
    t.integer  "imported_by_id"
    t.string   "type"
  end

  add_index "entities", ["company_id"], :name => "index_contacts_on_company_id"

  create_table "facts", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "closed_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "individual", :default => false
  end

  create_table "groups_users", :id => false, :force => true do |t|
    t.integer "group_id"
    t.integer "user_id"
  end

  add_index "groups_users", ["group_id", "user_id"], :name => "index_groups_users_on_group_id_and_user_id", :unique => true

  create_table "menus", :force => true do |t|
    t.string   "label"
    t.string   "path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", :force => true do |t|
    t.text     "content"
    t.integer  "notable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "notable_type"
    t.integer  "author_id"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.string   "author_name"
    t.integer  "related_email_id"
    t.boolean  "proposal"
  end

  add_index "notes", ["notable_id", "notable_type"], :name => "index_notes_on_notable_id_and_notable_type"

  create_table "permissions", :force => true do |t|
    t.integer  "group_id"
    t.integer  "referred_id"
    t.string   "referred_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permissions", ["group_id", "referred_id", "referred_type"], :name => "index_permissions_on_group_id_and_referred_id_and_referred_type", :unique => true

  create_table "phones", :force => true do |t|
    t.string   "number"
    t.string   "kind"
    t.integer  "entity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "phones", ["entity_id"], :name => "index_phones_on_contact_id"

  create_table "received_emails", :force => true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "processed_at"
  end

  create_table "relationships", :force => true do |t|
    t.integer  "entity_id"
    t.string   "entity_type"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "subject_id"
    t.string   "subject_type"
    t.integer  "subscriber_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscriptions", ["subject_id", "subject_type", "subscriber_id"], :name => "index_subscription_on_subscriber_and_subject", :unique => true

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "task_categories", :force => true do |t|
    t.string   "name"
    t.string   "color",      :limit => 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", :force => true do |t|
    t.string   "content"
    t.datetime "due_at"
    t.integer  "taskable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "taskable_type"
    t.datetime "done_at"
    t.boolean  "frame",          :default => false
    t.integer  "assigned_to_id"
    t.boolean  "notified",       :default => false
    t.integer  "category_id"
    t.datetime "notify_at"
    t.string   "notify"
  end

  add_index "tasks", ["assigned_to_id"], :name => "index_tasks_on_assigned_to_id"
  add_index "tasks", ["taskable_id", "taskable_type"], :name => "index_tasks_on_taskable_id_and_taskable_type"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email",                                 :default => "",         :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",         :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "time_zone",                             :default => "Brasilia"
    t.boolean  "welcome",                               :default => true
    t.string   "authentication_token"
    t.boolean  "admin",                                 :default => false
    t.string   "dropbox_token",          :limit => 6
    t.text     "survey"
    t.string   "invitation_token",       :limit => 60
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["dropbox_token"], :name => "index_users_on_dropbox_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "websites", :force => true do |t|
    t.integer  "entity_id"
    t.string   "url"
    t.string   "kind"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
