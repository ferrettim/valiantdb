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

ActiveRecord::Schema.define(version: 20170118010501) do

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type", limit: 255
    t.integer  "owner_id"
    t.string   "owner_type",     limit: 255
    t.string   "key",            limit: 255
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"
  end

  create_table "average_caches", force: :cascade do |t|
    t.integer  "rater_id"
    t.integer  "rateable_id"
    t.string   "rateable_type", limit: 255
    t.float    "avg",                       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "books", force: :cascade do |t|
    t.string   "title",              limit: 255
    t.string   "date",               limit: 255
    t.string   "note",               limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "writer",             limit: 255
    t.string   "artist",             limit: 255
    t.string   "cover",              limit: 255
    t.string   "arc",                limit: 255
    t.integer  "issue"
    t.date     "rdate"
    t.text     "link"
    t.string   "isb",                limit: 255
    t.text     "summary"
    t.string   "colors",             limit: 255
    t.string   "writer2",            limit: 255
    t.string   "artist2",            limit: 255
    t.string   "bookcode",           limit: 255
    t.string   "qr",                 limit: 255
    t.integer  "pricenm"
    t.integer  "price98"
    t.integer  "printrun"
    t.string   "category",           limit: 255
    t.string   "status",             limit: 255
    t.string   "event",              limit: 255
    t.integer  "eventpart"
    t.boolean  "iskey"
    t.text     "keynote"
    t.string   "eic"
    t.integer  "price"
    t.string   "editor"
    t.string   "letters"
    t.string   "era"
    t.integer  "printing"
    t.string   "country"
    t.string   "publisher"
    t.string   "comicrating"
    t.string   "code"
    t.string   "image_remote_url"
    t.string   "imprint"
    t.string   "slug"
    t.string   "ratio"
    t.index ["slug"], name: "index_books_on_slug", unique: true
  end

  create_table "characters", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "creator",            limit: 255
    t.string   "creator2",           limit: 255
    t.string   "apptitle",           limit: 255
    t.integer  "appissue"
    t.string   "appera",             limit: 255
    t.text     "origin"
    t.string   "power",              limit: 255
    t.string   "power2",             limit: 255
    t.string   "power3",             limit: 255
    t.string   "power4",             limit: 255
    t.string   "power5",             limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.index ["slug"], name: "index_characters_on_slug", unique: true
  end

  create_table "collectibles", force: :cascade do |t|
    t.string   "title"
    t.date     "rdate"
    t.text     "description"
    t.string   "category"
    t.string   "manufacturer"
    t.text     "link"
    t.string   "slug"
    t.integer  "price"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "printrun"
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "book_id"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_comments_on_book_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "entries", force: :cascade do |t|
    t.string   "title"
    t.datetime "published"
    t.text     "content"
    t.string   "url"
    t.string   "author"
    t.integer  "feed_id"
    t.string   "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "text"
    t.integer  "points"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feeds", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.text     "summary"
    t.string   "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "follows", force: :cascade do |t|
    t.string   "follower_type",   limit: 255
    t.integer  "follower_id"
    t.string   "followable_type", limit: 255
    t.integer  "followable_id"
    t.datetime "created_at"
    t.index ["followable_id", "followable_type"], name: "fk_followables"
    t.index ["follower_id", "follower_type"], name: "fk_follows"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider",   limit: 255
    t.string   "uid",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "itemowns", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "collectible_id"
  end

  create_table "itemsales", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "collectible_id"
  end

  create_table "itemwishes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "collectible_id"
  end

  create_table "levels", force: :cascade do |t|
    t.integer  "number"
    t.string   "display_name"
    t.integer  "required_score", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mailboxer_conversation_opt_outs", force: :cascade do |t|
    t.integer "unsubscriber_id"
    t.string  "unsubscriber_type", limit: 255
    t.integer "conversation_id"
    t.index ["conversation_id"], name: "index_mailboxer_conversation_opt_outs_on_conversation_id"
    t.index ["unsubscriber_id", "unsubscriber_type"], name: "index_mailboxer_conversation_opt_outs_on_unsubscriber_id_type"
  end

  create_table "mailboxer_conversations", force: :cascade do |t|
    t.string   "subject",    limit: 255, default: ""
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "mailboxer_notifications", force: :cascade do |t|
    t.string   "type",                 limit: 255
    t.text     "body"
    t.string   "subject",              limit: 255, default: ""
    t.integer  "sender_id"
    t.string   "sender_type",          limit: 255
    t.integer  "conversation_id"
    t.boolean  "draft",                            default: false
    t.string   "notification_code",    limit: 255
    t.integer  "notified_object_id"
    t.string   "notified_object_type", limit: 255
    t.string   "attachment",           limit: 255
    t.datetime "updated_at",                                       null: false
    t.datetime "created_at",                                       null: false
    t.boolean  "global",                           default: false
    t.datetime "expires"
    t.index ["conversation_id"], name: "index_mailboxer_notifications_on_conversation_id"
    t.index ["notified_object_id", "notified_object_type"], name: "index_mailboxer_notifications_on_notified_object_id_and_type"
    t.index ["sender_id", "sender_type"], name: "index_mailboxer_notifications_on_sender_id_and_sender_type"
    t.index ["type"], name: "index_mailboxer_notifications_on_type"
  end

  create_table "mailboxer_receipts", force: :cascade do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type",   limit: 255
    t.integer  "notification_id",                             null: false
    t.boolean  "is_read",                     default: false
    t.boolean  "trashed",                     default: false
    t.boolean  "deleted",                     default: false
    t.string   "mailbox_type",    limit: 25
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.index ["notification_id"], name: "index_mailboxer_receipts_on_notification_id"
    t.index ["receiver_id", "receiver_type"], name: "index_mailboxer_receipts_on_receiver_id_and_receiver_type"
  end

  create_table "mentions", force: :cascade do |t|
    t.string   "mentioner_type",   limit: 255
    t.integer  "mentioner_id"
    t.string   "mentionable_type", limit: 255
    t.integer  "mentionable_id"
    t.datetime "created_at"
    t.index ["mentionable_id", "mentionable_type"], name: "fk_mentionables"
    t.index ["mentioner_id", "mentioner_type"], name: "fk_mentions"
  end

  create_table "overall_averages", force: :cascade do |t|
    t.integer  "rateable_id"
    t.string   "rateable_type", limit: 255
    t.float    "overall_avg",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "owns", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "book_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity"
  end

  create_table "previews", force: :cascade do |t|
    t.string   "description"
    t.integer  "book_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.index ["book_id"], name: "index_previews_on_book_id"
  end

  create_table "rates", force: :cascade do |t|
    t.integer  "rater_id"
    t.integer  "rateable_id"
    t.string   "rateable_type", limit: 255
    t.float    "stars",                     null: false
    t.string   "dimension",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["rateable_id", "rateable_type"], name: "index_rates_on_rateable_id_and_rateable_type"
    t.index ["rater_id"], name: "index_rates_on_rater_id"
  end

  create_table "rating_caches", force: :cascade do |t|
    t.integer  "cacheable_id"
    t.string   "cacheable_type", limit: 255
    t.float    "avg",                        null: false
    t.integer  "qty",                        null: false
    t.string   "dimension",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["cacheable_id", "cacheable_type"], name: "index_rating_caches_on_cacheable_id_and_cacheable_type"
  end

  create_table "sales", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "book_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "book_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_taggings_on_book_id"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                   limit: 255
    t.string   "avatar_file_name",       limit: 255
    t.string   "avatar_content_type",    limit: 255
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "admin",                              default: false
    t.boolean  "super_admin",                        default: false
    t.string   "slug",                   limit: 255
    t.boolean  "tableview",                          default: false
    t.boolean  "patron"
    t.boolean  "level1"
    t.boolean  "level3"
    t.boolean  "level5"
    t.boolean  "level20"
    t.boolean  "illuminati"
    t.boolean  "voice",                              default: false
    t.boolean  "level50"
    t.integer  "owns_count",                         default: 0,     null: false
    t.integer  "score",                              default: 0
    t.integer  "level_id"
    t.integer  "wishes_count",                       default: 0,     null: false
    t.integer  "sales_count",                        default: 0,     null: false
    t.integer  "comments_count",                     default: 0,     null: false
    t.boolean  "pubaftershock",                      default: true,  null: false
    t.boolean  "pubaspen",                           default: true,  null: false
    t.boolean  "pubavatar",                          default: true,  null: false
    t.boolean  "pubblackmask",                       default: true,  null: false
    t.boolean  "pubboom",                            default: true,  null: false
    t.boolean  "pubdarkhorse",                       default: true,  null: false
    t.boolean  "pubdc",                              default: true,  null: false
    t.boolean  "pubdynamite",                        default: true,  null: false
    t.boolean  "pubidw",                             default: true,  null: false
    t.boolean  "pubimage",                           default: true,  null: false
    t.boolean  "pubmarvel",                          default: true,  null: false
    t.boolean  "pubvaliant",                         default: true,  null: false
    t.boolean  "pubvertigo",                         default: true,  null: false
    t.boolean  "pubzenescope",                       default: true,  null: false
    t.boolean  "pubfourfiveone",                     default: true,  null: false
    t.integer  "failed_attempts",                    default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.boolean  "pubarchie",                          default: true,  null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["slug"], name: "index_users_on_slug"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",                     null: false
    t.integer  "item_id",                       null: false
    t.string   "event",                         null: false
    t.string   "whodunnit"
    t.text     "object",     limit: 1073741823
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "votes", force: :cascade do |t|
    t.integer  "votable_id"
    t.string   "votable_type", limit: 255
    t.integer  "voter_id"
    t.string   "voter_type",   limit: 255
    t.boolean  "vote_flag"
    t.string   "vote_scope",   limit: 255
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"
  end

  create_table "wishes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "book_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
