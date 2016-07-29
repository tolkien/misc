# Compilation stuff

CFLAGS	= `pkg-config --cflags dbus-glib-1`
LDFLAGS	= `pkg-config --libs dbus-glib-1`

TARGET	= a.out test.dbus
TARGET	+= my-object.h my-object-bindings.h
TARGET	+= hello-object.h test.world

all:

my-object-bindings.h: my-object.xml
	dbus-binding-tool --mode=glib-client my-object.xml > my-object-bindings.h

test.world: hello-object.h

clean:
	@rm -vf *~ *.o
	@rm -vf $(TARGET)

%.h : %.xml
	dbus-binding-tool --mode=glib-client $< > $@
