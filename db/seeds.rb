# frozen_string_literal: true

puts "Loading RubyLLM models..."
Rake::Task["ruby_llm:load_models"].invoke

puts "Seeding muscle groups..."

muscle_groups_data = {
  "Chest"       => { mev: 8,  mrv: 22 },
  "Back"        => { mev: 8,  mrv: 22 },
  "Quads"       => { mev: 6,  mrv: 20 },
  "Hamstrings"  => { mev: 4,  mrv: 16 },
  "Glutes"      => { mev: 0,  mrv: 16 },
  "Side Delts"  => { mev: 6,  mrv: 26 },
  "Rear Delts"  => { mev: 0,  mrv: 22 },
  "Front Delts" => { mev: 0,  mrv: 12 },
  "Biceps"      => { mev: 4,  mrv: 20 },
  "Triceps"     => { mev: 4,  mrv: 18 },
  "Calves"      => { mev: 6,  mrv: 20 },
  "Abs"         => { mev: 0,  mrv: 20 },
  "Traps"       => { mev: 0,  mrv: 20 },
  "Forearms"    => { mev: 0,  mrv: 16 }
}

muscle_groups = {}
muscle_groups_data.each do |name, data|
  mg = MuscleGroup.find_or_create_by!(name: name) do |m|
    m.default_mev = data[:mev]
    m.default_mrv = data[:mrv]
  end
  muscle_groups[name] = mg
end

puts "  Created #{MuscleGroup.count} muscle groups"

# ─── Exercises ────────────────────────────────────────────────────────────────

puts "Seeding exercises..."

