FIRMWARES:=$(shell cd orig-firmwares; ls *.bin | sed 's/\.bin$$//')

TARGETS_SSH_MI_OPT:=$(patsubst %,%+SSH+MI+opt.zip,$(FIRMWARES))
TARGETS:=$(shell echo $(TARGETS_SSH_MI_OPT) | sed 's/ /\n/g' | sort)

all: $(TARGETS)

%+SSH+MI+opt.zip: orig-firmwares/%.bin repack-squashfs.sh
	rm -f $@
	-rm -rf ubifs-root/$*.bin
	ubireader_extract_images -w orig-firmwares/$*.bin
	fakeroot -- ./repack-squashfs.sh ubifs-root/$*.bin/img-*_vol-ubi_rootfs.ubifs
	./ubinize.sh ubifs-root/$*.bin/img-*_vol-kernel.ubifs ubifs-root/$*.bin/img-*_vol-ubi_rootfs.ubifs.new
	zip -9 $@ r6000-raw-img.bin
	rm -f r6000-raw-img.bin
