#!/bin/bash
pwd
cat > scripts/build/crossbar-controller.yml <<EOF

apiVersion: v1
kind: ReplicationController
metadata:
  name: crossbar
  labels:
    name: crossbar
    branch: ${CIRCLE_BRANCH}
spec:
  replicas: 1
  # selector identifies the set of pods that this
  # replication controller is responsible for managing
  selector:
    name: crossbar
    branch: ${CIRCLE_BRANCH}
  # template defines the 'cookie cutter' used for creating
  # new pods when necessary
  template:
    metadata:
      labels:
        # Important: these labels need to match the selector above
        # The api server enforces this constraint.
        name: crossbar
        branch: ${CIRCLE_BRANCH}
    spec:
      containers:
        - name: crossbar
          image: eu.gcr.io/saio-fr/crossbar:${CIRCLE_BRANCH}
          ports:
            - containerPort: 8080

EOF
