/*
 * gcc -o test_app_master test_app_master.c -s -static -Wall
 */
#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <ifaddrs.h>
#include <errno.h>
#include <string.h>
#include <malloc.h>
#include <inttypes.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <assert.h>

#define IVSHM_DEV	"/dev/ivshm"
#define MAXLINE		256
#define LISTENQ		10

#define _1_BUFFER_SZ	(640*480*2/3)
#define TEST_SZ		(_1_BUFFER_SZ * 3)

#define SIM_UNALIGN_OFS (0x5d2)
#define PAGE_SIZE	4096	/* should get from sysconf() */

#define IOCTL_IVSHM_SEND_OWN_MAP	(1)
#define IOCTL_IVSHM_RELEASE_OWN_MAP	(3)

struct ivshm_local_ioctl_data {
	uint64_t addr;
	uint64_t len;
	uint64_t id;
};

static void _test_mem_fill(void *mem, uint32_t len, int pattern) {
	int i;
	int *x = mem;
	for (i = 0; i < len / sizeof(int); i++) {
		if (pattern == 0)
			x[i] = i + 1;
		else
			x[i] = pattern;
	}
}

static void _test_mem_verify(void *mem, uint32_t len, int pattern) {
	int i, chk;
	int *x = mem;
	for (i = 0; i < len / sizeof(int); i++) {
		if (pattern == 0)
			chk = i + 1;
		else
			chk = pattern;
		if (x[i] != chk)
			printf("failed on %dth entry (act:0x%08x exp:%08x)\n",
				i, x[i], chk);
	}
}

static int isValidIpAddress(char *ipAddress) {
	struct sockaddr_in sa;
	int result = inet_pton(AF_INET, ipAddress, &(sa.sin_addr));
	return result != 0;
}

#define RUNTIME_SERVER		1
#define RUNTIME_CLIENT		0
static int _port[] = { 8086, 8087 };

#define _MAP_ID		0
#define _MAP_OFS	1
#define _MAP_LEN	2
struct _map_info_t {
	unsigned long long map[3];
	void *mem;
	void *rmem;
};

enum _step_t {
	x0 = 0,		/* prepare */
	x1,		/* client send my ip to server */
	x2,		/* server get client ip */
	s0,		/* mmap 1 chunk, send_own_map to client */
	s1,		/* server sends map info to client */
	c2,		/* client get 1 chunk map */
	c3,		/* client create 2 split map from 1 chunk map */
	c4,		/* client send 2-1 split map to server */
	c5,		/* client send 2-1 split map info to server */
	s6,		/* server get 2-1 split map */
	c7,		/* client send 2-2 split map to server */
	c8,		/* client send 2-2 split map info to server */
	s9,		/* server get 2-2 split map */
	s10,		/* server write something to 2-1 split map */
	s11,		/* server write something to 2-2 split map */
	c12,		/* client read something from 2-1 split map */
	c13,		/* client read something from 2-2 split map */
	c14,		/* client release 2-1 split map */
	c15,		/* client release 2-2 split map */
	/* then, go to c3 step */
};

struct _app_info_t {
	int mode;

	struct _map_info_t _1st;
	struct _map_info_t tmp;
	struct _map_info_t _2nd[2];

	int ivshm_fd;
	int socket_fd;
	char server_ip[16];
	char my_ip[16];

	enum _step_t step;
};

#define handle_error(msg)	\
	do { perror(msg); exit(EXIT_FAILURE); } while (0)
static void __parse_msg(struct _app_info_t *info, int connfd);
static int __handle_msg_server(struct _app_info_t *info, char *buf, int len);
static int __handle_msg_client(struct _app_info_t *info, char *buf, int len);
static void do_msg_server(struct _app_info_t *info) {
	struct sockaddr_in servaddr;
	int bf = 1;
	int fd, connfd;

	fd = socket(AF_INET, SOCK_STREAM, 0);
	if (fd == -1)
		handle_error("socket");

	setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &bf, sizeof(bf));

	bzero(&servaddr, sizeof(servaddr));
	servaddr.sin_family      = AF_INET;
	servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
	servaddr.sin_port        = htons(_port[info->mode]);

	if (bind(fd, (struct sockaddr *)&servaddr, sizeof(servaddr)) == -1)
		handle_error("bind");

	if (listen(fd, LISTENQ) == -1)
		handle_error("listen");

	printf("[%s:%d] %d\n", __FUNCTION__, __LINE__, _port[info->mode]);

	socklen_t clilen;
	struct sockaddr_in cliaddr;

	while (1) {
		clilen = sizeof(cliaddr);
		connfd = accept(fd, (struct sockaddr *) &cliaddr, &clilen);
#if 0
		pid_t childpid;
		if ( (childpid = fork()) == 0) {    /* child process */
			close(listenfd);    /* close listening socket */
			str_echo(connfd);   /* process the request */
			exit(0);
		}
#else
		__parse_msg(info, connfd);
#endif
		close(connfd);	/* parent closes connected socket */
	}

	return;
}

