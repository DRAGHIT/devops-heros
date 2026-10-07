import json, urllib.request
from pathlib import Path
import sys
mode=sys.argv[1]
root='http://localhost:8000'
def req(path,data=None,method=None):
 payload=None if data is None else json.dumps(data).encode()
 r=urllib.request.urlopen(urllib.request.Request(root+path,data=payload,method=method,headers={'Content-Type':'application/json'}))
 body=r.read().decode()
 print(f'{method or ("POST" if data else "GET")} {path}: HTTP {r.status}')
 return r.status,body
assert req('/health')[1]=='{"status":"UP"}'
assert req('/ready')[1]=='{"status":"READY"}'
assert 'swagger-ui' in req('/docs')[1]
assert 'TaskBoard API' in req('/openapi.json')[1]
assert 'http_requests' in req('/metrics')[1]
task={'title':f'{mode} PostgreSQL proof','description':'Created through actual FastAPI and PostgreSQL','priority':'HIGH','assignee':'Aditya Prasad'}
status,body=req('/api/tasks',task)
assert status==201
item=json.loads(body); tid=item['id']
assert json.loads(req(f'/api/tasks/{tid}')[1])['title']==task['title']
assert json.loads(req(f'/api/tasks/{tid}',{'status':'IN_PROGRESS'},'PUT')[1])['status']=='IN_PROGRESS'
assert any(x['id']==tid for x in json.loads(req('/api/tasks')[1]))
assert json.loads(req('/api/tasks/stats')[1])['inProgress']>=1
status,body=req('/api/tasks',dict(task,title='Temporary delete proof'))
delete_id=json.loads(body)['id']
assert req(f'/api/tasks/{delete_id}',method='DELETE')[0]==204
print('CRUD and PostgreSQL readiness checks PASS. Kept one proof task for UI/database evidence.')
assert urllib.request.urlopen('http://localhost:3000').status==200
print('GET http://localhost:3000: HTTP 200')
