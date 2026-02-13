# Workout App — RP Hypertrophy Trainer

## Overview
Personal workout app based on Mike Isratel's RP (Renaissance Periodization) methodology. AI-powered workout generation adapts to location (home/gym), mesocycle progression, and past performance.

Single user, SQLite, deployed to Railway.

## RP Methodology Context
See `guides/` directory:
- `guides/rp_methodology.md` — Core RP principles (volume landmarks, mesocycle structure, RIR progression, deload protocols)
- `guides/exercise_database.md` — Exercise catalog by muscle group, equipment, movement pattern
- `guides/equipment_profiles.md` — Home vs gym equipment availability

## Tech Stack
- Rails 8 (SQLite, Hotwire/Turbo/Stimulus, Tailwind CSS)
- RubyLLM gem with Anthropic (Claude) + xAI (Grok) providers
- Rails 8 built-in authentication
- PWA for mobile-first gym use

## Conventions

### Code Organization
- **No service objects** — business logic lives in models and concerns
- Concerns for shared behavior (`RpPeriodization`, `WorkoutHistory`)
- Tableless models with `ActiveModel::Model` for complex operations (e.g., `Workout::Generator`)

### Testing
- **Minitest + fixtures** (no RSpec, no FactoryBot)
- Unit tests for model validations and concern logic
- Integration tests for key flows
- System tests for full user journeys
- Run: `bin/rails test && bin/rails test:system`

### Frontend
- Hotwire (Turbo Frames + Streams, Stimulus controllers)
- Mobile-first Tailwind CSS
- Turbo Frames for workout generation, exercise cards, set logging
- Turbo Streams for real-time updates during workouts

### AI Integration
- RubyLLM `acts_as_chat` on Chat model
- System prompts assembled from guides/ + user context + workout history
- Structured JSON responses parsed into Workout + WorkoutExercise records
- Provider switching: Anthropic (Claude) or xAI (Grok) per user preference

## Key Commands
```bash
bin/rails server          # Start dev server
bin/rails test            # Run unit/integration tests
bin/rails test:system     # Run system tests
bin/dev                   # Start with Procfile.dev (Tailwind watch)
bin/rails db:seed         # Seed muscle groups, exercises, user
```

## Model Relationships
- User -> Mesocycles -> MesocycleVolumes (per muscle group)
- User -> Workouts -> WorkoutExercises -> ExerciseSets
- User -> Runs
- User -> Chats (RubyLLM) -> Messages -> ToolCalls
- MuscleGroup <- Exercises
- Mesocycle tracks weekly volume progression per muscle group
