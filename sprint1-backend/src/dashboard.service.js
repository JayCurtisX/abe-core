import { query } from './db.js';
import { mapDashboardResponse } from './dashboard.mapper.js';

const REQUIRED_METRIC_KEYS = [
  'new_leads',
  'contacted_leads',
  'uncontacted_leads',
  'overdue_tasks',
  'estimated_pipeline_value'
];

export async function getDashboard(workspaceId) {
  const [identityResult, stateResult, metricsResult, goalResult, activityResult] = await Promise.all([
    query(
      `SELECT id, workspace_id, business_name, industry, main_goal
       FROM business_identity_profiles
       WHERE workspace_id = $1
       ORDER BY created_at DESC
       LIMIT 1`,
      [workspaceId]
    ),
    query(
      `SELECT id, workspace_id, state_label, state_summary, why_summary,
              biggest_constraint, biggest_opportunity, next_best_action,
              confidence_score, created_at
       FROM business_state_snapshots
       WHERE workspace_id = $1
       ORDER BY created_at DESC
       LIMIT 1`,
      [workspaceId]
    ),
    query(
      `SELECT id, workspace_id, metric_key, metric_label, metric_value,
              metric_unit, measurement_window, measured_at
       FROM live_metrics
       WHERE workspace_id = $1
         AND metric_key = ANY($2::text[])
       ORDER BY measured_at DESC`,
      [workspaceId, REQUIRED_METRIC_KEYS]
    ),
    query(
      `SELECT id, workspace_id, title, target_value, current_value, unit, status
       FROM business_goals
       WHERE workspace_id = $1
         AND status = 'active'
       ORDER BY created_at DESC
       LIMIT 1`,
      [workspaceId]
    ),
    query(
      `SELECT id, workspace_id, actor_type, event_type, title, description, created_at
       FROM activity_timeline_events
       WHERE workspace_id = $1
       ORDER BY created_at ASC
       LIMIT 4`,
      [workspaceId]
    )
  ]);

  const dashboard = mapDashboardResponse({
    workspaceId,
    identity: identityResult.rows[0] ?? null,
    latestState: stateResult.rows[0] ?? null,
    metrics: metricsResult.rows,
    activeGoal: goalResult.rows[0] ?? null,
    recentActivity: activityResult.rows
  });

  if (!dashboard) {
    const error = new Error('Dashboard data was not found for this workspace.');
    error.statusCode = 404;
    error.code = 'DASHBOARD_NOT_FOUND';
    throw error;
  }

  return dashboard;
}
