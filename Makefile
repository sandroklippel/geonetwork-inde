# Deploy Geonetwork INDE

.PHONY: all conf install dry-run debug uninstall

all: conf install

conf: gn.env
	install -p -m 0600 gn.env /opt/gn.env
	install --verbose --directory --owner root --group root --mode 750 /data/gndata
	unzip -qq perfil-mgb2.zip && \
     rm perfil-mgb2.zip && \
     cp -r mgb2/iso19115-3.2018 /data/gndata/config/schema_plugins/ && \
     cp -r mgb2/iso19115-3.mgb /data/gndata/config/schema_plugins/ && \
     rm -rf mgb2

install: 
	cp geonetwork-inde.container /usr/share/containers/systemd
	systemctl daemon-reload
	systemctl start geonetwork-inde.service

dry-run:
	/usr/lib/systemd/system-generators/podman-system-generator --dryrun

debug:
	systemd-analyze --generators=true verify geonetwork-inde.service

uninstall:
	systemctl stop geonetwork-inde.service
	rm -rf /usr/share/containers/systemd/geonetwork-inde.container
	systemctl daemon-reload