import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import { mapDashboardResponse } from '../src/dashboard.mapper.js';

const workspaceId = '00000000-0000-0000-0000-000000000001';

const seededInput = {
  workspaceId,
  identity: {
    business_name: 'ABE Demo Business',
    industry: 'Service Business',
    main_goal: 'Book 20 sales calls'
  },
  latestState: {
    state_label: 'Growth Constraint Mode',
    why_summary: 'The business has demand, but follow-up is delayed.',
    confidence_score: 82,
    biggest_constraint: 'Lead follow-up',
    biggest_opportunity: 'Convert warm leads into booked calls',
    next_best_action: 'Prepare follow-up drafts and same-day call tasks'
  },
  metrics: [
    { metric_key: 'new_leads', metric_value: '12' },
    { metric_key: 'contacted_leads', metric_value: '4' },
    { metric_key: 'uncontacted_leads', metric_value: '8' },
    { metric_key: 'overdue_tasks', metric_value: '7' },
    { metric_key: 'estimated_pipeline_value', metric_value: '32000' }
  ],
  activeGoal: {
    title: 'Book 20 sales calls'
  },
  recentActivity: [
    {
      id: 'a0000000-0000-0000-0000-000000000001',
      title: '12 new leads entered the system',
      created_at: '2026-07-10T09:00:00'
    },
    {
      id: 'a0000000-0000-0000-0000-000000000002',
      title: 'ABE identified Growth Constraint Mode',
      created_at: '2026-07-10T09:01:00'
    }
  ]
};

test('dashboard response matches Developer B contract', () => {
  const response = mapDashboardResponse(seededInput);

  assert.deepEqual(response, {
    workspaceId,
    businessState: {
      state: 'Growth Constraint Mode',
      why: 'The business has demand, but follow-up is delayed.',
      confidence: 82,
      biggestConstraint: 'Lead follow-up',
      biggestOpportunity: 'Convert warm leads into booked calls',
      nextAction: 'Prepare follow-up drafts and same-day call tasks'
    },
    metrics: {
      newLeads: 12,
      contactedLeads: 4,
      uncontactedLeads: 8,
      overdueTasks: 7,
      estimatedPipeline: 32000,
      goal: 'Book 20 sales calls'
    },
    recentActivity: [
      {
        id: 'a0000000-0000-0000-0000-000000000001',
        label: '12 new leads entered the system',
        timestamp: '2026-07-10T09:00:00'
      },
      {
        id: 'a0000000-0000-0000-0000-000000000002',
        label: 'ABE identified Growth Constraint Mode',
        timestamp: '2026-07-10T09:01:00'
      }
    ],
    dataLabel: 'Demo Data'
  });
});

test('invalid workspace returns no dashboard payload for route-level 404 handling', () => {
  const response = mapDashboardResponse({
    workspaceId: '11111111-1111-1111-1111-111111111111',
    identity: null,
    latestState: null,
    metrics: [],
    activeGoal: null,
    recentActivity: []
  });

  assert.equal(response, null);
});

test('dashboard service queries are scoped by workspace_id', () => {
  const servicePath = path.resolve('src/dashboard.service.js');
  const source = fs.readFileSync(servicePath, 'utf8');
  const workspaceFilterCount = (source.match(/WHERE workspace_id = \$1/g) ?? []).length;

  assert.equal(workspaceFilterCount, 5);
});
