from http.server import BaseHTTPRequestHandler, HTTPServer

class MyServer(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        self.wfile.write(bytes("<html><body><h1>Server 3 (9999)</h1></body></html>", "utf-8"))

if __name__ == "__main__":
    webServer = HTTPServer(("0.0.0.0", 9999), MyServer)
    print("Server 3 started on port 9999")
    webServer.serve_forever()
