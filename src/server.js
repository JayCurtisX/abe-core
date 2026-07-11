import http from 'node:http';
import { URL } from 'node:url';
import { getDashboard } from './dashboard.service.js';

const port = Number(process.env.PORT ?? 3001);

function sendJson(res, statusCode, payload) {
  res.writeHead(statusCode, {
    'Content-Type': 'application/json',
    'Cache-Control': 'no-store'
  });
  res.end(JSON.stringify(payload, null, 2));
}

function getDashboardWorkspaceId(reqUrl) {
  const url = new URL(reqUrl, `http://localhost:${port}`);
  const match = url.pathname.match(/^\/api\/workspaces\/([^/]+)\/dashboard$/);
  return match ? decodeURIComponent(match[1]) : null;
}

const server = http.createServer(async (req, res) => {
  if (req.method === 'GET') {
    const workspaceId = getDashboardWorkspaceId(req.url);

    if (workspaceId) {
      try {
        const dashboard = await getDashboard(workspaceId);
        sendJson(res, 200, dashboard);
      } catch (error) {
        sendJson(res, error.statusCode ?? 500, {
          error: {
            code: error.code ?? 'INTERNAL_SERVER_ERROR',
            message: error.message ?? 'Unexpected backend error.'
          }
        });
      }
      return;
    }
  }

  sendJson(res, 404, {
    error: {
      code: 'ROUTE_NOT_FOUND',
      message: 'Route not found.'
    }
  });
});

server.listen(port, () => {
  console.log(`ABE Sprint 1 backend listening on http://localhost:${port}`);
});
