export function toNumber(value) {
  if (value === null || value === undefined) return null;
  const numeric = Number(value);
  return Number.isFinite(numeric) ? numeric : null;
}

export function metricValue(metricsByKey, key, fallback = 0) {
  const metric = metricsByKey[key];
  if (!metric) return fallback;
  return toNumber(metric.metric_value) ?? fallback;
}

export function mapDashboardResponse({
  workspaceId,
  identity,
  latestState,
  metrics,
  activeGoal,
  recentActivity
}) {
  if (!workspaceId || !identity || !latestState) {
    return null;
  }

  const metricsByKey = Object.fromEntries(
    metrics.map((metric) => [metric.metric_key, metric])
  );

  return {
    workspaceId,
    businessState: {
      state: latestState.state_label,
      why: latestState.why_summary,
      confidence: toNumber(latestState.confidence_score) ?? 0,
      biggestConstraint: latestState.biggest_constraint,
      biggestOpportunity: latestState.biggest_opportunity,
      nextAction: latestState.next_best_action
    },
    metrics: {
      newLeads: metricValue(metricsByKey, 'new_leads'),
      contactedLeads: metricValue(metricsByKey, 'contacted_leads'),
      uncontactedLeads: metricValue(metricsByKey, 'uncontacted_leads'),
      overdueTasks: metricValue(metricsByKey, 'overdue_tasks'),
      estimatedPipeline: metricValue(metricsByKey, 'estimated_pipeline_value'),
      goal: activeGoal?.title ?? identity.main_goal ?? null
    },
    recentActivity: recentActivity.map((event) => ({
      id: event.id,
      label: event.title,
      timestamp: event.created_at instanceof Date
        ? event.created_at.toISOString()
        : event.created_at
    })),
    dataLabel: 'Demo Data'
  };
}
