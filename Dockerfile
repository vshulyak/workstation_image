FROM vshulyak/workstation_base:bfad18ea4588a0d5116a2e5dd1a6798c2848d1aa
#
# !Use squash build!
# It's imperative that you use squash build as the image is optimized for readability
#

RUN useradd -m jupyter && \
    mkdir /mnt/notebooks && chown jupyter:jupyter /mnt/notebooks && \
    mkdir /mnt/data && chown jupyter:jupyter /mnt/data && \
    mkdir /mnt/mlflow && chown jupyter:jupyter /mnt/mlflow && \
    mkdir /etc/service/jupyter && \
    mkdir /etc/service/mount_data && \
    mkdir /etc/service/mount_notebooks && \
    mkdir -p /etc/my_init.d && \
    mkdir -p /home/jupyter/.ipython/profile_default/startup && \
    mkdir -p /home/jupyter/.jupyter && \
    chown jupyter:jupyter /home/jupyter/.jupyter  && \
    chown -R jupyter:jupyter /home/jupyter/.ipython


ENV SPARK_DOWNLOAD_URL=http://mirror.linux-ia64.org/apache/spark/spark-2.4.0/spark-2.4.0-bin-hadoop2.7.tgz \
    SPARK_HOME=/usr/lib/spark \
    SCALA_VERSION=2.12.8 \
    ALMOND_VERSION=0.2.1

RUN mkdir /usr/lib/spark && \
    wget -qO - ${SPARK_DOWNLOAD_URL} | tar -xz -C $SPARK_HOME --strip-components 1 && \
    curl -L -o /usr/bin/coursier https://git.io/coursier &&     chmod +x /usr/bin/coursier && \
    coursier bootstrap -r jitpack -i user -I user:sh.almond:scala-kernel-api_$SCALA_VERSION:$ALMOND_VERSION  sh.almond:scala-kernel_$SCALA_VERSION:$ALMOND_VERSION  --sources --default=true -o /usr/bin/almond && \
    /usr/bin/almond --install

# Install inline dependencies, which are referenced here in the Dockerfile and/or have custome setup.
# Putting them here, rather than in the conda env file makes the whole process clear.
ENV DOCKERFILE_PYTHON_DEPS="toree==0.3.0 nbresuse line-profiler psutil memory_profiler lazy-object-proxy==1.3.1 findspark==1.1.0"

# Update anaconda deps
COPY conf/conda/root_env.yml /tmp/root_env.yml
RUN /opt/conda/bin/conda env update -f /tmp/root_env.yml && \
    /opt/conda/bin/pip install ${DOCKERFILE_PYTHON_DEPS} && \
    /opt/conda/bin/jupyter contrib nbextension install --system && \
    /sbin/setuser jupyter /opt/conda/bin/jupyter nbextension enable zenmode/main && \
    /sbin/setuser jupyter /opt/conda/bin/jupyter nbextension enable collapsible_headings/main && \
    /sbin/setuser jupyter /opt/conda/bin/jupyter nbextension enable snippets_menu/main && \
    /sbin/setuser jupyter /opt/conda/bin/jupyter nbextension enable execute_time/ExecuteTime && \
    /sbin/setuser jupyter /opt/conda/bin/jupyter nbextension enable toc2/main && \
    /sbin/setuser jupyter /opt/conda/bin/jupyter nbextension enable notify/notify && \
    /opt/conda/bin/jupyter labextension install @jupyterlab/toc && \
    /opt/conda/bin/jupyter serverextension enable --py nbresuse && \
    /opt/conda/bin/jupyter labextension install @jupyterlab/statusbar && \
    /opt/conda/bin/python -m spacy download en

# Install toree
RUN /opt/conda/bin/jupyter toree install --replace --spark_home=$SPARK_HOME --spark_opts="--master=local[*]"

# Override Tensorflow, so that we have a custom & optimized version
RUN /opt/conda/bin/pip install --upgrade https://github.com/vshulyak/docker-tensorflow-builder/releases/download/v1.12.0cpu-1/tensorflow-1.12.0-cp36-cp36m-linux_x86_64.whl

# Cleanup
RUN /opt/conda/bin/conda clean --all -y && \
    rm -rf /opt/conda/pkgs

# Configure profiles
COPY conf/jupyter/ipython_config.py /home/jupyter/.ipython/profile_default/ipython_config.py

# Configure lazy findspark
COPY conf/jupyter/00_findspark.py /home/jupyter/.ipython/profile_default/startup/00_findspark.py

# Configure custom metastore for Spark
COPY conf/spark/hive-site.xml /usr/lib/spark/conf/

# Add all background services
COPY services/run_jupyter.sh /etc/service/jupyter/run
COPY services/run_mlflow.sh /etc/service/mlflow/run
COPY services/run_mount_data.sh /etc/service/mount_data/run
COPY services/run_mount_mlflow.sh /etc/service/mount_mlflow/run
COPY services/run_mount_notebooks.sh /etc/service/mount_notebooks/run
COPY services/run_tensorboard.sh /etc/service/tensorboard/run

COPY conf/conda/keras.json /home/jupyter/.keras/keras.json
COPY conf/jupyter/jupyter_notebook_config.py /home/jupyter/.jupyter/jupyter_notebook_config.py

RUN chmod 755 /etc/service/jupyter/run && \
    chmod 755 /etc/service/mlflow/run && \
    chmod 755 /etc/service/mount_data/run && \
    chmod 755 /etc/service/mount_mlflow/run && \
    chmod 755 /etc/service/mount_notebooks/run && \
    chmod 755 /etc/service/tensorboard/run
