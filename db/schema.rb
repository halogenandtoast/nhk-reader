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

ActiveRecord::Schema.define(version: 20170116050903) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "stories", force: :cascade do |t|
    t.string   "title"
    t.string   "title_with_ruby"
    t.string   "news_id"
    t.datetime "published_at"
    t.string   "url"
    t.text     "body"
    t.boolean  "fetched"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.json     "data",            default: {}
    t.text     "image"
    t.index ["news_id"], name: "index_stories_on_news_id", unique: true, using: :btree
  end

end