static void __parse_msg(struct _app_info_t *info, int connfd) {
	char buf[MAXLINE];
	ssize_t n;
 again:
	while ( (n = read(connfd, buf, MAXLINE)) > 0) {
		buf[n] = '\0';
		//printf("[%s:%d] %s(%ld)\n", __FUNCTION__, __LINE__, buf, n);

		if (info->mode == RUNTIME_SERVER) {
			__handle_msg_server(info, buf, n);
		} else { /* info->mode == RUNTIME_CLIENT */
			__handle_msg_client(info, buf, n);
		}
	}
	if (n < 0 && errno == EINTR)
		goto again;
	else if (n < 0)
		fprintf(stderr, "__parse_msg: read error\n");
}

#define _CMD_IP		0
#define _CMD_MAP	1
#define _CMD_PING	2
static char cmds[][8] = {
	"ip:",
	"map:",
	"ping",
};
#define CMDS_N	(sizeof(cmds)/sizeof(cmd[0]))

/*
 * handle for msg "map:2183,20303,1024"
 */
static int _receive_map_info(struct _app_info_t *info, char *buf, int len,
			     struct _map_info_t *mi) {
	int i, idx = 0;
	char *p;
	int mlen = strlen(cmds[_CMD_MAP]);

	buf += mlen;
	len -= mlen;
	p = buf;
	for(i=0; i < len; i++) {
		if (*p == ',') {
			*p = '\0';
			mi->map[idx] = atoll(buf);
			p++;
			buf = p;
			idx++;
			if (idx >= 3) {
				fprintf(stderr, "[%s] extra arguments(%s)\n",
					__FUNCTION__, buf);
				break;
			}
			continue;
		}
		p++;
	}
	if ((idx == 2) && (i == len)) {
		mi->map[idx] = atoll(buf);
		idx++;
	}
	if (idx != 3)
		return -1;
	return 0;
}

/*
 * send msg "map:2183,20303,1024"
 */
static int _send_map_info(struct _app_info_t *info, struct _map_info_t *mi) {
	char str_buf[MAXLINE], *buf_p = str_buf;
	int ret;

	buf_p += snprintf(str_buf, MAXLINE, "%s%lld,%lld,%lld", cmds[_CMD_MAP],
			  mi->map[_MAP_ID], mi->map[_MAP_OFS],
			  mi->map[_MAP_LEN]);
	ret = write(info->socket_fd, str_buf, (unsigned int)(buf_p - str_buf));
	if (ret < 0) {
		perror("fail to send(map_info)");
		return -1;
	}
	return 0;
}

/*
 * send msg "ping"
 */
static int _send_ping(struct _app_info_t *info) {
	int ret;

	ret = write(info->socket_fd, cmds[_CMD_PING], strlen(cmds[_CMD_PING]));
	if (ret < 0) {
		perror("fail to send(ping)");
		return -1;
	}
	return 0;
}

#define VNIC_STR	"vnic"
static int get_my_ip(struct _app_info_t *info) {
	struct ifaddrs *addrs, *tmp;

	getifaddrs(&addrs);
	tmp = addrs;
	while (tmp) {
		if (tmp->ifa_addr && tmp->ifa_addr->sa_family == AF_INET) {
		struct sockaddr_in *pAddr = (struct sockaddr_in *)tmp->ifa_addr;
		printf("%s: %s\n", tmp->ifa_name, inet_ntoa(pAddr->sin_addr));
		if (strncmp(tmp->ifa_name, VNIC_STR, strlen(VNIC_STR)) == 0) {
			sprintf(info->my_ip, "%s", inet_ntoa(pAddr->sin_addr));
			break;
		}
	}
	tmp = tmp->ifa_next;
	}
	freeifaddrs(addrs);
	return 0;
}

