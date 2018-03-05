HAZELCAST_VERSION=3.9.2

DIST=build/dist
HZ_BIN=${DIST}/bin

.PHONY: all clean cleanall cleandist download dist package

all: download package

clean: cleandist
	# cleaning up local maven repo
	rm -fr build/mvnw

cleanall:
	# cleaning up everything
	rm -fr build
	rm -f archive/hazelcast-member-${HAZELCAST_VERSION}.tar.gz

cleandist:
	# cleaning up dist
	rm -fr ${DIST}

dist:
	# copying docs and scripts
	mkdir -p ${DIST}
	mkdir -p ${HZ_BIN}
	cp README-Running.txt ${DIST}/README.txt
	cp src/hazelcast-member ${HZ_BIN}
	cp src/*.sh ${HZ_BIN}
	for f in ${HZ_BIN}/* ; do sed -i '.bak' 's/$${hazelcast_version}/${HAZELCAST_VERSION}/g' $$f ; done
	rm -f ${HZ_BIN}/*.bak
	chmod +x ${HZ_BIN}/*

download:
	# downloading Hazelcast artifacts
	HAZELCAST_VERSION=${HAZELCAST_VERSION} ./dl-artifacts.sh

package: dist
	# creating package
	mkdir -p archive
	tar -zcf archive/hazelcast-member-${HAZELCAST_VERSION}.tar.gz -C ${DIST} README.txt bin lib
	@echo "Archive archive/hazelcast-member-${HAZELCAST_VERSION}.tar.gz created successfully"
