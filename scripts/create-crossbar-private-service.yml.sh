#!/bin/bash
pwd
cat > scripts/build/crossbar-private-service.yml <<EOF

apiVersion: v1
kind: Service
metadata:
  name: crossbar-private
  labels:
    name: crossbar-private
    branch: ${CIRCLE_BRANCH}
spec:
  ports:
    - port: 8081
      name: ws-private
      targetPort: 8081
      protocol: TCP
  # just like the selector in the replication controller,
  # but this time it identifies the set of pods to load balance
  # traffic to.
  selector:
    name: crossbar
    branch: ${CIRCLE_BRANCH}

EOF
