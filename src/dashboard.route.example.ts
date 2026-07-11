// Optional adapter for an existing Express-style backend.
// Use this if the project already has Express or a similar router.

import type { Request, Response } from 'express';
import { getDashboard } from './dashboard.service.js';

export async function dashboardRoute(req: Request, res: Response) {
  try {
    const { workspaceId } = req.params;
    const dashboard = await getDashboard(workspaceId);
    return res.status(200).json(dashboard);
  } catch (error: any) {
    return res.status(error.statusCode ?? 500).json({
      error: {
        code: error.code ?? 'INTERNAL_SERVER_ERROR',
        message: error.message ?? 'Unexpected backend error.'
      }
    });
  }
}
