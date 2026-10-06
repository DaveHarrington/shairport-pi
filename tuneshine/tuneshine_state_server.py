import sys

from http.server import BaseHTTPRequestHandler, HTTPServer

class TuneshineStateServer(BaseHTTPRequestHandler):
    def do_GET(self):
        print(f"doing get: {self.path}", file=sys.stderr)
        if self.path == '/':
            try:
                with open('/var/tuneshine-state-request', 'r') as file:
                    content = file.read()
                self.send_response(200)
                self.send_header('Content-type', 'text/plain')
                self.end_headers()
                self.wfile.write(content.encode('utf-8'))
            except FileNotFoundError:
                self.send_response(404)
                self.end_headers()
                self.wfile.write(b'File not found')
        else:
            self.send_response(404)
            self.end_headers()

        print("done get", file=sys.stderr)

def run(server_class=HTTPServer, handler_class=TuneshineStateServer, port=8000):
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    httpd.timeout = 30  # Set the timeout for connections to 10 seconds
    httpd.socket.settimeout(10)
    print(f'Starting server on port {port}', file=sys.stderr)

    # Use a loop to periodically handle requests and check timeouts.
    while True:
        print("Handling next request", file=sys.stderr)
        httpd.handle_request()


if __name__ == '__main__':
    run()