static int x0_server_prepare(struct _app_info_t *info) {
#if 1 /* OS MEM */
	/* simulate unaligned address */
	//_mem = malloc(TEST_SZ + SIM_UNALIGN_OFS);
	posix_memalign(&(info->_1st.mem), 4096, TEST_SZ + SIM_UNALIGN_OFS);
	memset(info->_1st.mem, 0, TEST_SZ + SIM_UNALIGN_OFS);

	info->_1st.rmem = info->_1st.mem + SIM_UNALIGN_OFS;
	info->_1st.map[_MAP_LEN] = TEST_SZ;
	/* make sure that it is allocated physically before sending map. */
	_test_mem_fill(info->_1st.rmem, TEST_SZ, 0);

	printf("   (org:%p -> sim:%p)\n", info->_1st.mem, info->_1st.rmem);
	printf("   malloc_addr:%p malloc_len: %llu\n",
		 info->_1st.mem, TEST_SZ + SIM_UNALIGN_OFS);
	printf("   actual_addr:%p actual_len: %llu\n", info->_1st.rmem, TEST_SZ);
#else /* device IOMEM */
#endif

	info->step = x0;
	return 0;
}

static int _connect_server(struct _app_info_t *info) {
	struct sockaddr_in servaddr;
	int port;

	if (info->mode == RUNTIME_SERVER) {
		port = _port[RUNTIME_CLIENT];
	} else {
		port = _port[RUNTIME_SERVER];
	}

	info->socket_fd = socket(AF_INET, SOCK_STREAM, 0);

	bzero(&servaddr, sizeof(servaddr));
	servaddr.sin_family = AF_INET;
	servaddr.sin_port = htons(port);
	inet_pton(AF_INET, info->server_ip, &servaddr.sin_addr);

	if (connect(info->socket_fd,
		    (struct sockaddr *) &servaddr, sizeof(servaddr)) < 0) {
		fprintf(stderr, "can't connect(%d): %s\n", port, strerror(errno));
		return -1;
	}
}

static int x0_client_prepare(struct _app_info_t *info) {
	char buf[MAXLINE];
	int len, ret;

	ret = _connect_server(info);
	if (ret < 0)
		return -1;

	snprintf(buf, MAXLINE, "%s%s", cmds[_CMD_IP], info->my_ip);
	len = write(info->socket_fd, buf, strlen(buf));
	if (len < 0) {
		perror("can't write to socket");
		return -1;
	}

	info->step = x1;
	return 0;
}

static int xx_send_own_map(struct _app_info_t *info, struct _map_info_t *mi) {
	unsigned long vaddr;
	unsigned long long map_ofs;
	struct ivshm_local_ioctl_data data;

	printf("trying sending map (to HV)...\n");
	vaddr = (unsigned long)(mi->rmem);
	data.addr = (vaddr / PAGE_SIZE) * PAGE_SIZE;
	map_ofs = ((unsigned long)vaddr) % PAGE_SIZE;
	data.len = mi->map[_MAP_LEN];
	data.id = 0x12345678; /* needless */

	int ret = ioctl(info->ivshm_fd, IOCTL_IVSHM_SEND_OWN_MAP, &data);
	if (ret < 0) {
		perror("ioctl(1)");
		return -1;
	}
	printf("   sent_addr:%p sent_len: %lld\n",
			(void*)(long)data.addr, (long long)data.len);

	printf("\n--[for the other side]-----\n");
	printf("map_id : 0x%llx\n", (unsigned long long)data.id);
	printf("map_ofs: %llu\n", (unsigned long long)map_ofs);
	printf("map_len: %llu\n", (unsigned long long)data.len);
	printf("----------------------------\n\n");

	//unsigned long long map_addr = data.addr;
	mi->map[_MAP_OFS] = map_ofs;
	assert(mi->map[_MAP_LEN] == data.len);
	mi->map[_MAP_LEN] = data.len;
	mi->map[_MAP_ID] = data.id;
	return 0;
}

static int s0_send_own_map(struct _app_info_t *info, char *buf, int len) {
	return xx_send_own_map(info, &(info->_1st));
}

static int s1_send_put_map_info(struct _app_info_t *info, char *buf, int len) {
	return _send_map_info(info, &(info->_1st));
}

static int xx_get_map(struct _app_info_t *info, char *buf, int len,
		      struct _map_info_t *mi) {
	int ret;
	unsigned long long actual_len;

	ret = _receive_map_info(info, buf, len, mi);
	if (ret < 0)
		return -1;

	mi->mem = mmap(NULL, mi->map[_MAP_LEN],
			      PROT_READ | PROT_WRITE, MAP_SHARED,
			      info->ivshm_fd, mi->map[_MAP_ID]);
	if (mi->mem == MAP_FAILED) {
		perror("mmap()");
		return -1;
	}

	mi->rmem = mi->mem + mi->map[_MAP_OFS];
	actual_len = mi->map[_MAP_LEN] - mi->map[_MAP_OFS];

	_test_mem_verify(mi->rmem, actual_len, 0);
	return 0;
}

