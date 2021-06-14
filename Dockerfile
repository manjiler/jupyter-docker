from debian:buster-slim


ARG SPARK_VERSION
ARG HADOOP_VERSION
ARG ANACONDA_VERSION

RUN apt-get update && \
    apt-get install -y build-essential libssl-dev zlib1g-dev zip unzip bzip2 wget procps && \
    rm -rf /var/lib/apt/lists/*

# Install anaconda package
RUN wget -q https://repo.continuum.io/archive/Anaconda3-${ANACONDA_VERSION}-Linux-x86_64.sh && \
    mv Anaconda3-${ANACONDA_VERSION}-Linux-x86_64.sh /tmp && \
    chmod +x /tmp/Anaconda3-${ANACONDA_VERSION}-Linux-x86_64.sh && \
    /bin/bash /tmp/Anaconda3-${ANACONDA_VERSION}-Linux-x86_64.sh -b -p /root/anaconda3 && \
    rm -f /tmp/Anaconda3-${ANACONDA_VERSION}-Linux-x86_64.sh

ENV PATH $PATH:/root/anaconda3/bin

### Install openjdk 11
RUN mkdir -p /usr/share/man/man1/ &&\
    apt-get -y update &&\
    apt-get install --no-install-recommends -y openjdk-11-jdk ca-certificates-java wget make zip && \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
    rm -rf /var/lib/apt/lists/*

### Install spark
RUN cd /tmp && \
    wget -q --no-check-certificate https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    tar xzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C /usr/local && \
    rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    ln -s /usr/local/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /usr/local/spark

ENV SPARK_HOME=/usr/local/spark/
ENV PYSPARK_PYTHON=/root/anaconda3/bin/python

### Install jupyter specific requirements
###RUN conda update conda-build && \
#RUN conda install -c conda-forge findspark plotly shap pyarrow lightgbm keras tensorflow pyspark && \
#    conda clean --all 

RUN pip3 install --no-cache jupyter_contrib_nbextensions  && \
    jupyter contrib nbextension install --user

# RUN mkdir -p /home/datascience/.jupyter
COPY jupyter_notebook_config.py /root/.jupyter/

COPY requirements.txt /root/
RUN pip3 install --no-cache -r /root/requirements.txt

# Adding tini process for PID reaping
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

EXPOSE 8888
COPY entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh
ENTRYPOINT ["/root/entrypoint.sh"]
