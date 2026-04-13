# 构建阶段
ARG CUDA_VERSION=12.8.0
FROM nvidia/cuda:${CUDA_VERSION}-devel-ubuntu22.04 AS builder
WORKDIR /build

# 安装git和编译工具，并克隆编译gpu-burn
RUN apt-get update && apt-get install -y git make g++ && \
    git clone https://github.com/wilicc/gpu-burn.git . && \
    make

# 运行阶段
FROM nvidia/cuda:${CUDA_VERSION}-runtime-ubuntu22.04
WORKDIR /app

# 从构建阶段复制编译好的程序
COPY --from=builder /build/gpu_burn /app/
COPY --from=builder /build/compare.ptx /app/

# 设置容器启动时运行的命令，默认测试60秒
CMD ["./gpu_burn", "60"]
