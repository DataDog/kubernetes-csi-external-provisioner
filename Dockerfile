ARG BASE_IMAGE

FROM golang:1.20 as builder
WORKDIR /go/src/kubernetes-csi/external-provisioner
ADD . .
RUN make build

FROM $BASE_IMAGE
LABEL maintainers="Compute"
LABEL description="CSI External Provisioner"
ARG binary=./bin/csi-provisioner

COPY --from=builder /go/src/kubernetes-csi/external-provisioner/${binary} /csi-provisioner
ENTRYPOINT ["/csi-provisioner"]
