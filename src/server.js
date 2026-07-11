import http from 'node:http';
import handler from './handler.js';

const port = Number(process.env.PORT ?? 3001);

const server = http.createServer(handler);

server.listen(port, () => {
  console.log(`ABE Sprint 1 backend listening on http://localhost:${port}`);
});
