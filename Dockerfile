ARG BASE_IMAGE
ARG BUILDER_IMAGE

FROM $BUILDER_IMAGE AS builder
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
