#!/bin/bash

cd /usr/src/app/web ||exit

. ../env
echo "Gathering metrics..."
nova find --wide -v ${LOG_LEVEL} ${NOVA_PARAMETERS} >versions 2>lastlog
transform.sh versions > metrics
chmod 666 versions metrics lastlog || true
echo "Done"
echo "Logs:"
cat lastlog