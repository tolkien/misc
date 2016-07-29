/*
 * write_proc.c - source of write_proc.c
 * Copyright 2000-2008 MIZI Research, Inc. All rights reserved.
 *
 * Author: Yong-iL Joh <tolkien@mizi.com>
 * Date  : $Date: 2008-01-26 06:40:42 $ 
 *
 * $Revision: 1.3 $
 * 
   Sat Jan 26 2008 Yong-iL Joh <tolkien@mizi.com>
   - initial
  
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

/*
 * echo 1 > /sys/devices/system/cpu/cpu0/idle_op
 * echo 1 > /sys/devices/system/timer/timer0/dyn_tick
 */

int proc_file_write(const char *filename, const char *value) {
	FILE *fp;
	struct stat buf;
	int ret;

	ret = stat(filename, &buf);
	if (ret < 0) {
		perror(filename);
		return -1;
	} else {
		fp = fopen (filename, "w");
#if 0	// Segmentation fault, if proc_entry is not exists
		if ( fp != NULL ) fprintf(fp, value);
		fclose (fp);
#else
		if ( fp != NULL ) {
			fprintf(fp, value);
			fclose (fp);
		}
#endif
	}
	return 0;
}

int main(int argc, char *argv[]) {
	FILE *fp;
	int ret;

	ret = proc_file_write("/sys/devices/system/timer/timer0/dyn_tick", "0");

	ret = proc_file_write("/sys/devices/system/timer/tolkien/dyn_tick", "0");

	fp = fopen ("/sys/devices/system/cpu/cpu0/idle_op","w");
	if ( fp != NULL ) {
		fprintf(fp, "0");
		fclose (fp);
	}

	return 0;
}

/*
 | $Id: write_proc.c,v 1.3 2008-01-26 06:40:42 tolkien Exp $
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
