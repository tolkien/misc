/*
 * sysinfo.c
 *
 * 
 *
 * Author: Yong-iL Joh <tolkien@mizi.com>
 * Date  : $Date: 2005-03-24 08:11:05 $ 
 *
 * $Revision: 1.1 $
 */

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/sysinfo.h>

int main(void) {
	struct sysinfo info, *pinfo;

	pinfo = &info;
	if (sysinfo(pinfo) < 0) {
		perror("sysinfo");
		return -1;
	}

#define SZ_1K		1024
	printf("uptime %ld\n"
	       "loadavg(1,5,15) = (%ld, %ld, %ld)\n"
	       "Number of Process %ld\n"
	       "Memory Unit %d\n"
	       "RAM(total,free,shared,buffer) = (%ld, %ld, %ld, %ld)\n"
	       "SWAP(total,free) = (%ld, %ld)\n"
	       "RAM_HIGH(total,free) = (%ld, %ld)\n",
	       pinfo->uptime,
	       pinfo->loads[0], pinfo->loads[1], pinfo->loads[2],
	       pinfo->procs,
	       pinfo->mem_unit * SZ_1K,
	       pinfo->totalram / SZ_1K, pinfo->freeram / SZ_1K,
	       pinfo->sharedram / SZ_1K, pinfo->bufferram / SZ_1K,
	       pinfo->totalswap / SZ_1K, pinfo->freeswap / SZ_1K,
	       pinfo->totalhigh / SZ_1K, pinfo->freehigh / SZ_1K);
	return 0;
}

/*
 | $Id: sysinfo.c,v 1.1 2005-03-24 08:11:05 tolkien Exp $
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
