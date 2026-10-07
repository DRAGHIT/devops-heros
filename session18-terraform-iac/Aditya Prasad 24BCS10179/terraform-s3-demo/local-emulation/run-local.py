import os,sys,subprocess,time,pathlib,json
from moto.server import ThreadedMotoServer
import boto3
server=ThreadedMotoServer(ip_address='127.0.0.1',port=5000,verbose=False);server.start()
os.environ.update(AWS_ACCESS_KEY_ID='testing',AWS_SECRET_ACCESS_KEY='testing',AWS_SESSION_TOKEN='testing',AWS_DEFAULT_REGION='ap-south-1',AWS_EC2_METADATA_DISABLED='true')
base={'region':'ap-south-1','access_key':'testing','secret_key':'testing','skip_credentials_validation':True,'skip_metadata_api_check':True,'skip_requesting_account_id':True,'s3_use_path_style':True,'endpoints':[{'ec2':'http://127.0.0.1:5000','s3':'http://127.0.0.1:5000','sts':'http://127.0.0.1:5000','iam':'http://127.0.0.1:5000','kms':'http://127.0.0.1:5000'}]}
for n,root in [(18,str(pathlib.Path(__file__).resolve().parent.parent))]:
 p=pathlib.Path(root);lab=pathlib.Path(__file__).resolve().parent;lab.mkdir(exist_ok=True)
 # Separate directory: never modifies the production AWS provider, vars or research folders.
 for f in ('main.tf','variables.tf','outputs.tf'): (lab/f).write_text((p/f).read_text())
 (lab/'provider.tf.json').write_text(json.dumps({'terraform':{'required_version':'>= 1.7','required_providers':{'aws':{'source':'hashicorp/aws','version':'~> 6.0'}}},'provider':{'aws':base}},indent=2)+'\n')
 vals={'region':'ap-south-1','bucket_name':f'aditya-24bcs10179-s{n}-moto-local'}
 if n==19:
  ec=boto3.client('ec2',endpoint_url='http://127.0.0.1:5000')
  ami=ec.register_image(Name='moto-mocked-classroom-image',Architecture='x86_64',RootDeviceName='/dev/xvda',VirtualizationType='hvm',BlockDeviceMappings=[{'DeviceName':'/dev/xvda','Ebs':{'SnapshotId':'snap-00000000000000001','VolumeSize':8,'VolumeType':'gp3','DeleteOnTermination':True}}])['ImageId']
  vals.update(ami_id=ami,instance_type='t3.micro')
 (lab/'local.tfvars.json').write_text(json.dumps(vals,indent=2)+'\n')
 (lab/'evidence').mkdir(exist_ok=True)
 log=(lab/'evidence'/'terraform-output.txt').open('w');log.write('LOCAL AWS API EMULATION ONLY. Moto Server; no AWS account or resources. EC2/VPC/SG are mocked API records, not real VM/network.\n')
 def run(args):
  log.write('\n$ terraform '+' '.join(args)+'\n');log.flush()
  r=subprocess.run(['terraform',*args],cwd=lab,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True)
  log.write(r.stdout);log.write(f'Exit code: {r.returncode}\n');log.flush();print(n,args,'exit',r.returncode,flush=True)
  if r.returncode: print(r.stdout[-4500:],flush=True);raise RuntimeError('Terraform failed')
 try:
  run(['version']);run(['init','-backend=false','-no-color']);run(['fmt','-recursive']);run(['validate','-no-color']);run(['plan','-var-file=local.tfvars.json','-out=local.plan','-no-color']);run(['apply','-no-color','local.plan']);run(['show','-no-color']);run(['output','-json'])
  s3=boto3.client('s3',endpoint_url='http://127.0.0.1:5000');bn=vals['bucket_name'];checks={'scope':'LOCAL EMULATION ONLY','bucket_exists':s3.head_bucket(Bucket=bn)['ResponseMetadata']['HTTPStatusCode']==200,'public_access_block':s3.get_public_access_block(Bucket=bn)['PublicAccessBlockConfiguration'],'encryption':s3.get_bucket_encryption(Bucket=bn)['ServerSideEncryptionConfiguration'] if n==18 else 'No explicit S19 encryption resource; no encryption enforcement claimed'}
  s3.put_object(Bucket=bn,Key='verification.txt',Body=b'Local S3 round-trip verified. Not AWS.\n');checks['object_round_trip']=s3.get_object(Bucket=bn,Key='verification.txt')['Body'].read().decode();s3.delete_object(Bucket=bn,Key='verification.txt')
  if n==19:
   ec=boto3.client('ec2',endpoint_url='http://127.0.0.1:5000');r=ec.describe_instances()['Reservations'];checks['mock_instances']=[{'id':i['InstanceId'],'state':i['State'],'subnet':i['SubnetId'],'public_ip_present':'PublicIpAddress' in i} for q in r for i in q['Instances']];checks['custom_vpcs']=[v['VpcId'] for v in ec.describe_vpcs()['Vpcs'] if v['CidrBlock']=='10.19.0.0/16'];checks['mock_security_groups']=[{'id':g['GroupId'],'ingress':g['IpPermissions'],'egress':g['IpPermissionsEgress']} for g in ec.describe_security_groups()['SecurityGroups'] if g['GroupName'].startswith('aditya-s19-')]
  (lab/'evidence'/'api-after-apply.json').write_text(json.dumps(checks,indent=2)+'\n');print(json.dumps(checks),flush=True)
  run(['destroy','-var-file=local.tfvars.json','-auto-approve','-no-color']);run(['show','-no-color']);run(['output','-json'])
  after={'bucket_absent':bn not in [b['Name'] for b in s3.list_buckets()['Buckets']]}
  if n==19: after.update(custom_vpc_absent=not [v for v in ec.describe_vpcs()['Vpcs'] if v['CidrBlock']=='10.19.0.0/16'],mock_instance_states=[i['State']['Name'] for q in ec.describe_instances()['Reservations'] for i in q['Instances']])
  (lab/'evidence'/'api-after-destroy.json').write_text(json.dumps(after,indent=2)+'\n');print(after,flush=True)
  assert after['bucket_absent']
  if n==19: assert after['custom_vpc_absent'] and all(x=='terminated' for x in after['mock_instance_states'])
 finally:log.close()
server.stop()
