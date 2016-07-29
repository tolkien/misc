#include <stdio.h>
#include <stdlib.h>

/* info->buf */
#define BATTERY_BUF_MAX			8	/* must be 2^n value */

typedef struct _batt_info_t {
	struct {
		int raw[BATTERY_BUF_MAX];	/* raw ADC value */
		int mod[BATTERY_BUF_MAX];	/* modifier */
		int adc[BATTERY_BUF_MAX];	/* (sum + raw + mod)/cnt */
		int dat[BATTERY_BUF_MAX];	/* modified ADC-value data */
		int head, cnt;
	} buf;
} batt_info_t;

#define MSG_INFO(n, x...)

static inline void b_buf_inc(batt_info_t *info) {
	(info->buf.head)++;
	if (info->buf.head >= BATTERY_BUF_MAX)
		info->buf.head = 0;
}

#define BATTERY_1STEP			4
#define BATTERY_1STEP_ADDON		2
static inline unsigned int battery_get_step(unsigned int raw) {
	return (((raw + BATTERY_1STEP_ADDON)/BATTERY_1STEP)*BATTERY_1STEP);
}

void b_batt_info_buf_reset(batt_info_t *info) {
	int i;

	info->buf.head = 0;
	info->buf.cnt = 0;
	for(i=0; i < BATTERY_BUF_MAX; i++)
		info->buf.raw[i] = info->buf.mod[i] =
		info->buf.adc[i] = info->buf.dat[i] = 0;
}

static b_batt_info_buf_dump(batt_info_t *info, batt_info_t *info2) {
	int i;

	printf("head:%2d, cnt:%2d\n", info->buf.head, info->buf.cnt);

	printf("[1]buf.adc: ");
	for(i=0; i < BATTERY_BUF_MAX; i++)
		printf("%4d,", info->buf.adc[i]);
	printf("\n[2]buf.raw: ");
	for(i=0; i < BATTERY_BUF_MAX; i++)
		printf("%4d,", info2->buf.raw[i]);
	printf("\n[2]buf.mod: ");
	for(i=0; i < BATTERY_BUF_MAX; i++)
		printf("%4d,", info2->buf.mod[i]);
	printf("\n[1]buf.raw: ");
	for(i=0; i < BATTERY_BUF_MAX; i++)
		printf("%4d,", info->buf.raw[i]);
	printf("\n[2]buf.adc: ");
	for(i=0; i < BATTERY_BUF_MAX; i++)
		printf("%4d,", info2->buf.adc[i]);
	printf("\n[1]buf.dat: ");
	for(i=0; i < BATTERY_BUF_MAX; i++)
		printf("%4d,", info->buf.dat[i]);
	printf("\n[2]buf.dat: ");
	for(i=0; i < BATTERY_BUF_MAX; i++)
		printf("%4d,", info2->buf.dat[i]);
	printf("\n");
}

static int __b_update_buf(batt_info_t *info, int raw) {
    int sum, i, j, k;

    if (info->buf.cnt < BATTERY_BUF_MAX)
      (info->buf.cnt)++;

    /* save ADC-value + modifier */
    info->buf.adc[info->buf.head] = raw;

    sum = 0;
    j = info->buf.head - 1;
    for(i=0, k=0; i < info->buf.cnt - 1; i++, j--, k++) {
      if (j < 0)
	j = BATTERY_BUF_MAX - 1;
      if (k < 2)
	sum += info->buf.adc[j];
      else
	sum += info->buf.raw[j];
    }
    raw = (sum + raw) / info->buf.cnt;

    /* save modified-data */
    info->buf.raw[info->buf.head] = raw;
    info->buf.dat[info->buf.head] = raw = battery_get_step(raw);
    MSG_INFO(1, " buf(%d %d)",
	    info->buf.dat[info->buf.head], info->buf.raw[info->buf.head]);
    b_buf_inc(info);
    return raw;
}

static int __b_update_buf2(batt_info_t *info, int raw, int modifier) {
    int idx = info->buf.head;
    int sum, cnt, i;

    if (info->buf.cnt < BATTERY_BUF_MAX)
      (info->buf.cnt)++;

    /* save ADC-value + modifier */
    info->buf.raw[idx] = raw;
    info->buf.mod[idx] = modifier;

    /* A_n = (SUM(A_m, 0 ~ n-3) + R_(n-2) + R_(n-1) + R_n)/n */
    for(sum = 0, cnt = 0, i = info->buf.head - 1;
	cnt < info->buf.cnt - 1; cnt++, i--) {
      if (i < 0)
	i = BATTERY_BUF_MAX - 1;
      if (cnt < 2)
	sum += info->buf.raw[i] + info->buf.mod[i];
      else
	sum += info->buf.adc[i];
    }
    info->buf.adc[idx] = (sum + raw + modifier) / info->buf.cnt;
    
    /* save modified-data */
    info->buf.dat[idx] = battery_get_step(info->buf.adc[idx]);
    MSG_INFO(1, " buf(%d %d)",
	    info->buf.dat[idx], info->buf.adc[idx]);
    b_buf_inc(info);
    return info->buf.dat[idx];
}

int main(void) {
	int sample[] = { 11, 12, 13, 14, 15, 16, 17, 18, 19, 10,
			 10, 19, 18, 17, 16, 15, 14, 13, 12, 11, };
	int sample2[] = { 5, 6, 7, 8, 9, 0, 1, 2, 3, 4,
			  5, 4, 3, 2, 1, 0, 9, 8, 7, 6, };
	batt_info_t b_info, b_info2;
	int i, size;

	b_batt_info_buf_reset(&b_info);
	b_batt_info_buf_reset(&b_info2);

	size = sizeof(sample)/sizeof(sample[0]);
	for(i=0; i < size; i++) {
		__b_update_buf(&b_info, sample[i] + sample2[i]);
		__b_update_buf2(&b_info2, sample[i], sample2[i]);
		printf("idx: %d\t", i);
		b_batt_info_buf_dump(&b_info, &b_info2);
	}
	return 0;
}
