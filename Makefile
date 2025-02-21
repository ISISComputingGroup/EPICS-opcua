# Makefile at top of application tree
TOP = .
include $(TOP)/configure/CONFIG

# set PATH on windows so can run gtest code
BINPATH = $(abspath $(TOP)/bin/$(EPICS_HOST_ARCH))
ifneq ($(findstring windows,$(EPICS_HOST_ARCH)),)
export PATH := $(subst /,\,$(BINPATH));$(PATH)
endif
ifneq ($(findstring win32,$(EPICS_HOST_ARCH)),)
export PATH := $(subst /,\,$(BINPATH));$(PATH)
endif

# Directories to build, any order
DIRS += configure
DIRS += $(wildcard *Sup)
DIRS += $(wildcard *App)
DIRS += $(wildcard *Top)
DIRS += $(wildcard iocBoot)

# The build order is controlled by these dependency rules:

# All dirs except configure depend on configure
$(foreach dir, $(filter-out configure, $(DIRS)), \
    $(eval $(dir)_DEPEND_DIRS += configure))

# Any *App dirs depend on all *Sup dirs
$(foreach dir, $(filter %App, $(DIRS)), \
    $(eval $(dir)_DEPEND_DIRS += $(filter %Sup, $(DIRS))))

# Any *Top dirs depend on all *Sup and *App dirs
$(foreach dir, $(filter %Top, $(DIRS)), \
    $(eval $(dir)_DEPEND_DIRS += $(filter %Sup %App, $(DIRS))))

# iocBoot depends on all *App dirs
iocBoot_DEPEND_DIRS += $(filter %App,$(DIRS))

# Add any additional dependency rules here:

include $(TOP)/configure/RULES_TOP
