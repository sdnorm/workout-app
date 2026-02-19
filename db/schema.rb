# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_02_18_200318) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "chats", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "model_id"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["model_id"], name: "index_chats_on_model_id"
    t.index ["user_id"], name: "index_chats_on_user_id"
  end

  create_table "exercise_secondary_muscles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "exercise_id", null: false
    t.integer "muscle_group_id", null: false
    t.datetime "updated_at", null: false
    t.index ["exercise_id"], name: "index_exercise_secondary_muscles_on_exercise_id"
    t.index ["muscle_group_id"], name: "index_exercise_secondary_muscles_on_muscle_group_id"
  end

  create_table "exercise_sets", force: :cascade do |t|
    t.boolean "completed", default: false
    t.datetime "created_at", null: false
    t.text "notes"
    t.integer "reps"
    t.integer "rir"
    t.integer "set_number"
    t.datetime "updated_at", null: false
    t.decimal "weight"
    t.integer "workout_exercise_id", null: false
    t.index ["workout_exercise_id"], name: "index_exercise_sets_on_workout_exercise_id"
  end

  create_table "exercises", force: :cascade do |t|
    t.integer "available_at"
    t.datetime "created_at", null: false
    t.string "equipment"
    t.integer "movement_type"
    t.integer "muscle_group_id", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["muscle_group_id"], name: "index_exercises_on_muscle_group_id"
  end

  create_table "mesocycle_volumes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "current_sets"
    t.integer "mav"
    t.integer "mesocycle_id", null: false
    t.integer "mev"
    t.integer "mrv"
    t.integer "muscle_group_id", null: false
    t.integer "starting_sets"
    t.datetime "updated_at", null: false
    t.index ["mesocycle_id"], name: "index_mesocycle_volumes_on_mesocycle_id"
    t.index ["muscle_group_id"], name: "index_mesocycle_volumes_on_muscle_group_id"
  end

  create_table "mesocycles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "current_week"
    t.integer "duration_weeks"
    t.date "end_date"
    t.text "notes"
    t.string "split_type"
    t.date "start_date"
    t.integer "status"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_mesocycles_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.integer "cache_creation_tokens"
    t.integer "cached_tokens"
    t.integer "chat_id", null: false
    t.text "content"
    t.json "content_raw"
    t.datetime "created_at", null: false
    t.integer "input_tokens"
    t.integer "model_id"
    t.integer "output_tokens"
    t.string "role", null: false
    t.text "thinking_signature"
    t.text "thinking_text"
    t.integer "thinking_tokens"
    t.integer "tool_call_id"
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_messages_on_chat_id"
    t.index ["model_id"], name: "index_messages_on_model_id"
    t.index ["role"], name: "index_messages_on_role"
    t.index ["tool_call_id"], name: "index_messages_on_tool_call_id"
  end

  create_table "mobility_exercises", force: :cascade do |t|
    t.boolean "completed", default: false
    t.datetime "created_at", null: false
    t.integer "duration_seconds"
    t.integer "hold_seconds"
    t.integer "mobility_routine_id", null: false
    t.string "name", null: false
    t.text "notes"
    t.integer "position", null: false
    t.integer "reps"
    t.integer "sets"
    t.string "side"
    t.datetime "updated_at", null: false
    t.index ["mobility_routine_id"], name: "index_mobility_exercises_on_mobility_routine_id"
  end

  create_table "mobility_routines", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date", null: false
    t.integer "duration_minutes"
    t.string "focus_area"
    t.text "generation_error"
    t.text "notes"
    t.string "routine_type"
    t.integer "status", default: 0
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_mobility_routines_on_user_id"
  end

  create_table "models", force: :cascade do |t|
    t.json "capabilities", default: []
    t.integer "context_window"
    t.datetime "created_at", null: false
    t.string "family"
    t.date "knowledge_cutoff"
    t.integer "max_output_tokens"
    t.json "metadata", default: {}
    t.json "modalities", default: {}
    t.datetime "model_created_at"
    t.string "model_id", null: false
    t.string "name", null: false
    t.json "pricing", default: {}
    t.string "provider", null: false
    t.datetime "updated_at", null: false
    t.index ["family"], name: "index_models_on_family"
    t.index ["provider", "model_id"], name: "index_models_on_provider_and_model_id", unique: true
    t.index ["provider"], name: "index_models_on_provider"
  end

  create_table "muscle_groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "default_mev"
    t.integer "default_mrv"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "runs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date"
    t.decimal "distance"
    t.integer "duration_minutes"
    t.text "notes"
    t.string "pace"
    t.string "run_type"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "workout_id"
    t.index ["user_id"], name: "index_runs_on_user_id"
    t.index ["workout_id"], name: "index_runs_on_workout_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "tool_calls", force: :cascade do |t|
    t.json "arguments", default: {}
    t.datetime "created_at", null: false
    t.integer "message_id", null: false
    t.string "name", null: false
    t.string "thought_signature"
    t.string "tool_call_id", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_tool_calls_on_message_id"
    t.index ["name"], name: "index_tool_calls_on_name"
    t.index ["tool_call_id"], name: "index_tool_calls_on_tool_call_id", unique: true
  end

  create_table "training_methodologies", force: :cascade do |t|
    t.boolean "active", default: false, null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.boolean "public", default: false, null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id", "active"], name: "index_training_methodologies_on_user_id_and_active"
    t.index ["user_id"], name: "index_training_methodologies_on_user_id"
  end

  create_table "user_preferences", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "equipment_notes"
    t.json "home_equipment", default: []
    t.text "injuries_notes"
    t.json "muscle_group_priorities", default: {}
    t.text "style_notes"
    t.integer "training_goal", default: 0
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.json "workout_style", default: []
    t.index ["user_id"], name: "index_user_preferences_on_user_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "default_provider", default: "anthropic"
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.integer "training_experience", default: 1
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "workout_exercises", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "exercise_id", null: false
    t.text "notes"
    t.integer "position"
    t.integer "rest_seconds"
    t.string "target_reps"
    t.integer "target_rir"
    t.integer "target_sets"
    t.datetime "updated_at", null: false
    t.integer "workout_id", null: false
    t.index ["exercise_id"], name: "index_workout_exercises_on_exercise_id"
    t.index ["workout_id"], name: "index_workout_exercises_on_workout_id"
  end

  create_table "workouts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date"
    t.text "generation_error"
    t.integer "location"
    t.integer "mesocycle_id"
    t.text "notes"
    t.integer "status"
    t.integer "target_duration_minutes", default: 45
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "week_number"
    t.integer "workout_type"
    t.index ["mesocycle_id"], name: "index_workouts_on_mesocycle_id"
    t.index ["user_id"], name: "index_workouts_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "chats", "models"
  add_foreign_key "chats", "users"
  add_foreign_key "exercise_secondary_muscles", "exercises"
  add_foreign_key "exercise_secondary_muscles", "muscle_groups"
  add_foreign_key "exercise_sets", "workout_exercises"
  add_foreign_key "exercises", "muscle_groups"
  add_foreign_key "mesocycle_volumes", "mesocycles"
  add_foreign_key "mesocycle_volumes", "muscle_groups"
  add_foreign_key "mesocycles", "users"
  add_foreign_key "messages", "chats"
  add_foreign_key "messages", "models"
  add_foreign_key "messages", "tool_calls"
  add_foreign_key "mobility_exercises", "mobility_routines"
  add_foreign_key "mobility_routines", "users"
  add_foreign_key "runs", "users"
  add_foreign_key "runs", "workouts"
  add_foreign_key "sessions", "users"
  add_foreign_key "tool_calls", "messages"
  add_foreign_key "training_methodologies", "users"
  add_foreign_key "user_preferences", "users"
  add_foreign_key "workout_exercises", "exercises"
  add_foreign_key "workout_exercises", "workouts"
  add_foreign_key "workouts", "mesocycles"
  add_foreign_key "workouts", "users"
end
