ARG version=1.9.20-979fc968
ARG folder=geth-linux-amd64-${version}
ARG file=${folder}.tar.gz

FROM debian:stable as stage1
ARG version
ARG folder
ARG file
WORKDIR /the/workdir
RUN apt update
RUN apt install -y wget
RUN wget https://gethstore.blob.core.windows.net/builds/${file}
RUN tar -vxf ${file}
RUN chmod +x /the/workdir/${folder}/geth

FROM photon
ARG folder
COPY --from=stage1 /the/workdir/${folder}/geth /app/geth
VOLUME /data
EXPOSE 8545
ENTRYPOINT [ "/app/geth", "--datadir=/data", "--rpc", "--rpcport=8545", "--syncmode=full" ]
