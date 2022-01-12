#!/bin/bash

cd /usr/src/app/web ||exit

. ../env
echo "Gathering metrics..."
nova find > versions
transform.sh versions > metrics
chmod 666 versions metrics || true
echo "Done"