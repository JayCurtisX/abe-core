DO $$
DECLARE
  demo_workspace_id uuid := '00000000-0000-0000-0000-000000000001';
  identity_id uuid := '10000000-0000-0000-0000-000000000001';
  metric_new_leads_id uuid := '20000000-0000-0000-0000-000000000001';
  metric_contacted_leads_id uuid := '20000000-0000-0000-0000-000000000002';
  metric_uncontacted_leads_id uuid := '20000000-0000-0000-0000-000000000003';
  metric_overdue_tasks_id uuid := '20000000-0000-0000-0000-000000000004';
  metric_pipeline_id uuid := '20000000-0000-0000-0000-000000000005';
  signal_followup_delay_id uuid := '30000000-0000-0000-0000-000000000001';
  signal_pipeline_opportunity_id uuid := '30000000-0000-0000-0000-000000000002';
  fact_followup_id uuid := '40000000-0000-0000-0000-000000000001';
  goal_sales_calls_id uuid := '50000000-0000-0000-0000-000000000001';
  snapshot_id uuid := '70000000-0000-0000-0000-000000000001';
  score_sales_id uuid := '80000000-0000-0000-0000-000000000001';
  score_followup_id uuid := '80000000-0000-0000-0000-000000000002';
  score_operations_id uuid := '80000000-0000-0000-0000-000000000003';
  score_pipeline_id uuid := '80000000-0000-0000-0000-000000000004';
  recommendation_id uuid := '90000000-0000-0000-0000-000000000001';
