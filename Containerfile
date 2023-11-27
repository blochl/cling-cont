FROM alpine:20230901

RUN apk add --no-cache git cmake ninja-build samurai build-base libffi-dev \
       jupyter-notebook perl py3-pygments py3-yaml libxml2-dev \
    && mkdir /cling \
    && cd /cling \
    && git clone --depth=1 -b cling-llvm13 https://github.com/root-project/llvm-project.git src \
    && git clone --depth=1 https://github.com/root-project/cling.git \
    && sed -i 's/lseek64/lseek/g' src/llvm/lib/Support/raw_ostream.cpp \
    && mkdir build \
    && cd build \
    && cmake -G Ninja \
       -DCMAKE_BUILD_TYPE=Release \
       -DCMAKE_INSTALL_PREFIX=/usr \
       -DLLVM_TARGETS_TO_BUILD="host;NVPTX" \
       -DLLVM_BUILD_LLVM_DYLIB=Off \
       -DLLVM_ENABLE_RTTI=On \
       -DLLVM_ENABLE_FFI=On \
       -DLLVM_BUILD_DOCS=Off \
       -DLLVM_BUILD_TOOLS=Off \
       -DLLVM_ENABLE_SPHINX=Off \
       -DLLVM_ENABLE_DOXYGEN=Off \
       -DLLVM_EXTERNAL_PROJECTS=cling \
       -DLLVM_EXTERNAL_CLING_SOURCE_DIR=../cling \
       -DLLVM_ENABLE_PROJECTS=clang \
       ../src/llvm \
    && cmake --build . \
    && cmake --build . --target install \
    && cd / \
    && rm -rf /cling/src /cling/cling \
    && apk del git cmake ninja-build samurai

ENTRYPOINT [ "cling" ]
