# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20140804172708) do

  create_table "changes", :force => true do |t|
    t.integer  "location_id"
    t.string   "remote_ip"
    t.text     "description"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "user_id"
    t.integer  "observation_id"
    t.string   "author"
    t.text     "description_patch"
  end

  create_table "clusters", :force => true do |t|
    t.string   "method"
    t.boolean  "muni"
    t.float    "grid_size"
    t.integer  "count"
    t.integer  "zoom"
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
    t.spatial  "cluster_point", :limit => {:srid=>900913, :type=>"point"}
    t.spatial  "grid_point",    :limit => {:srid=>900913, :type=>"point"}
    t.spatial  "polygon",       :limit => {:srid=>900913, :type=>"polygon"}
    t.integer  "type_id"
  end

  create_table "imports", :force => true do |t|
    t.string   "url"
    t.string   "name"
    t.text     "comments"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "autoload",   :default => true,  :null => false
    t.boolean  "muni",       :default => false
    t.text     "license"
  end

  create_table "locations", :force => true do |t|
    t.float    "lat"
    t.float    "lng"
    t.string   "author"
    t.text     "description"
    t.integer  "season_start"
    t.integer  "season_stop"
    t.boolean  "no_season"
    t.text     "address"
    t.datetime "created_at",                                                                                  :null => false
    t.datetime "updated_at",                                                                                  :null => false
    t.boolean  "unverified",                                                               :default => false
    t.integer  "access"
    t.integer  "import_id"
    t.spatial  "location",     :limit => {:srid=>4326, :type=>"point", :geographic=>true}
    t.string   "client",                                                                   :default => "web"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.integer  "user_id"
  end

  create_table "locations_routes", :force => true do |t|
    t.integer  "location_id"
    t.integer  "route_id"
    t.integer  "position"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "locations_types", :force => true do |t|
    t.integer "location_id"
    t.integer "type_id"
    t.string  "type_other"
    t.integer "position"
  end

  create_table "observations", :force => true do |t|
    t.integer  "location_id"
    t.text     "comment"
    t.date     "observed_on"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "fruiting"
    t.integer  "quality_rating"
    t.integer  "yield_rating"
    t.integer  "user_id"
    t.string   "remote_ip"
    t.string   "author"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "photo_caption"
  end

  create_table "problems", :force => true do |t|
    t.integer  "problem_code"
    t.text     "comment"
    t.integer  "resolution_code"
    t.text     "response"
    t.integer  "reporter_id"
    t.integer  "responder_id"
    t.string   "email"
    t.string   "name"
    t.integer  "location_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "routes", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.string   "transport_type"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.boolean  "is_public",      :default => true, :null => false
    t.string   "access_key"
  end

  create_table "types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "marker_file_name"
    t.string   "marker_content_type"
    t.integer  "marker_file_size"
    t.datetime "marker_updated_at"
    t.string   "scientific_name"
    t.string   "usda_symbol"
    t.string   "wikipedia_url"
    t.string   "edability"
    t.text     "notes"
    t.string   "synonyms"
    t.string   "scientific_synonyms"
    t.string   "urban_mushrooms_url"
    t.string   "fruitipedia_url"
    t.string   "eat_the_weeds_url"
    t.string   "foraging_texas_url"
    t.integer  "parent_id"
    t.integer  "taxonomic_rank"
    t.string   "es_name"
    t.string   "he_name"
    t.string   "pl_name"
    t.integer  "category_mask",       :default => 1
    t.string   "fr_name"
    t.string   "pt_br_name"
    t.string   "de_name"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                                                                :default => "",    :null => false
    t.string   "encrypted_password",                                                                   :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                                                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "authentication_token"
    t.datetime "created_at",                                                                                              :null => false
    t.datetime "updated_at",                                                                                              :null => false
    t.spatial  "range",                  :limit => {:srid=>4326, :type=>"polygon", :geographic=>true}
    t.string   "name"
    t.text     "bio"
    t.integer  "roles_mask",                                                                           :default => 10,    :null => false
    t.boolean  "range_updates_email",                                                                  :default => false, :null => false
    t.boolean  "add_anonymously",                                                                      :default => false, :null => false
    t.boolean  "announcements_email",                                                                  :default => true
    t.text     "address"
    t.decimal  "lat"
    t.decimal  "lng"
    t.decimal  "range_radius"
    t.string   "range_radius_unit"
    t.spatial  "location",               :limit => {:srid=>4326, :type=>"point", :geographic=>true}
  end

end
