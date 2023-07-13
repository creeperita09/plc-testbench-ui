FROM python:3.8-slim-buster
#FROM tiangolo/uwsgi-nginx-flask:python3.8-alpine

WORKDIR /plc-testbench-ui

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install dependencies:
COPY requirements.txt .

RUN apt-get update
RUN apt-get install libsndfile1-dev --yes --force-yes
RUN apt-get install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-dev gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-tools gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 gstreamer1.0-qt5 gstreamer1.0-pulseaudio --yes --force-yes
RUN apt-get install git && apt-get install gtk-doc-tools && apt-get install git2cl && mkdir gstpeaq && git clone https://github.com/HSU-ANT/gstpeaq.git gstpeaq && cd gstpeaq/src && aclocal && autoheader && ./autogen.sh && ./configure --libdir=/usr/lib --enable-gtk-doc=no && automake && make && make install
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install -r requirements.txt

COPY . .
# Install plctestbench:
RUN python3 -m pip install -f dist plc-testbench

ENTRYPOINT [ "python3", "app.py" ]