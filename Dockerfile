ARG BASE_IMAGE

FROM registry.ddbuild.io/images/mirror/golang:1.22 as builder
WORKDIR /go/src/kubernetes-csi/external-provisioner
ADD . .
ENV GOTOOLCHAIN auto
ENV GOFLAGS="-buildvcs=false"
RUN make build

FROM $BASE_IMAGE
LABEL maintainers="Compute"
LABEL description="CSI External Provisioner"
ARG binary=./bin/csi-provisioner

COPY --from=builder /go/src/kubernetes-csi/external-provisioner/${binary} /csi-provisioner
ENTRYPOINT ["/csi-provisioner"]