exercises_data = [
  # Chest - Compound
  { name: "Barbell Bench Press",          muscle_group: "Chest", equipment: "barbell",    movement_type: :compound, available_at: :gym },
  { name: "Dumbbell Bench Press",         muscle_group: "Chest", equipment: "dumbbells",  movement_type: :compound, available_at: :both },
  { name: "Incline Barbell Bench Press",  muscle_group: "Chest", equipment: "barbell",    movement_type: :compound, available_at: :gym },
  { name: "Incline Dumbbell Bench Press", muscle_group: "Chest", equipment: "dumbbells",  movement_type: :compound, available_at: :both },
  { name: "Decline Dumbbell Bench Press", muscle_group: "Chest", equipment: "dumbbells",  movement_type: :compound, available_at: :gym },
  { name: "Push-Ups",                     muscle_group: "Chest", equipment: "bodyweight", movement_type: :compound, available_at: :both },
  { name: "Weighted Push-Ups",            muscle_group: "Chest", equipment: "bodyweight", movement_type: :compound, available_at: :both },
  { name: "Dips (Chest)",                 muscle_group: "Chest", equipment: "bodyweight", movement_type: :compound, available_at: :both },
  # Chest - Isolation
  { name: "Dumbbell Flyes",              muscle_group: "Chest", equipment: "dumbbells", movement_type: :isolation, available_at: :both },
  { name: "Incline Dumbbell Flyes",      muscle_group: "Chest", equipment: "dumbbells", movement_type: :isolation, available_at: :both },
  { name: "Cable Crossover",             muscle_group: "Chest", equipment: "cable",     movement_type: :isolation, available_at: :gym },
  { name: "Pec Deck Machine",            muscle_group: "Chest", equipment: "machine",   movement_type: :isolation, available_at: :gym },
  { name: "Low Cable Fly",               muscle_group: "Chest", equipment: "cable",     movement_type: :isolation, available_at: :gym },

  # Back - Compound
  { name: "Barbell Row",                   muscle_group: "Back", equipment: "barbell",    movement_type: :compound, available_at: :gym },
  { name: "Dumbbell Row",                  muscle_group: "Back", equipment: "dumbbells",  movement_type: :compound, available_at: :both },
  { name: "Pull-Ups",                      muscle_group: "Back", equipment: "bodyweight", movement_type: :compound, available_at: :both },
  { name: "Chin-Ups",                      muscle_group: "Back", equipment: "bodyweight", movement_type: :compound, available_at: :both },
  { name: "Lat Pulldown",                  muscle_group: "Back", equipment: "cable",      movement_type: :compound, available_at: :gym },
  { name: "Seated Cable Row",              muscle_group: "Back", equipment: "cable",      movement_type: :compound, available_at: :gym },
  { name: "T-Bar Row",                     muscle_group: "Back", equipment: "barbell",    movement_type: :compound, available_at: :gym },
  { name: "Chest-Supported Dumbbell Row",  muscle_group: "Back", equipment: "dumbbells",  movement_type: :compound, available_at: :both },
  { name: "Inverted Row",                  muscle_group: "Back", equipment: "bodyweight", movement_type: :compound, available_at: :both },
  # Back - Isolation
  { name: "Straight-Arm Cable Pulldown",  muscle_group: "Back", equipment: "cable",     movement_type: :isolation, available_at: :gym },
  { name: "Dumbbell Pullover",            muscle_group: "Back", equipment: "dumbbells", movement_type: :isolation, available_at: :both },
  { name: "Face Pull",                    muscle_group: "Back", equipment: "cable",     movement_type: :isolation, available_at: :both },

  # Quads - Compound
  { name: "Barbell Back Squat",     muscle_group: "Quads", equipment: "barbell",    movement_type: :compound, available_at: :gym },
  { name: "Barbell Front Squat",    muscle_group: "Quads", equipment: "barbell",    movement_type: :compound, available_at: :gym },
  { name: "Goblet Squat",           muscle_group: "Quads", equipment: "dumbbells",  movement_type: :compound, available_at: :both },
  { name: "Leg Press",              muscle_group: "Quads", equipment: "machine",    movement_type: :compound, available_at: :gym },
  { name: "Bulgarian Split Squat",  muscle_group: "Quads", equipment: "dumbbells",  movement_type: :compound, available_at: :both },
  { name: "Walking Lunge",          muscle_group: "Quads", equipment: "dumbbells",  movement_type: :compound, available_at: :both },
  { name: "Step-Ups",               muscle_group: "Quads", equipment: "dumbbells",  movement_type: :compound, available_at: :both },
  { name: "Hack Squat",             muscle_group: "Quads", equipment: "machine",    movement_type: :compound, available_at: :gym },
  # Quads - Isolation
  { name: "Leg Extension",          muscle_group: "Quads", equipment: "machine",    movement_type: :isolation, available_at: :gym },
  { name: "Sissy Squat",            muscle_group: "Quads", equipment: "bodyweight", movement_type: :isolation, available_at: :both },

  # Hamstrings - Compound
  { name: "Romanian Deadlift (Barbell)",  muscle_group: "Hamstrings", equipment: "barbell",   movement_type: :compound, available_at: :gym },
  { name: "Romanian Deadlift (Dumbbell)", muscle_group: "Hamstrings", equipment: "dumbbells", movement_type: :compound, available_at: :both },
  { name: "Stiff-Leg Deadlift",          muscle_group: "Hamstrings", equipment: "barbell",   movement_type: :compound, available_at: :gym },
  { name: "Good Morning",                muscle_group: "Hamstrings", equipment: "barbell",   movement_type: :compound, available_at: :gym },
  # Hamstrings - Isolation
  { name: "Leg Curl (Lying)",            muscle_group: "Hamstrings", equipment: "machine",    movement_type: :isolation, available_at: :gym },
  { name: "Leg Curl (Seated)",           muscle_group: "Hamstrings", equipment: "machine",    movement_type: :isolation, available_at: :gym },
  { name: "Nordic Curl",                 muscle_group: "Hamstrings", equipment: "bodyweight", movement_type: :isolation, available_at: :both },
  { name: "Dumbbell Leg Curl",           muscle_group: "Hamstrings", equipment: "dumbbells",  movement_type: :isolation, available_at: :both },
  { name: "Stability Ball Leg Curl",     muscle_group: "Hamstrings", equipment: "stability ball", movement_type: :isolation, available_at: :both },

  # Glutes - Compound
  { name: "Hip Thrust (Barbell)",    muscle_group: "Glutes", equipment: "barbell",  movement_type: :compound, available_at: :gym },
  { name: "Hip Thrust (Dumbbell)",   muscle_group: "Glutes", equipment: "dumbbells", movement_type: :compound, available_at: :both },
  { name: "Sumo Deadlift",          muscle_group: "Glutes", equipment: "barbell",  movement_type: :compound, available_at: :gym },
  { name: "Cable Pull-Through",     muscle_group: "Glutes", equipment: "cable",    movement_type: :compound, available_at: :gym },
  # Glutes - Isolation
  { name: "Glute Kickback (Cable)",  muscle_group: "Glutes", equipment: "cable",      movement_type: :isolation, available_at: :gym },
  { name: "Glute Bridge",           muscle_group: "Glutes", equipment: "bodyweight", movement_type: :isolation, available_at: :both },
  { name: "Frog Pump",              muscle_group: "Glutes", equipment: "bodyweight", movement_type: :isolation, available_at: :both },
  { name: "Clamshell",              muscle_group: "Glutes", equipment: "band",       movement_type: :isolation, available_at: :both },
  { name: "Donkey Kick",            muscle_group: "Glutes", equipment: "bodyweight", movement_type: :isolation, available_at: :both },

  # Side Delts
  { name: "Lateral Raise (Dumbbell)",  muscle_group: "Side Delts", equipment: "dumbbells", movement_type: :isolation, available_at: :both },
  { name: "Lateral Raise (Cable)",     muscle_group: "Side Delts", equipment: "cable",     movement_type: :isolation, available_at: :gym },
  { name: "Machine Lateral Raise",     muscle_group: "Side Delts", equipment: "machine",   movement_type: :isolation, available_at: :gym },
  { name: "Upright Row",              muscle_group: "Side Delts", equipment: "dumbbells", movement_type: :isolation, available_at: :both },

  # Rear Delts
  { name: "Reverse Pec Deck",          muscle_group: "Rear Delts", equipment: "machine",   movement_type: :isolation, available_at: :gym },
  { name: "Face Pull (Rear Delt)",     muscle_group: "Rear Delts", equipment: "cable",     movement_type: :isolation, available_at: :both },
  { name: "Dumbbell Reverse Fly",      muscle_group: "Rear Delts", equipment: "dumbbells", movement_type: :isolation, available_at: :both },
  { name: "Cable Reverse Fly",         muscle_group: "Rear Delts", equipment: "cable",     movement_type: :isolation, available_at: :gym },
  { name: "Band Pull-Apart",           muscle_group: "Rear Delts", equipment: "band",      movement_type: :isolation, available_at: :both },

  # Front Delts - Compound
  { name: "Overhead Press (Barbell)",   muscle_group: "Front Delts", equipment: "barbell",    movement_type: :compound, available_at: :gym },
  { name: "Overhead Press (Dumbbell)",  muscle_group: "Front Delts", equipment: "dumbbells",  movement_type: :compound, available_at: :both },
  { name: "Arnold Press",              muscle_group: "Front Delts", equipment: "dumbbells",  movement_type: :compound, available_at: :both },
  { name: "Landmine Press",            muscle_group: "Front Delts", equipment: "barbell",    movement_type: :compound, available_at: :gym },
  { name: "Pike Push-Up",              muscle_group: "Front Delts", equipment: "bodyweight", movement_type: :compound, available_at: :both },
  # Front Delts - Isolation
  { name: "Front Raise (Dumbbell)",    muscle_group: "Front Delts", equipment: "dumbbells", movement_type: :isolation, available_at: :both },
  { name: "Front Raise (Cable)",       muscle_group: "Front Delts", equipment: "cable",     movement_type: :isolation, available_at: :gym },

  # Biceps
  { name: "Barbell Curl",           muscle_group: "Biceps", equipment: "barbell",   movement_type: :isolation, available_at: :gym },
  { name: "Dumbbell Curl",          muscle_group: "Biceps", equipment: "dumbbells", movement_type: :isolation, available_at: :both },
  { name: "Hammer Curl",            muscle_group: "Biceps", equipment: "dumbbells", movement_type: :isolation, available_at: :both },
  { name: "Incline Dumbbell Curl",  muscle_group: "Biceps", equipment: "dumbbells", movement_type: :isolation, available_at: :both },
  { name: "Preacher Curl",          muscle_group: "Biceps", equipment: "barbell",   movement_type: :isolation, available_at: :gym },
  { name: "Cable Curl",             muscle_group: "Biceps", equipment: "cable",     movement_type: :isolation, available_at: :gym },
  { name: "Concentration Curl",     muscle_group: "Biceps", equipment: "dumbbells", movement_type: :isolation, available_at: :both },
  { name: "EZ Bar Curl",            muscle_group: "Biceps", equipment: "barbell",   movement_type: :isolation, available_at: :gym },

  # Triceps - Compound
  { name: "Close-Grip Bench Press",  muscle_group: "Triceps", equipment: "barbell",    movement_type: :compound, available_at: :gym },
  { name: "Dips (Triceps)",          muscle_group: "Triceps", equipment: "bodyweight", movement_type: :compound, available_at: :both },
  { name: "Diamond Push-Up",         muscle_group: "Triceps", equipment: "bodyweight", movement_type: :compound, available_at: :both },
  # Triceps - Isolation
  { name: "Overhead Tricep Extension (Dumbbell)", muscle_group: "Triceps", equipment: "dumbbells", movement_type: :isolation, available_at: :both },
  { name: "Tricep Pushdown (Cable)",              muscle_group: "Triceps", equipment: "cable",     movement_type: :isolation, available_at: :gym },
  { name: "Skull Crusher",                        muscle_group: "Triceps", equipment: "barbell",   movement_type: :isolation, available_at: :gym },
  { name: "Kickback (Dumbbell)",                  muscle_group: "Triceps", equipment: "dumbbells", movement_type: :isolation, available_at: :both },
  { name: "Cable Overhead Extension",             muscle_group: "Triceps", equipment: "cable",     movement_type: :isolation, available_at: :gym },

  # Calves
  { name: "Standing Calf Raise (Machine)",    muscle_group: "Calves", equipment: "machine",    movement_type: :isolation, available_at: :gym },
  { name: "Standing Calf Raise (Dumbbell)",   muscle_group: "Calves", equipment: "dumbbells",  movement_type: :isolation, available_at: :both },
  { name: "Seated Calf Raise",               muscle_group: "Calves", equipment: "machine",    movement_type: :isolation, available_at: :gym },
  { name: "Single-Leg Calf Raise",           muscle_group: "Calves", equipment: "bodyweight", movement_type: :isolation, available_at: :both },
  { name: "Donkey Calf Raise",               muscle_group: "Calves", equipment: "machine",    movement_type: :isolation, available_at: :gym },

  # Abs
  { name: "Cable Crunch",         muscle_group: "Abs", equipment: "cable",      movement_type: :isolation, available_at: :gym },
  { name: "Hanging Leg Raise",    muscle_group: "Abs", equipment: "bodyweight", movement_type: :isolation, available_at: :both },
  { name: "Ab Wheel Rollout",     muscle_group: "Abs", equipment: "ab wheel",   movement_type: :isolation, available_at: :both },
  { name: "Plank",                muscle_group: "Abs", equipment: "bodyweight", movement_type: :isolation, available_at: :both },
  { name: "Bicycle Crunch",       muscle_group: "Abs", equipment: "bodyweight", movement_type: :isolation, available_at: :both },
  { name: "Decline Sit-Up",       muscle_group: "Abs", equipment: "bodyweight", movement_type: :isolation, available_at: :gym },
  { name: "Dragon Flag",          muscle_group: "Abs", equipment: "bodyweight", movement_type: :isolation, available_at: :both },
  { name: "Pallof Press",         muscle_group: "Abs", equipment: "cable",      movement_type: :isolation, available_at: :both },
  { name: "Woodchop (Cable)",     muscle_group: "Abs", equipment: "cable",      movement_type: :isolation, available_at: :gym },

  # Traps
  { name: "Barbell Shrug",        muscle_group: "Traps", equipment: "barbell",    movement_type: :isolation, available_at: :gym },
  { name: "Dumbbell Shrug",       muscle_group: "Traps", equipment: "dumbbells",  movement_type: :isolation, available_at: :both },
  { name: "Cable Shrug",          muscle_group: "Traps", equipment: "cable",      movement_type: :isolation, available_at: :gym },
  { name: "Farmer's Walk",        muscle_group: "Traps", equipment: "dumbbells",  movement_type: :isolation, available_at: :both },

  # Forearms
  { name: "Wrist Curl",             muscle_group: "Forearms", equipment: "dumbbells",  movement_type: :isolation, available_at: :both },
  { name: "Reverse Wrist Curl",     muscle_group: "Forearms", equipment: "dumbbells",  movement_type: :isolation, available_at: :both },
  { name: "Farmer's Walk (Forearms)", muscle_group: "Forearms", equipment: "dumbbells", movement_type: :isolation, available_at: :both },
  { name: "Dead Hang",              muscle_group: "Forearms", equipment: "bodyweight", movement_type: :isolation, available_at: :both }
]

exercises_data.each do |data|
  mg = muscle_groups[data[:muscle_group]]
  Exercise.find_or_create_by!(name: data[:name]) do |e|
    e.muscle_group = mg
    e.equipment = data[:equipment]
    e.movement_type = data[:movement_type]
    e.available_at = data[:available_at]
  end
end

puts "  Created #{Exercise.count} exercises"

# ─── User ─────────────────────────────────────────────────────────────────────

puts "Seeding user..."

User.find_or_create_by!(email_address: "sdnorm@example.com") do |u|
  u.password = "password123"
  u.training_experience = :intermediate
  u.default_provider = "anthropic"
end

puts "  User: sdnorm@example.com / password123"
puts "Done!"
