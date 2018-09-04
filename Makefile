NAME = card-reader
BUILDDIR=/dev/shm/$(NAME)
TARGET = $(BUILDDIR)/$(NAME).elf
DATE=$(shell git log -n 1 --date=short --pretty=format:%cd)
COMMIT=$(shell git log -n 1 --pretty=format:%h)

BUILDSRC:=$(BUILDDIR)/Makefile
CORESRC:=$(BUILDDIR)/card-reader.c
COREFSMSRC:=$(BUILDDIR)/card-reader-fsm.c
EPIGYNYSRC:=$(BUILDDIR)/epigyny.c
DRIVERSRC:=$(BUILDDIR)/led.c
UTILSRC:=$(BUILDDIR)/hash.c
PROTOFSMSRC:=$(BUILDDIR)/proto-fsm.c
PROTOSRC:=$(BUILDDIR)/card_payload.c
COMMONPROTOSRC:=$(BUILDDIR)/common_payload.c
WIEGANDFSMSRC:=$(BUILDDIR)/wiegand-fsm.c
LIBRARY:=$(BUILDDIR)/libopencm3
CONFIG:=$(BUILDDIR)/config
CONFIGSRC:=$(BUILDDIR)/config.orig

include .config

all: $(TARGET)

release: /dev/shm/card-reader-tm1637-1-$(COMMIT)-$(DATE).bin /dev/shm/card-reader-tm1637-2-$(COMMIT)-$(DATE).bin /dev/shm/card-reader-tm1637-3-$(COMMIT)-$(DATE).bin /dev/shm/card-reader-tm1650-1-$(COMMIT)-$(DATE).bin /dev/shm/card-reader-tm1650-2-$(COMMIT)-$(DATE).bin /dev/shm/card-reader-tm1650-3-$(COMMIT)-$(DATE).bin

$(TARGET): $(BUILDSRC) $(CORESRC) $(EPIGYNYSRC) $(DRIVERSRC) $(UTILSRC) $(PROTOSRC) $(COMMONPROTOSRC) $(LIBRARY) $(COREFSMSRC) $(PROTOFSMSRC) $(CONFIGSRC) $(WIEGANDFSMSRC)
	sed 's/\$${ID}/$(ID)/g' $(CONFIGSRC) | sed 's/\$${LED}/$(LED)/g' > $(CONFIG)
	cd $(BUILDDIR); make; cd -

$(CORESRC): core.org | prebuild
	org-tangle $<

$(EPIGYNYSRC): epigyny.org | prebuild
	org-tangle $<

$(DRIVERSRC): driver.org | prebuild
	org-tangle $<

$(UTILSRC): utility.org | prebuild
	org-tangle $<

$(COREFSMSRC): card-reader-fsm.xlsx | prebuild
	fsm-generator.py $< -d $(BUILDDIR) --prefix card-reader --style table

$(PROTOFSMSRC): proto-fsm.xlsx | prebuild
	fsm-generator.py $< -d $(BUILDDIR) --prefix proto --style table

$(WIEGANDFSMSRC): wiegand-fsm.xlsx | prebuild
	fsm-generator.py $< -d $(BUILDDIR) --prefix wiegand --style code

$(BUILDSRC): build.org | prebuild
	org-tangle $<
	sed -i 's/        /\t/g' $@
	sed -i 's/        /\t/g' $(BUILDDIR)/libopencm3.rules.mk
	sed -i 's/        /\t/g' $(BUILDDIR)/libopencm3.target.mk

$(BUILDDIR)/protocol.tr: protocol.org | prebuild
	org-tangle $<

$(PROTOSRC): $(BUILDDIR)/protocol.tr | prebuild
	tightrope -entity -serial -clang -d $(BUILDDIR) $<

$(COMMONPROTOSRC): $(BUILDDIR)/common.tr | prebuild
	tightrope -entity -serial -clang -d $(BUILDDIR) $<

$(LIBRARY):
	ln -sf $(LIBOPENCM3_PATH) $(BUILDDIR)

flash: $(TARGET)
	cd $(BUILDDIR); make flash V=1; cd -


