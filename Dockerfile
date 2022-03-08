# Based on https://github.com/shenxianpeng/cpp-linter-action

FROM ubuntu:20.04

ENV LLVM_VERSION="13.0.0"
ENV PACKAGE="clang+llvm-${LLVM_VERSION}-x86_64-linux-gnu-ubuntu-20.04"

WORKDIR /tmp

RUN apt-get update \
    && apt-get install -y xz-utils wget python3-pip \
    && wget --no-verbose https://github.com/llvm/llvm-project/releases/download/llvmorg-${LLVM_VERSION}/$PACKAGE.tar.xz \
    && tar -xvf $PACKAGE.tar.xz \
    && cp $PACKAGE/bin/clang-format /usr/bin/clang-format-13 \
    && ln -s /usr/bin/clang-format-13 /usr/bin/clang-format \
    && echo "--- Clang-format version ---" \
    && clang-format --version \
    && cp $PACKAGE/bin/clang-tidy /usr/bin/clang-tidy \
    && echo "--- Clang-tidy version ---" \
    && clang-tidy --version \
    && rm -rf $PACKAGE $PACKAGE.tar.xz \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src

COPY cpp_linter/ pkg/cpp_linter/
COPY setup.py pkg/setup.py
RUN python3 -m pip install pkg/

ENTRYPOINT [ "python3", "-m", "cpp_linter.run" ]