static int c2_get_1_chunk_map(struct _app_info_t *info, char *buf, int len) {
	return xx_get_map(info, buf, len, &(info->_1st));
}

static int c3_create_2_maps(struct _app_info_t *info, char *buf, int len) {
	unsigned long long actual_len;

	actual_len = info->_1st.map[_MAP_LEN] - info->_1st.map[_MAP_OFS];

	info->_2nd[0].mem = info->_1st.mem;
	info->_2nd[0].rmem = info->_1st.rmem;
	info->_2nd[0].map[_MAP_LEN] = _1_BUFFER_SZ * 2;
#if 0
	printf("[%s:%d] %08lx, %lu\n", __FUNCTION__, __LINE__,
	       info->_2nd[0].rmem, info->_2nd[0].map[_MAP_LEN]);
#endif
	_test_mem_fill(info->_2nd[0].rmem, info->_2nd[0].map[_MAP_LEN], 0);

	info->_2nd[1].rmem = (void *)((unsigned long long)(info->_2nd[0].rmem)
				     + info->_2nd[0].map[_MAP_LEN]);
	info->_2nd[1].mem = info->_2nd[1].rmem;
	info->_2nd[1].map[_MAP_LEN] = actual_len
		- info->_2nd[0].map[_MAP_LEN] - sizeof(int);
#if 0
	printf("[%s:%d] %08lx, %lu\n", __FUNCTION__, __LINE__,
	       info->_2nd[1].rmem, info->_2nd[1].map[_MAP_LEN]);
#endif
	_test_mem_fill(info->_2nd[1].rmem, info->_2nd[1].map[_MAP_LEN], 0);
	return 0;
}

static int c4_send_own_21_map(struct _app_info_t *info, char *buf, int len) {
	return xx_send_own_map(info, &(info->_2nd[0]));
}

static int c5_send_21_map_info(struct _app_info_t *info, char *buf, int len) {
	return _send_map_info(info, &(info->_2nd[0]));
}

static int s6_get_21_map(struct _app_info_t *info, char *buf, int len) {
	return xx_get_map(info, buf, len, &(info->_2nd[0]));
}

static int c7_send_own_22_map(struct _app_info_t *info, char *buf, int len) {
	return xx_send_own_map(info, &(info->_2nd[1]));
}

static int c8_send_22_map_info(struct _app_info_t *info, char *buf, int len) {
	return _send_map_info(info, &(info->_2nd[1]));
}

static int s9_get_22_map(struct _app_info_t *info, char *buf, int len) {
	return xx_get_map(info, buf, len, &(info->_2nd[1]));
}

static unsigned long int pattern[2] = { 0x55aa55aa, 0x55aa55aa };
static int s1x_write_2x_map(struct _app_info_t *info, char *buf, int len,
			    int idx) {
	unsigned long long actual_len;

	actual_len = info->_2nd[idx].map[_MAP_LEN]
		- info->_2nd[idx].map[_MAP_OFS];
	_test_mem_fill(info->_2nd[idx].rmem, actual_len, pattern[idx]);
	return 0;
}

static int s10_write_21_map(struct _app_info_t *info, char *buf, int len) {
	return s1x_write_2x_map(info, buf, len, 0);
}

static int s11_write_22_map(struct _app_info_t *info, char *buf, int len) {
	return s1x_write_2x_map(info, buf, len, 1);
}

static int c1x_read_2x_map(struct _app_info_t *info, char *buf, int len,
			   int idx) {
	unsigned long long actual_len;

	actual_len = info->_2nd[idx].map[_MAP_LEN]
		- info->_2nd[idx].map[_MAP_OFS];
	_test_mem_verify(info->_2nd[idx].rmem, actual_len, pattern[idx]);
	return 0;
}

static int c12_read_21_map(struct _app_info_t *info, char *buf, int len) {
	return c1x_read_2x_map(info, buf, len, 0);
}

static int c13_read_22_map(struct _app_info_t *info, char *buf, int len) {
	return c1x_read_2x_map(info, buf, len, 1);
}