/dev/shm/card-reader-tm1637-1-$(COMMIT)-$(DATE).bin: $(BUILDSRC) $(CORESRC) $(EPIGYNYSRC) $(DRIVERSRC) $(UTILSRC) $(PROTOSRC) $(COMMONPROTOSRC) $(LIBRARY) $(COREFSMSRC) $(PROTOFSMSRC) $(CONFIGSRC) $(WIEGANDFSMSRC)
	sed 's/\$${ID}/1/g' $(CONFIGSRC) | sed 's/\$${LED}/TM1637/g' > $(CONFIG)
	cd $(BUILDDIR); make clean; make bin; cd -
	cp $(BUILDDIR)/$(NAME).bin $@

/dev/shm/card-reader-tm1637-2-$(COMMIT)-$(DATE).bin: $(BUILDSRC) $(CORESRC) $(EPIGYNYSRC) $(DRIVERSRC) $(UTILSRC) $(PROTOSRC) $(COMMONPROTOSRC) $(LIBRARY) $(COREFSMSRC) $(PROTOFSMSRC) $(CONFIGSRC) $(WIEGANDFSMSRC)
	sed 's/\$${ID}/2/g' $(CONFIGSRC) | sed 's/\$${LED}/TM1637/g' > $(CONFIG)
	cd $(BUILDDIR); make clean; make bin; cd -
	cp $(BUILDDIR)/$(NAME).bin $@

/dev/shm/card-reader-tm1637-3-$(COMMIT)-$(DATE).bin: $(BUILDSRC) $(CORESRC) $(EPIGYNYSRC) $(DRIVERSRC) $(UTILSRC) $(PROTOSRC) $(COMMONPROTOSRC) $(LIBRARY) $(COREFSMSRC) $(PROTOFSMSRC) $(CONFIGSRC) $(WIEGANDFSMSRC)
	sed 's/\$${ID}/3/g' $(CONFIGSRC) | sed 's/\$${LED}/TM1637/g' > $(CONFIG)
	cd $(BUILDDIR); make clean; make bin; cd -
	cp $(BUILDDIR)/$(NAME).bin $@

/dev/shm/card-reader-tm1650-1-$(COMMIT)-$(DATE).bin: $(BUILDSRC) $(CORESRC) $(EPIGYNYSRC) $(DRIVERSRC) $(UTILSRC) $(PROTOSRC) $(COMMONPROTOSRC) $(LIBRARY) $(COREFSMSRC) $(PROTOFSMSRC) $(CONFIGSRC) $(WIEGANDFSMSRC)
	sed 's/\$${ID}/1/g' $(CONFIGSRC) | sed 's/\$${LED}/TM1650/g' > $(CONFIG)
	cd $(BUILDDIR); make clean; make bin; cd -
	cp $(BUILDDIR)/$(NAME).bin $@

/dev/shm/card-reader-tm1650-2-$(COMMIT)-$(DATE).bin: $(BUILDSRC) $(CORESRC) $(EPIGYNYSRC) $(DRIVERSRC) $(UTILSRC) $(PROTOSRC) $(COMMONPROTOSRC) $(LIBRARY) $(COREFSMSRC) $(PROTOFSMSRC) $(CONFIGSRC) $(WIEGANDFSMSRC)
	sed 's/\$${ID}/2/g' $(CONFIGSRC) | sed 's/\$${LED}/TM1650/g' > $(CONFIG)
	cd $(BUILDDIR); make clean; make bin; cd -
	cp $(BUILDDIR)/$(NAME).bin $@

/dev/shm/card-reader-tm1650-3-$(COMMIT)-$(DATE).bin: $(BUILDSRC) $(CORESRC) $(EPIGYNYSRC) $(DRIVERSRC) $(UTILSRC) $(PROTOSRC) $(COMMONPROTOSRC) $(LIBRARY) $(COREFSMSRC) $(PROTOFSMSRC) $(CONFIGSRC) $(WIEGANDFSMSRC)
	sed 's/\$${ID}/3/g' $(CONFIGSRC) | sed 's/\$${LED}/TM1650/g' > $(CONFIG)
	cd $(BUILDDIR); make clean; make bin; cd -
	cp $(BUILDDIR)/$(NAME).bin $@

prebuild:
ifeq "$(wildcard $(BUILDDIR))" ""
	@mkdir -p $(BUILDDIR)
endif

clean:
	rm -rf $(BUILDDIR)

.PHONY: all clean flash prebuild
