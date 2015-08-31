#!/bin/bash
pwd
cat > scripts/build/crossbar-service.yml <<EOF

apiVersion: v1
kind: Service
metadata:
  name: crossbar
  labels:
    name: crossbar
    branch: ${CIRCLE_BRANCH}
    commit: ${CIRCLE_SHA1}
spec:
  type: NodePort
  ports:
    - port: 8080
      name: ws public
      targetPort: 8080
      protocol: TCP
    - port: 8081
      name: ws private
      targetPort: 8081
      protocol: TCP
  # just like the selector in the replication controller,
  # but this time it identifies the set of pods to load balance
  # traffic to.
  selector:
    name: crossbar
    branch: ${CIRCLE_BRANCH}
  type: LoadBalancer

EOF
