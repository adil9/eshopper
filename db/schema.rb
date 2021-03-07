# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_03_06_202056) do

  create_table "carts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "user_id"
    t.integer "status", limit: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_carts_on_user_id", unique: true
  end

  create_table "carts_items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "item_id"
    t.integer "cart_id"
    t.integer "quantity"
    t.integer "status", limit: 2
    t.decimal "discount", precision: 13, scale: 2
    t.decimal "price", precision: 13, scale: 2
    t.decimal "tax", precision: 6, scale: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cart_id", "status"], name: "index_carts_items_on_cart_id_and_status"
  end

  create_table "invoices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.decimal "base_price", precision: 13, scale: 2
    t.decimal "delivery_charges", precision: 13, scale: 2
    t.decimal "tax_charges", precision: 13, scale: 2
    t.integer "order_id"
    t.string "address_line1"
    t.string "address_line2"
    t.string "landmark"
    t.string "zip_code", limit: 20
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_invoices_on_order_id"
  end

  create_table "items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", limit: 190
    t.text "description"
    t.string "image_url"
    t.integer "category", limit: 2
    t.decimal "display_price", precision: 13, scale: 2
    t.decimal "discounted_price", precision: 13, scale: 2
    t.decimal "tax", precision: 6, scale: 2
    t.integer "selling_stock"
    t.integer "total_stock"
    t.integer "shop_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category", "shop_id"], name: "index_items_on_category_and_shop_id"
    t.index ["name"], name: "index_items_on_name"
    t.index ["shop_id"], name: "index_items_on_shop_id"
  end

  create_table "orders", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "shop_id"
    t.integer "user_id"
    t.integer "delivery_person_id"
    t.string "order_no", limit: 36
    t.integer "status", limit: 2
    t.string "promo_code", limit: 40
    t.integer "payment_method", limit: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["delivery_person_id"], name: "index_orders_on_delivery_person_id"
    t.index ["order_no"], name: "index_orders_on_order_no"
    t.index ["shop_id"], name: "index_orders_on_shop_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "orders_items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "item_id"
    t.integer "order_id"
    t.integer "quantity"
    t.decimal "discount", precision: 13, scale: 2
    t.decimal "price", precision: 13, scale: 2
    t.decimal "tax", precision: 6, scale: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_orders_items_on_order_id"
  end

  create_table "ratings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "user_id"
    t.integer "shop_id"
    t.float "rating"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shop_id"], name: "index_ratings_on_shop_id"
  end

  create_table "shops", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", limit: 190
    t.text "description"
    t.decimal "lat", precision: 15, scale: 10
    t.decimal "long", precision: 15, scale: 10
    t.string "string"
    t.string "image_url"
    t.float "rating"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["lat", "long"], name: "index_shops_on_lat_and_long"
    t.index ["name"], name: "index_shops_on_name"
    t.index ["user_id"], name: "index_shops_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "phone", limit: 10
    t.string "first_name", limit: 100
    t.string "last_name", limit: 100
    t.string "user_type", limit: 2
    t.string "image_url"
    t.decimal "lat", precision: 15, scale: 10
    t.decimal "long", precision: 15, scale: 10
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["lat", "long"], name: "index_users_on_lat_and_long"
    t.index ["phone"], name: "index_users_on_phone", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