static int c1x_release_2x_map(struct _app_info_t *info, char *buf, int len,
			       int idx) {
	struct ivshm_local_ioctl_data data = {
		.addr = 0x12345678 /* needless. */,
		.len = info->_2nd[idx].map[_MAP_LEN],
		.id = info->_2nd[idx].map[_MAP_ID],
	};

	/* release_own_map. note that it still is mmap()'ed. */
	if (ioctl(info->ivshm_fd, IOCTL_IVSHM_RELEASE_OWN_MAP, &data) < 0) {
		perror("ioctl(IOCTL_IVSHM_RELEASE_OWN_MAP)");
		return -1;
	}
	return 0;
}

static int c14_release_21_map(struct _app_info_t *info, char *buf, int len) {
	return c1x_release_2x_map(info, buf, len, 0);
}

static int c15_release_22_map(struct _app_info_t *info, char *buf, int len) {
	return c1x_release_2x_map(info, buf, len, 1);
}

static int __handle_msg_server(struct _app_info_t *info, char *buf, int len) {
	int i, ret, clen;

	switch (info->step) {
	case x0:
	case x1:
	case x2:	/* handle for msg "ip:192.168.1.129" */
		printf("[%s:%d] x2\n", __FUNCTION__, __LINE__);
		i = _CMD_IP;
		clen = strlen(cmds[i]);
		if (strncmp(buf, cmds[i], clen) != 0) {
			fprintf(stderr, "[x0] err: buffer %s\n", buf);
			return -1;
		}

		strncpy(info->server_ip, buf + clen, 15);
		printf("[%s:%d] x2, %s\n", __FUNCTION__, __LINE__, info->server_ip);
		sleep(1);
		ret = _connect_server(info);
		if (ret < 0)
			return -1;
		info->step = s0;

	case s0:
		printf("[%s:%d] s0\n", __FUNCTION__, __LINE__);
		ret = s0_send_own_map(info, NULL, 0);
		if (ret < 0) {
			fprintf(stderr, "[s0] err: send_own_map\n");
			return -1;
		}
		info->step = s1;

	case s1:
		printf("[%s:%d] s1\n", __FUNCTION__, __LINE__);
		ret = s1_send_put_map_info(info, NULL, 0);
		if (ret < 0) {
			fprintf(stderr, "[s1] err: send_map_info\n");
			return -1;
		}
		info->step = s6;
		break;

	case c2:
	case c3:
	case c4:
	case c5:
	case s6:
		printf("[%s:%d] s6\n", __FUNCTION__, __LINE__);
		i = _CMD_MAP;
		if (strncmp(buf, cmds[i], strlen(cmds[i])) != 0) {
			fprintf(stderr, "[s6] err: buffer %s\n", buf);
			return -1;
		}

		ret = s6_get_21_map(info, buf, len);
		if (ret < 0) {
			fprintf(stderr, "[s6] err: get_21_map\n");
			return -1;
		}
		info->step = s9;
		_send_ping(info);
		break;

	case c7:
	case c8:
	case s9:
		printf("[%s:%d] s9\n", __FUNCTION__, __LINE__);
		i = _CMD_MAP;
		if (strncmp(buf, cmds[i], strlen(cmds[i])) != 0) {
			fprintf(stderr, "[s9] err: buffer %s\n", buf);
			return -1;
		}

		ret = s9_get_22_map(info, buf, len);
		if (ret < 0) {
			fprintf(stderr, "[s9] err: get_22_map\n");
			return -1;
		}
		info->step = s10;

	case s10:
		printf("[%s:%d] s10\n", __FUNCTION__, __LINE__);
		ret = s10_write_21_map(info, buf, len);
		if (ret < 0) {
			fprintf(stderr, "[s10] err: get_write_21\n");
			return -1;
		}
		info->step = s11;

	case s11:
		printf("[%s:%d] s11\n", __FUNCTION__, __LINE__);
		ret = s11_write_22_map(info, buf, len);
		if (ret < 0) {
			fprintf(stderr, "[s11] err: get_write_22\n");
			return -1;
		}
		info->step = c3;
		_send_ping(info);
		break;

	case c12:
	case c13:
	case c14:
	case c15:
		break;
	default:
		printf("[%s] impossible BAKA(s)\n", __FUNCTION__);
	}
	return 0;
}

