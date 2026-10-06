const http = require('http');
const fs = require('fs');
const PORT = 8000;

const requestListener = (req, res) => {
  console.error(`Request: ${req.url}`);
  
  if (req.url === '/playing') {
    fs.readFile('/var/tuneshine-state-request', 'utf8', (err, content) => {
      if (err) {
        if (err.code === 'ENOENT') {
          res.writeHead(404, { 'Content-Type': 'text/plain' });
          res.end('File not found');
        } else {
          res.writeHead(500, { 'Content-Type': 'text/plain' });
          res.end('Internal Server Error');
        }
      } else {
        res.writeHead(200, { 'Content-Type': 'text/plain' });
        res.end(content);
      }
    });
  } else if (req.method === 'POST' && req.url === '/log') {
    let data = '';

    req.on('data', chunk => {
            data += chunk;
    });

    req.on('end', () => {
            console.error('Received log data:', data);
            res.writeHead(200, { 'Content-Type': 'text/plain' });
            res.end('Logged successfully');
    });

    req.on('error', (err) => {
            console.error('Error reading request data:', err);
            res.writeHead(500, { 'Content-Type': 'text/plain' });
            res.end('Error processing request');
    });
  } else {
    res.writeHead(404, { 'Content-Type': 'text/plain' });
    res.end('Not Found');
  }

  console.error("Request done");
};

const server = http.createServer(requestListener);

server.listen(PORT, () => {
  console.error(`Starting server on port ${PORT}`);
});

// Set timeout and periodically log activity
server.timeout = 10000; // 10 seconds
setInterval(() => console.error("Handling next request"), 600 * 1000); //10 minutes
