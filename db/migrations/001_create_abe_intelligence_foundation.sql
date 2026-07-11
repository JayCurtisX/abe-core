CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS business_identity_profiles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id uuid NOT NULL,
  business_name text NOT NULL,
  industry text,
  offer_summary text,
  target_customer text,
  current_stage text,
  main_goal text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS live_metrics (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id uuid NOT NULL,
  metric_key text NOT NULL,
  metric_label text NOT NULL,
  metric_value numeric NOT NULL,
  metric_unit text,
  measurement_window text,
  source_type text NOT NULL DEFAULT 'manual',
  measured_at timestamptz NOT NULL DEFAULT now(),
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS live_signals (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id uuid NOT NULL,
  signal_type text NOT NULL,
  title text NOT NULL,
  description text NOT NULL,
  severity text NOT NULL CHECK (severity IN ('low', 'medium', 'high', 'critical')),
  source_type text NOT NULL DEFAULT 'manual',
  signal_data jsonb,
  observed_at timestamptz NOT NULL DEFAULT now(),
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS business_facts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id uuid NOT NULL,
  fact_type text NOT NULL,
  title text NOT NULL,
  body text NOT NULL,
  source_type text NOT NULL DEFAULT 'manual',
  confidence_score integer NOT NULL CHECK (confidence_score >= 0 AND confidence_score <= 100),
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS business_goals (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id uuid NOT NULL,
  title text NOT NULL,
  description text,
  goal_type text NOT NULL,
  target_value numeric,
  current_value numeric,
  unit text,
  due_date date,
  status text NOT NULL CHECK (status IN ('active', 'paused', 'completed', 'canceled')),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS business_state_snapshots (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id uuid NOT NULL,
  state_label text NOT NULL,
  state_summary text NOT NULL,
  why_summary text NOT NULL,
  biggest_constraint text NOT NULL,
  biggest_opportunity text NOT NULL,
  next_best_action text NOT NULL,
  confidence_score integer NOT NULL CHECK (confidence_score >= 0 AND confidence_score <= 100),
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS business_state_scores (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id uuid NOT NULL,
  business_state_snapshot_id uuid NOT NULL REFERENCES business_state_snapshots(id) ON DELETE CASCADE,
  category text NOT NULL,
  score integer NOT NULL CHECK (score >= 0 AND score <= 100),
  status text NOT NULL CHECK (status IN ('healthy', 'watch', 'constrained', 'critical')),
  explanation text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS recommendations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id uuid NOT NULL,
  business_state_snapshot_id uuid REFERENCES business_state_snapshots(id) ON DELETE SET NULL,
  title text NOT NULL,
  rationale text NOT NULL,
  action_type text NOT NULL,
  priority text NOT NULL CHECK (priority IN ('low', 'medium', 'high')),
  status text NOT NULL CHECK (status IN ('pending', 'accepted', 'dismissed', 'completed')),
  confidence_score integer NOT NULL CHECK (confidence_score >= 0 AND confidence_score <= 100),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS activity_timeline_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id uuid NOT NULL,
  actor_type text NOT NULL CHECK (actor_type IN ('user', 'agent', 'system')),
  event_type text NOT NULL,
  title text NOT NULL,
  description text NOT NULL,
  related_table text,
  related_id uuid,
  metadata jsonb,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS evidence (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id uuid NOT NULL,
  belief_type text NOT NULL CHECK (belief_type IN ('business_state', 'score', 'constraint', 'opportunity', 'recommendation')),
  target_table text NOT NULL,
  target_id uuid NOT NULL,
  target_field text,
  source_table text NOT NULL,
  source_id uuid NOT NULL,
  evidence_type text NOT NULL CHECK (evidence_type IN ('metric', 'signal', 'fact', 'goal', 'timeline')),
  summary text NOT NULL,
  strength text NOT NULL CHECK (strength IN ('weak', 'medium', 'strong')),
  weight integer NOT NULL CHECK (weight >= 1 AND weight <= 100),
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_business_identity_profiles_workspace_id
  ON business_identity_profiles(workspace_id);

CREATE INDEX IF NOT EXISTS idx_live_metrics_workspace_key
  ON live_metrics(workspace_id, metric_key);

CREATE INDEX IF NOT EXISTS idx_live_signals_workspace_severity
  ON live_signals(workspace_id, severity);

CREATE INDEX IF NOT EXISTS idx_business_facts_workspace_active
  ON business_facts(workspace_id, is_active);

CREATE INDEX IF NOT EXISTS idx_business_goals_workspace_status
  ON business_goals(workspace_id, status);

CREATE INDEX IF NOT EXISTS idx_business_state_snapshots_workspace_created
  ON business_state_snapshots(workspace_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_business_state_scores_snapshot
  ON business_state_scores(business_state_snapshot_id);

CREATE INDEX IF NOT EXISTS idx_recommendations_workspace_status
  ON recommendations(workspace_id, status);

CREATE INDEX IF NOT EXISTS idx_activity_timeline_workspace_created
  ON activity_timeline_events(workspace_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_evidence_target
  ON evidence(target_table, target_id);

CREATE INDEX IF NOT EXISTS idx_evidence_workspace_belief
  ON evidence(workspace_id, belief_type);
