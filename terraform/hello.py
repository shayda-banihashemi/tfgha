from http.server import HTTPServer, BaseHTTPRequestHandler


class SimpleHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(b"Hello, World from EC2!")


server = HTTPServer(('0.0.0.0', 8080), SimpleHandler)
print("Server started on port 8080")
server.serve_forever()
