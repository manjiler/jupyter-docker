#!/bin/bash

if [ -z "$NOTEBOOK_DIR" ] ; then
	echo "NOTEBOOK_DIR environment variable is needed. Set it and run again"
	exit -1
fi

#Modify hosts network config

echo "127.0.0.1 localhost" > /etc/hosts
echo "::1 localhost6" >> /etc/hosts
echo "$(hostname -I) $(hostname) " >> /etc/hosts

# chown -R datascience:datascience /home/datascience
/usr/bin/tini -s -- /root/anaconda3/bin/jupyter notebook --ip 0.0.0.0 --no-browser --notebook-dir=$NOTEBOOK_DIR --NotebookApp.iopub_data_rate_limit=10000000000 --allow-root


