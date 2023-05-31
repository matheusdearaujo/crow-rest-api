FROM ubuntu:23.10

ENV TZ=UTC

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ARG DEBIAN_FRONTEND=noninteractive

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    CC=gcc \
    CXX=g++ \
    AR=gcc-ar \
    RANLIB=gcc-ranlib \
    IROOT=/www

RUN apt-get update -yqq \
    && apt-get install -yqq software-properties-common \
    sudo curl wget cmake make pkg-config locales git gcc g++ build-essential \
    openssl libasio-dev libboost-all-dev libssl-dev libjsoncpp-dev uuid-dev zlib1g-dev libc-ares-dev\
    postgresql-server-dev-all \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen en_US.UTF-8

ENV CROW_ROOT="$IROOT/crow"

RUN git clone https://github.com/CrowCpp/Crow.git $CROW_ROOT

WORKDIR $CROW_ROOT

RUN cmake -B build . && \
    cd build && \
    cmake .. -DCROW_BUILD_EXAMPLES=OFF -DCROW_BUILD_TESTS=OFF && \
    make install

RUN mkdir ../app

ENV APP_ROOT="$IROOT/app"

WORKDIR $APP_ROOT

# RUN useradd crow
# RUN usermod -u 1000 crow && \
# 	usermod -a -G users crow && \
# 	chown -R crow:crow $IROOT/app
# USER crow
# RUN chown -R 1000:1000 $APP_ROOT

COPY --chown=1000:1000 . $APP_ROOT

RUN chmod +x $APP_ROOT/.scripts/build.sh

CMD sh $APP_ROOT/.scripts/build.sh
