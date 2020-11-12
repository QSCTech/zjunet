#!/usr/bin/env python3
import os
import sys
import json
import urllib3
import base64
import datetime

def get_time(s):
    if 'fromisoformat' in dir(datetime.datetime):
        return datetime.datetime.fromisoformat(s.replace('Z', '+00:00'))
    else:
        return __import__('dateutil.parser').parser.parse(s)

http = urllib3.PoolManager()

GITHUB_AUTH = None
tok = os.getenv('GITHUB_TOKEN')
usn = os.getenv('GITHUB_USERNAME')
psw = os.getenv('GITHUB_PASSWORD')
if tok is not None:
    GITHUB_AUTH = 'token {}'.format(tok)
elif usn is not None and psw is not None:
    GITHUB_AUTH = 'Basic {}'.format(base64.b64encode('{}:{}'.format(usn, psw).encode('utf-8')).decode('utf-8'))

def get(url):
    headers = {
        'Accept': 'application/vnd.github.v3+json',
        'User-Agent': 'zjunet-build-agent/0.1',
    }
    if GITHUB_AUTH is not None:
        headers['Authorization'] = GITHUB_AUTH
    r = http.request('GET', url, headers=headers)
    assert r.status // 100 == 2, 'HTTP Status {} != 2xx while requesting {}'.format(r.status, url)
    if r.status != 200:
        print('WARNING: HTTP {} while requesting {}'.format(r.status, url))
    return r.data

def api_get(url):
    return json.loads(get('https://api.github.com/' + url))

author_cache = {}
def get_author(name):
    if name in author_cache:
        return author_cache[name]
    print('Reading data for {}'.format(name), end=' : ', flush=True, file=sys.stderr)
    data = api_get('users/{}'.format(name))
    data = {
        'name': data['name'],
        'email': data['email'],
    }
    author_cache[name] = data
    print('{} <{}>'.format(data['name'], data['email']), flush=True, file=sys.stderr)
    return data

def get_changelog(owner, name):
    print('Reading releases of {1} in {0}'.format(owner, name), flush=True, file=sys.stderr)
    releases = api_get('repos/{}/{}/releases'.format(owner, name))
    releases = filter(lambda v: not v['draft'] and not v['prerelease'], releases)

    data = []
    for rel in releases:
        name = rel['name'] or rel['tag_name']
        item = {
            'time': get_time(rel['published_at']),
            'name': name,
            'version': name[name.rfind('v') + 1:].split(','),
            'author': get_author(rel['author']['login']),
            'changes': None,
        }
        tbody = rel['body'].strip()
        if tbody != '':
            if tbody[0] != '-' and '\n' not in tbody:
                item['changes'] = '- ' + tbody
            else:
                item['changes'] = tbody

        data.append(item)
    return ChangeLog(data)

class ChangeLog:
    def __init__(self, data):
        self.raw = data
    def rpm(self):
        rel = '%changelog\n'
        for item in self.raw:
            rel += '* {} {} <{}> - {}\n'.format(item['time'].strftime('%a %b %d %Y'), item['author']['name'], item['author']['email'], '.'.join(item['version']))
            if item['changes'] is not None:
                rel += item['changes'] + '\n'
        return rel

available_formats = dir(ChangeLog)

if len(sys.argv) != 2:
    print('Usage: {} <format>\nAvailable formats: {}'.format(sys.argv[0], ','.join(ChangeLog)))
else:
    changelog = get_changelog('QSCTech', 'zjunet')
    if hasattr(changelog, sys.argv[1]):
        print(getattr(changelog, sys.argv[1])())
    else:
        print('Invalid format {}\nAvailable formats: {}'.format())
