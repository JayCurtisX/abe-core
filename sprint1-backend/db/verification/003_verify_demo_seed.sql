\echo 'ABE Sprint 1 seed verification'

SELECT 'business_identity_profiles' AS table_name, count(*) AS record_count
FROM business_identity_profiles
WHERE workspace_id = '00000000-0000-0000-0000-000000000001'
UNION ALL
SELECT 'live_metrics', count(*)
FROM live_metrics
WHERE workspace_id = '00000000-0000-0000-0000-000000000001'
UNION ALL
SELECT 'live_signals', count(*)
FROM live_signals
WHERE workspace_id = '00000000-0000-0000-0000-000000000001'
UNION ALL
SELECT 'business_facts', count(*)
FROM business_facts
WHERE workspace_id = '00000000-0000-0000-0000-000000000001'
UNION ALL
SELECT 'business_goals', count(*)
FROM business_goals
WHERE workspace_id = '00000000-0000-0000-0000-000000000001'
UNION ALL
SELECT 'business_state_snapshots', count(*)
FROM business_state_snapshots
WHERE workspace_id = '00000000-0000-0000-0000-000000000001'
UNION ALL
SELECT 'business_state_scores', count(*)
FROM business_state_scores
WHERE workspace_id = '00000000-0000-0000-0000-000000000001'
UNION ALL
SELECT 'recommendations', count(*)
FROM recommendations
WHERE workspace_id = '00000000-0000-0000-0000-000000000001'
UNION ALL
SELECT 'evidence', count(*)
FROM evidence
WHERE workspace_id = '00000000-0000-0000-0000-000000000001'
UNION ALL
SELECT 'activity_timeline_events', count(*)
FROM activity_timeline_events
WHERE workspace_id = '00000000-0000-0000-0000-000000000001';

SELECT
  s.state_label,
  s.why_summary,
  s.biggest_constraint,
  s.biggest_opportunity,
  s.next_best_action,
  s.confidence_score
FROM business_state_snapshots s
WHERE s.workspace_id = '00000000-0000-0000-0000-000000000001'
ORDER BY s.created_at DESC
LIMIT 1;
