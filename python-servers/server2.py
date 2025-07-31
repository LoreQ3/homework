from http.server import BaseHTTPRequestHandler, HTTPServer

class MyServer(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        self.wfile.write(bytes("<html><body><h1>Server 2 (8888)</h1></body></html>", "utf-8"))

if __name__ == "__main__":
    webServer = HTTPServer(("0.0.0.0", 8888), MyServer)
    print("Server 2 started on port 8888")
    webServer.serve_forever()
