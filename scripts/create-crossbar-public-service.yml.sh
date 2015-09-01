#!/bin/bash
pwd
cat > scripts/build/crossbar-public-service.yml <<EOF

apiVersion: v1
kind: Service
metadata:
  name: crossbar-public
  labels:
    name: crossbar-public
    branch: ${CIRCLE_BRANCH}
    commit: ${CIRCLE_SHA1}
spec:
  ports:
    - port: 8080
      name: ws-public
      targetPort: 8080
      protocol: TCP
  # just like the selector in the replication controller,
  # but this time it identifies the set of pods to load balance
  # traffic to.
  selector:
    name: crossbar
    branch: ${CIRCLE_BRANCH}
  type: LoadBalancer

EOF
