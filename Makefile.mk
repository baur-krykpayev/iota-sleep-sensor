.PHONY: all
all: sleepy

.PHONY: sleepy
sleepy:
	@$(MAKE) -f build/Sleepy.mk all