BEGIN

  DELETE FROM evidence WHERE workspace_id = demo_workspace_id;
  DELETE FROM activity_timeline_events WHERE workspace_id = demo_workspace_id;
  DELETE FROM recommendations WHERE workspace_id = demo_workspace_id;
  DELETE FROM business_state_scores WHERE workspace_id = demo_workspace_id;
  DELETE FROM business_state_snapshots WHERE workspace_id = demo_workspace_id;
  DELETE FROM business_goals WHERE workspace_id = demo_workspace_id;
  DELETE FROM business_facts WHERE workspace_id = demo_workspace_id;
  DELETE FROM live_signals WHERE workspace_id = demo_workspace_id;
  DELETE FROM live_metrics WHERE workspace_id = demo_workspace_id;
  DELETE FROM business_identity_profiles WHERE workspace_id = demo_workspace_id;

  INSERT INTO business_identity_profiles (
    id,
    workspace_id,
    business_name,
    industry,
    offer_summary,
    target_customer,
    current_stage,
    main_goal,
    created_at,
    updated_at
  ) VALUES (
    identity_id,
    demo_workspace_id,
    'ABE Demo Business',
    'Service Business',
    'Business systems, automation, and operational support for growing companies.',
    'Small business owners who need better follow-up, sales visibility, and execution systems.',
    'growing',
    'Book 20 sales calls',
    '2026-07-10T09:00:00-07:00',
    '2026-07-10T09:00:00-07:00'
  );

  INSERT INTO live_metrics (
    id, workspace_id, metric_key, metric_label, metric_value, metric_unit, measurement_window, source_type, measured_at, created_at
  ) VALUES
    (metric_new_leads_id, demo_workspace_id, 'new_leads', 'New Leads', 12, 'count', 'current', 'demo_seed', '2026-07-10T09:00:00-07:00', '2026-07-10T09:00:00-07:00'),
    (metric_contacted_leads_id, demo_workspace_id, 'contacted_leads', 'Contacted Leads', 4, 'count', 'current', 'demo_seed', '2026-07-10T09:00:00-07:00', '2026-07-10T09:00:00-07:00'),
    (metric_uncontacted_leads_id, demo_workspace_id, 'uncontacted_leads', 'Uncontacted Leads', 8, 'count', 'current', 'demo_seed', '2026-07-10T09:00:00-07:00', '2026-07-10T09:00:00-07:00'),
    (metric_overdue_tasks_id, demo_workspace_id, 'overdue_tasks', 'Overdue Tasks', 7, 'count', 'current', 'demo_seed', '2026-07-10T09:00:00-07:00', '2026-07-10T09:00:00-07:00'),
    (metric_pipeline_id, demo_workspace_id, 'estimated_pipeline_value', 'Estimated Pipeline Value', 32000, 'currency', 'current', 'demo_seed', '2026-07-10T09:00:00-07:00', '2026-07-10T09:00:00-07:00');

  INSERT INTO live_signals (
    id, workspace_id, signal_type, title, description, severity, source_type, signal_data, observed_at, created_at
  ) VALUES
    (
      signal_followup_delay_id,
      demo_workspace_id,
      'lead_followup_delay',
      'Lead follow-up is delayed',
      '8 of 12 new leads have not been contacted.',
      'high',
      'demo_seed',
      '{"newLeads":12,"contactedLeads":4,"uncontactedLeads":8}'::jsonb,
      '2026-07-10T09:01:00-07:00',
      '2026-07-10T09:01:00-07:00'
    ),
    (
      signal_pipeline_opportunity_id,
      demo_workspace_id,
      'pipeline_opportunity',
      'Warm pipeline exists',
      'The business has an estimated pipeline value of 32000.',
      'high',
      'demo_seed',
      '{"estimatedPipelineValue":32000}'::jsonb,
      '2026-07-10T09:01:00-07:00',
      '2026-07-10T09:01:00-07:00'
    );

  INSERT INTO business_facts (
    id, workspace_id, fact_type, title, body, source_type, confidence_score, is_active, created_at, updated_at
  ) VALUES (
    fact_followup_id,
    demo_workspace_id,
    'sales_process',
    'Fast follow-up drives sales conversion',
    'This business depends on turning new leads into booked calls quickly.',
    'demo_seed',
    90,
    true,
    '2026-07-10T09:00:00-07:00',
    '2026-07-10T09:00:00-07:00'
  );

  INSERT INTO business_goals (
    id, workspace_id, title, description, goal_type, target_value, current_value, unit, status, created_at, updated_at
  ) VALUES (
    goal_sales_calls_id,
    demo_workspace_id,
    'Book 20 sales calls',
    'The business is trying to book 20 sales calls from current and incoming leads.',
    'sales',
    20,
    0,
    'calls',
    'active',
    '2026-07-10T09:00:00-07:00',
    '2026-07-10T09:00:00-07:00'
  );

  INSERT INTO business_state_snapshots (
    id,
    workspace_id,
    state_label,
    state_summary,
    why_summary,
    biggest_constraint,
    biggest_opportunity,
    next_best_action,
    confidence_score,
    created_at
  ) VALUES (
    snapshot_id,
    demo_workspace_id,
    'Growth Constraint Mode',
    'The business has demand, but growth is constrained by delayed follow-up.',
    'The business has demand, but follow-up is delayed.',
    'Lead follow-up',
    'Convert warm leads into booked calls',
    'Prepare follow-up drafts and same-day call tasks',
    82,
    '2026-07-10T09:01:00-07:00'
  );

  INSERT INTO business_state_scores (
    id, workspace_id, business_state_snapshot_id, category, score, status, explanation, created_at
  ) VALUES
    (score_sales_id, demo_workspace_id, snapshot_id, 'sales', 64, 'watch', 'There is meaningful demand, but sales movement is limited by delayed follow-up.', '2026-07-10T09:01:00-07:00'),
    (score_followup_id, demo_workspace_id, snapshot_id, 'follow_up', 35, 'critical', '8 of 12 new leads have not been contacted.', '2026-07-10T09:01:00-07:00'),
    (score_operations_id, demo_workspace_id, snapshot_id, 'operations', 48, 'constrained', '7 overdue tasks indicate operational drag.', '2026-07-10T09:01:00-07:00'),
    (score_pipeline_id, demo_workspace_id, snapshot_id, 'pipeline', 78, 'healthy', 'The business has 32000 in estimated pipeline value.', '2026-07-10T09:01:00-07:00');

  INSERT INTO recommendations (
    id, workspace_id, business_state_snapshot_id, title, rationale, action_type, priority, status, confidence_score, created_at, updated_at
  ) VALUES (
    recommendation_id,
    demo_workspace_id,
    snapshot_id,
    'Prepare follow-up drafts and same-day call tasks',
    'The fastest path to progress is contacting the 8 uncontacted leads while demand is still warm.',
    'draft_follow_up_and_create_tasks',
    'high',
    'pending',
    82,
    '2026-07-10T09:03:00-07:00',
    '2026-07-10T09:03:00-07:00'
  );

  INSERT INTO evidence (
    id, workspace_id, belief_type, target_table, target_id, target_field, source_table, source_id, evidence_type, summary, strength, weight, created_at
  ) VALUES
    ('60000000-0000-0000-0000-000000000001', demo_workspace_id, 'business_state', 'business_state_snapshots', snapshot_id, 'state_label', 'live_metrics', metric_new_leads_id, 'metric', '12 new leads show current demand.', 'strong', 90, '2026-07-10T09:01:00-07:00'),
    ('60000000-0000-0000-0000-000000000002', demo_workspace_id, 'business_state', 'business_state_snapshots', snapshot_id, 'state_label', 'live_metrics', metric_uncontacted_leads_id, 'metric', '8 uncontacted leads show follow-up delay.', 'strong', 95, '2026-07-10T09:01:00-07:00'),
    ('60000000-0000-0000-0000-000000000003', demo_workspace_id, 'constraint', 'business_state_snapshots', snapshot_id, 'biggest_constraint', 'live_signals', signal_followup_delay_id, 'signal', 'Lead follow-up delay is the strongest active constraint.', 'strong', 95, '2026-07-10T09:02:00-07:00'),
    ('60000000-0000-0000-0000-000000000004', demo_workspace_id, 'opportunity', 'business_state_snapshots', snapshot_id, 'biggest_opportunity', 'live_metrics', metric_pipeline_id, 'metric', '32000 in estimated pipeline creates a clear conversion opportunity.', 'strong', 90, '2026-07-10T09:02:00-07:00'),
    ('60000000-0000-0000-0000-000000000005', demo_workspace_id, 'score', 'business_state_scores', score_followup_id, 'score', 'live_metrics', metric_uncontacted_leads_id, 'metric', 'Follow-up score is low because 8 of 12 leads are uncontacted.', 'strong', 95, '2026-07-10T09:02:00-07:00'),
    ('60000000-0000-0000-0000-000000000006', demo_workspace_id, 'score', 'business_state_scores', score_operations_id, 'score', 'live_metrics', metric_overdue_tasks_id, 'metric', 'Operations score is constrained because 7 tasks are overdue.', 'medium', 75, '2026-07-10T09:02:00-07:00'),
    ('60000000-0000-0000-0000-000000000007', demo_workspace_id, 'recommendation', 'recommendations', recommendation_id, 'action_type', 'business_goals', goal_sales_calls_id, 'goal', 'The active goal is to book 20 sales calls, so follow-up tasks directly support the goal.', 'strong', 85, '2026-07-10T09:03:00-07:00'),
    ('60000000-0000-0000-0000-000000000008', demo_workspace_id, 'recommendation', 'recommendations', recommendation_id, 'rationale', 'business_facts', fact_followup_id, 'fact', 'The business depends on fast follow-up to convert leads into booked calls.', 'strong', 85, '2026-07-10T09:03:00-07:00');

  INSERT INTO activity_timeline_events (
    id, workspace_id, actor_type, event_type, title, description, related_table, related_id, metadata, created_at
  ) VALUES
    ('a0000000-0000-0000-0000-000000000001', demo_workspace_id, 'system', 'demo.leads_entered', '12 new leads entered the system', '12 new leads were added to business memory for the demo workspace.', 'live_metrics', metric_new_leads_id, '{"demo":true,"newLeads":12}'::jsonb, '2026-07-10T09:00:00-07:00'),
    ('a0000000-0000-0000-0000-000000000002', demo_workspace_id, 'agent', 'business_state.analyzed', 'ABE identified Growth Constraint Mode', 'ABE determined the business is in Growth Constraint Mode.', 'business_state_snapshots', snapshot_id, '{"confidenceScore":82}'::jsonb, '2026-07-10T09:01:00-07:00'),
    ('a0000000-0000-0000-0000-000000000003', demo_workspace_id, 'agent', 'constraint.identified', 'ABE identified lead follow-up as the biggest constraint', 'ABE found that 8 leads are uncontacted and 7 tasks are overdue.', 'business_state_snapshots', snapshot_id, '{"constraint":"Lead follow-up"}'::jsonb, '2026-07-10T09:02:00-07:00'),
    ('a0000000-0000-0000-0000-000000000004', demo_workspace_id, 'agent', 'recommendation.created', 'ABE prepared the next recommendation', 'ABE recommended preparing follow-up drafts and same-day call tasks.', 'recommendations', recommendation_id, '{"priority":"high"}'::jsonb, '2026-07-10T09:03:00-07:00');

END $$;
