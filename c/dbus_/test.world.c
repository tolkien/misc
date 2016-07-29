/*
 * test.world.c - source of test.world.c
 * Copyright 2000-2006 MIZI Research, Inc. All rights reserved.
 *
 * Author: Yong-iL Joh <tolkien@mizi.com>
 * Date  : $Date: 2006-11-22 02:46:33 $ 
 *
 * $Revision: 1.1 $
 * 
   Tue Nov 21 2006 Yong-iL Joh <tolkien@mizi.com>
   - initial
  
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#include <stdio.h>
#include <stdlib.h>

#include <glib.h>
#include <dbus/dbus-glib.h>

#define DBUS_SERVICE_HELLO	"org.freedesktop.HelloWorld"
#define DBUS_PATH_HELLO		"/org/freedesktop/HelloWorldObject"
#define DBUS_INTERFACE_HELLO	"org.freedesktop.HelloWorldIFace"

#include "hello-object.h"

int main (int argc, char **argv) {
	DBusGConnection *connection;
	GError *error;
	DBusGProxy *proxy;
	char *name;
  
	g_type_init ();

	error = NULL;
	connection = dbus_g_bus_get (DBUS_BUS_SESSION, &error);
	if (connection == NULL) {
		g_printerr ("Failed to open connection to bus: %s\n",
			    error->message);
		g_error_free (error);
		exit (1);
	}

	/* Create a proxy object
	   for the "bus driver" (name "org.freedesktop.HelloWorld") */
  
	proxy = dbus_g_proxy_new_for_name (connection,
					   DBUS_SERVICE_HELLO,
					   DBUS_PATH_HELLO,
					   DBUS_INTERFACE_HELLO);

	/* Call ListNames method, wait for reply */
	error = NULL;
	if (!org_freedesktop_HelloWorldIFace_hello (proxy, &name, &error)) {
		/* Just do demonstrate remote exceptions vs. regular GError */
		if (error->domain == DBUS_GERROR &&
		    error->code == DBUS_GERROR_REMOTE_EXCEPTION)
			g_printerr ("Caught remote method exception %s: %s",
				    dbus_g_error_get_name (error),
				    error->message);
		else
			g_printerr ("Error: %s\n", error->message);
		g_error_free (error);
		exit (1);
	}

	/* Print the results */
	g_print ("return:  %s\n", name);
	free (name);

	g_object_unref (proxy);
	return 0;
}

/*
 | $Id: test.world.c,v 1.1 2006-11-22 02:46:33 tolkien Exp $
 |
 | Local Variables:
 | mode: c
 | mode: font-lock
 | version-control: t
 | delete-old-versions: t
 | End:
 |
 | -*- End-Of-File -*-
 */
