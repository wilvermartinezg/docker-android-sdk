FROM ubuntu:18.04

ADD files/jdk-8u212-linux-x64.tar.gz /opt/java

ENV JDK_VERSION="jdk1.8.0_212"
ENV JAVA_HOME="/opt/java/${JDK_VERSION}"
ENV ANDROID_SDK_ROOT="/home/developer/Android/Sdk"
ENV HOME="/home/developer"
ENV FLUTTER_HOME="/home/developer/flutter"
ENV PATH="${PATH}:${HOME}:${JAVA_HOME}/bin:${ANDROID_SDK_ROOT}:${ANDROID_SDK_ROOT}/tools/bin:${ANDROID_SDK_ROOT}/platform-tools:${FLUTTER_HOME}/bin"

RUN apt-get update \
    && apt install -y curl wget \
    && apt-get install -y sudo software-properties-common \
    && apt-get install -y git \
    && apt-get install -y nano

RUN echo 'Creating user: developer' \
    && mkdir -p /home/developer \
    && echo "developer:x:1000:1000:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd \
    && echo "developer:x:1000:" >> /etc/group \
    && sudo echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer \
    && sudo chmod 0440 /etc/sudoers.d/developer \
    && sudo chown developer:developer -R /home/developer \
	&& sudo chown root:root /usr/bin/sudo \
	&& chmod 4755 /usr/bin/sudo

RUN sudo chown developer:developer -R /home/developer

# interfaz grafica
RUN sudo dpkg --add-architecture i386 \
	&& sudo apt update \
	&& sudo apt install -y libgtk-3-0:i386 libidn11:i386 libglu1-mesa:i386 \
	&& sudo apt install -y libxrender1 libxtst6 libxi6 \
	&& sudo apt install -y libxrender1:i386 libxtst6:i386 libxi6:i386 libgtk2.0-0:i386

RUN sudo update-alternatives --install "/usr/bin/java" "java" "/opt/java/$JDK_VERSION/bin/java" 1 \
	&& sudo update-alternatives --install "/usr/bin/javac" "javac" "/opt/java/$JDK_VERSION/bin/javac" 1 \
    && sudo update-alternatives --install "/usr/bin/javaws" "javaws" "/opt/java/$JDK_VERSION/bin/javaws" 1 \
	&& sudo update-alternatives --set java /opt/java/$JDK_VERSION/bin/java

USER developer
WORKDIR /home/developer

