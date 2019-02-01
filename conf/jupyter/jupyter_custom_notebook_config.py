import os

JUPYTER_PORT = os.environ.get('JUPYTER_PASS', 8888)
JUPYTER_PASS_HASH = os.environ['JUPYTER_PASS_HASH']
JUPYTER_NB_BUCKET_MOUNT = os.environ['JUPYTER_NB_BUCKET_MOUNT']
JUPYTER_NB_BUCKET = os.environ['JUPYTER_NB_BUCKET']

c.NotebookApp.open_browser = False
c.NotebookApp.ip = '0.0.0.0'
c.NotebookApp.port = JUPYTER_PORT
c.NotebookApp.password = JUPYTER_PASS_HASH
c.NotebookApp.notebook_dir = JUPYTER_NB_BUCKET_MOUNT
c.FileManagerMixin.use_atomic_writing = False  # Helps to deal with goofys S3 mount


#
# If you need to use S3Contents
#
# from s3contents import S3ContentsManager
# AWS_ACCESS_KEY = os.environ['AWS_ACCESS_KEY']
# AWS_SECRET_KEY = os.environ['AWS_SECRET_KEY']
# c.NotebookApp.contents_manager_class = S3ContentsManager
# c.S3ContentsManager.access_key_id = AWS_ACCESS_KEY
# c.S3ContentsManager.secret_access_key = AWS_SECRET_KEY
# c.S3ContentsManager.bucket = JUPYTER_NB_BUCKET
# c.S3ContentsManager.prefix = 'notebooks'
