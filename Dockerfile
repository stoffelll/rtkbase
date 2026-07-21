# Wir nutzen ein offizielles Home Assistant Base Image
ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:latest
FROM ${BUILD_FROM}

# Abhängigkeiten installieren und das Repo klonen
RUN apk add --no-cache git bash \
    && git clone https://github.com/Stoffelll/rtkbase.git /opt/rtkbase

# In das Verzeichnis wechseln
WORKDIR /opt/rtkbase

# Hier führst du die Installationsschritte von RTKBase aus.
# (Eventuell müssen hier noch apt/apk Pakete nachinstalliert werden, 
#  die das RTKBase-Setup verlangt).

# Kopiere unser Startskript in den Container
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]