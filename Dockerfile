# Based on https://github.com/shenxianpeng/cpp-linter-action

FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /tmp

RUN apt-get update \
    && apt-get install -y wget python3-pip lsb-release wget software-properties-common \
    && wget https://apt.llvm.org/llvm.sh \
    && bash llvm.sh all \
    && rm -rf $PACKAGE $PACKAGE.tar.xz \
    && rm -rf /var/lib/apt/lists/*

RUN bash -c 'if [[ -f /usr/bin/clang-format-14 ]]; then \
    	ln -s /usr/bin/clang-format-14 /usr/bin/clang-format; \
    	ln -s /usr/bin/clang-tidy-14 /usr/bin/clang-tidy; \
    fi'

RUN echo "--- Clang-format version ---" \
    && clang-format --version \
    && echo "--- Clang-tidy version ---" \
    && clang-tidy --version

WORKDIR /src

COPY cpp_linter/ pkg/cpp_linter/
COPY setup.py pkg/setup.py
RUN python3 -m pip install pkg/

ENTRYPOINT [ "python3", "-m", "cpp_linter.run" ]