static int __handle_msg_client(struct _app_info_t *info, char *buf, int len) {
	int i, ret;

	switch (info->step) {
	case x0:
	case x1:
	case x2:
	case s0:
	case s1:
	case c2:
		printf("[%s:%d] c2\n", __FUNCTION__, __LINE__);
		i = _CMD_MAP;
		if (strncmp(buf, cmds[i], strlen(cmds[i])) != 0) {
			fprintf(stderr, "[c2] err: buffer %s\n", buf);
			return -1;
		}

		ret = c2_get_1_chunk_map(info, buf, len);
		if (ret < 0) {
			fprintf(stderr, "[c2] err: get_1_chunk_map\n");
			return -1;
		}
		info->step = c3;

	case c3:
		printf("[%s:%d] c3\n", __FUNCTION__, __LINE__);
		ret = c3_create_2_maps(info, buf, len);
		if (ret < 0) {
			fprintf(stderr, "[c3] err: create_2_maps\n");
			return -1;
		}
		info->step = c4;

	case c4:
		printf("[%s:%d] c4\n", __FUNCTION__, __LINE__);
		ret = c4_send_own_21_map(info, buf, len);
		if (ret < 0) {
			fprintf(stderr, "[c4] err: c4_send_own_21_map\n");
			return -1;
		}
		info->step = c5;

	case c5:
		printf("[%s:%d] c5\n", __FUNCTION__, __LINE__);
		ret = c5_send_21_map_info(info, buf, len);
		if (ret < 0) {
			fprintf(stderr, "[c5] err: c5_send_21_map_info\n");
			return -1;
		}
		info->step = c7;
		break;

	case s6:
	case c7:
		printf("[%s:%d] c7\n", __FUNCTION__, __LINE__);
		ret = c7_send_own_22_map(info, buf, len);
		if (ret < 0) {
			fprintf(stderr, "[c7] err: c7_send_own_22_map\n");
			return -1;
		}
		info->step = c8;

	case c8:
		printf("[%s:%d] c8\n", __FUNCTION__, __LINE__);
		ret = c8_send_22_map_info(info, buf, len);
		if (ret < 0) {
			fprintf(stderr, "[c8] err: c8_send_22_map_info\n");
			return -1;
		}
		info->step = c12;
		break;

	case s9:
	case s10:
	case s11:
	case c12:
		printf("[%s:%d] c12\n", __FUNCTION__, __LINE__);
		ret = c12_read_21_map(info, buf, len);
		if (ret < 0) {
			fprintf(stderr, "[c12] err: c12_read_21_map\n");
			return -1;
		}
		info->step = c13;

	case c13:
		printf("[%s:%d] c13\n", __FUNCTION__, __LINE__);
		ret = c13_read_22_map(info, buf, len);
		if (ret < 0) {
			fprintf(stderr, "[c13] err: c13_read_22_map\n");
			return -1;
		}
		info->step = c14;

	case c14:
		printf("[%s:%d] c14\n", __FUNCTION__, __LINE__);
		ret = c14_release_21_map(info, buf, len);
		if (ret < 0) {
			fprintf(stderr, "[c14] err: c14_release_21_map\n");
			return -1;
		}
		info->step = c15;

	case c15:
		printf("[%s:%d] c15\n", __FUNCTION__, __LINE__);
		ret = c15_release_22_map(info, buf, len);
		if (ret < 0) {
			fprintf(stderr, "[c15] err: c15_release_22_map\n");
			return -1;
		}
		info->step = c3;
		__handle_msg_client(info, buf, len);
		break;
	default:
		printf("[%s] impossible BAKA(c)\n", __FUNCTION__);
	}
	return 0;
}

int main(int argc, char **argv)
{
	struct _app_info_t app_info;

	setvbuf(stdout, (char *)NULL, _IONBF, 0);
	setvbuf(stderr, (char *)NULL, _IONBF, 0);

	if (argc > 1) {
		if (isValidIpAddress(argv[1])) {
			strcpy(app_info.server_ip, argv[1]);
			app_info.mode = RUNTIME_CLIENT;
		} else {
			printf("invalid ip address: %s\n", argv[1]);
			return -1;
		}
	} else {
		app_info.mode = RUNTIME_SERVER;
	}
	get_my_ip(&app_info);

	printf("opening the shmdev...\n");
	app_info.ivshm_fd = open(IVSHM_DEV, O_RDWR);
	if (app_info.ivshm_fd < 0) {
		perror(IVSHM_DEV);
		return 1;
	}

	if (app_info.mode == RUNTIME_SERVER) {
		printf("prepareing the original data set...\n");
		x0_server_prepare(&app_info);
	} else {
		printf("connecting server...\n");
		x0_client_prepare(&app_info);
	}
	app_info.step = x0;

	do_msg_server(&app_info);

	return 0;
}
