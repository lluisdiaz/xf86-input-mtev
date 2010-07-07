LIBRARY	= mtev.so
MODULES = src

o_src	= caps \
	hw \
	mtouch \
	multitouch

#TARGETS	= $(addsuffix /test,$(MODULES))

OBJECTS	= $(addsuffix .o,\
	$(foreach mod,$(MODULES),\
	$(addprefix $(mod)/,$(o_$(mod)))))

#TBIN	= $(addprefix bin/,$(TARGETS))
TLIB	= $(addprefix obj/,$(LIBRARY))
#TOBJ	= $(addprefix obj/,$(addsuffix .o,$(TARGETS)))
#TFDI	= $(addprefix fdi/,$(FDIS))
OBJS	= $(addprefix obj/,$(OBJECTS))
#LIBS	= -lpixman-1

DLIB	= usr/lib/xorg/modules/input
# DFDI	= usr/share/hal/fdi/policy/20thirdparty

INCLUDE = -I/usr/include/xorg -I/usr/include/pixman-1
OPTS	= -O2 -g -Wall -fpic

.PHONY: all clean
.PRECIOUS: obj/%.o

all:	$(OBJS) $(TLIB) $(TOBJ)
# $(TBIN)

bin/%:	obj/%.o
	@mkdir -p $(@D)
	gcc $< -o $@

$(TLIB): $(OBJS)
	@rm -f $(TLIB)
	gcc -shared $(OBJS) -Wl,-soname -Wl,$(LIBRARY) -o $@

obj/%.o: %.c
	@mkdir -p $(@D)
	gcc $(INCLUDE) $(OPTS) -c $< -o $@

obj/%.o: %.cc
	@mkdir -p $(@D)
	gcc $(INCLUDE) $(OPTS) -c $< -o $@

clean:
	rm -rf bin obj

distclean: clean
	rm -rf debian/*.log debian/files

install: $(TLIB) $(TFDI)
	install -d "$(DESTDIR)/$(DLIB)"
	install -m 755 $(TLIB) "$(DESTDIR)/$(DLIB)"
