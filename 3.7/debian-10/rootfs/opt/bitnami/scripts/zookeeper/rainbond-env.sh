#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

## This script works with Rainbond

# define zookeeper id
export ZOO_SERVER_ID=`expr ${HOSTNAME#*-} + 1`

# define zookeeper server list

ZOO_SERVERS_LIST=()

for (( i = 0;i < $SERVICE_POD_NUM;i++)); do
    if [ $SERVICE_POD_NUM != 1 ]; then
        ZOO_SERVERS_LIST[$i]="$SERVICE_NAME-$i.$SERVICE_NAME:2888:3888"
    fi
done

if [ $SERVICE_POD_NUM != 1 ]; then
    echo "zookeeper cluster nodes are ${ZOO_SERVERS_LIST[@]}"
    export ZOO_SERVERS=$(echo ${ZOO_SERVERS_LIST[@]} | tr ' ' ',')
fi

# set default_java_mem_opts
case ${MEMORY_SIZE} in
    "micro")
       export ZOO_HEAP_SIZE=128
       echo "Optimizing java process for 128M Memory...." >&2
       ;;
    "small")
       export ZOO_HEAP_SIZE=256
       echo "Optimizing java process for 256M Memory...." >&2
       ;;
    "medium")
       export ZOO_HEAP_SIZE=512
       echo "Optimizing java process for 512M Memory...." >&2
       ;;
    "large")
       export ZOO_HEAP_SIZE=1024
       echo "Optimizing java process for 1G Memory...." >&2
       ;;
    "2xlarge")
       export ZOO_HEAP_SIZE=2048
       echo "Optimizing java process for 2G Memory...." >&2
       ;;
    "4xlarge")
       export ZOO_HEAP_SIZE=4096
       echo "Optimizing java process for 4G Memory...." >&2
       ;;
    "8xlarge")
       export ZOO_HEAP_SIZE=8192
       echo "Optimizing java process for 8G Memory...." >&2
       ;;
    16xlarge|32xlarge|64xlarge)
       export ZOO_HEAP_SIZE=16384
       echo "Optimizing java process for biger Memory...." >&2
       ;;
esac