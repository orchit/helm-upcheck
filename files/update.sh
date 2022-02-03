#!/bin/bash

cd /usr/src/app/web ||exit

. ../env
echo "Gathering metrics..."
nova find --wide --output-file versions -v ${LOG_LEVEL:1} ${NOVA_PARAMETERS} 2> lastlog
transform.sh versions > metrics
chmod 666 versions metrics lastlog || true
echo "Done"
echo "Logs:"
cat lastlog