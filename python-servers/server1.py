from http.server import BaseHTTPRequestHandler, HTTPServer

class MyServer(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        self.wfile.write(bytes("<html><body><h1>Server 1 (7777)</h1></body></html>", "utf-8"))

if __name__ == "__main__":
    webServer = HTTPServer(("0.0.0.0", 7777), MyServer)
    print("Server 1 started on port 7777")
    webServer.serve_forever()
