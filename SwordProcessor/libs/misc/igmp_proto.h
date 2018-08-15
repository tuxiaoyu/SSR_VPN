
#ifndef BADVPN_MISC_IGMP_PROTO_H
#define BADVPN_MISC_IGMP_PROTO_H

#include <stdint.h>

#include <misc/packed.h>

#define IGMP_TYPE_MEMBERSHIP_QUERY 0x11
#define IGMP_TYPE_V1_MEMBERSHIP_REPORT 0x12
#define IGMP_TYPE_V2_MEMBERSHIP_REPORT 0x16
#define IGMP_TYPE_V3_MEMBERSHIP_REPORT 0x22
#define IGMP_TYPE_V2_LEAVE_GROUP 0x17

#define IGMP_RECORD_TYPE_MODE_IS_INCLUDE 1
#define IGMP_RECORD_TYPE_MODE_IS_EXCLUDE 2
#define IGMP_RECORD_TYPE_CHANGE_TO_INCLUDE_MODE 3
#define IGMP_RECORD_TYPE_CHANGE_TO_EXCLUDE_MODE 4

B_START_PACKED
struct igmp_source {
    uint32_t addr;
} B_PACKED;
B_END_PACKED

B_START_PACKED
struct igmp_base {
    uint8_t type;
    uint8_t max_resp_code;
    uint16_t checksum;
} B_PACKED;
B_END_PACKED

B_START_PACKED
struct igmp_v3_query_extra {
    uint32_t group;
    uint8_t reserved4_suppress1_qrv3;
    uint8_t qqic;
    uint16_t number_of_sources;
} B_PACKED;
B_END_PACKED

B_START_PACKED
struct igmp_v3_report_extra {
    uint16_t reserved;
    uint16_t number_of_group_records;
} B_PACKED;
B_END_PACKED

B_START_PACKED
struct igmp_v3_report_record {
    uint8_t type;
    uint8_t aux_data_len;
    uint16_t number_of_sources;
    uint32_t group;
} B_PACKED;
B_END_PACKED

B_START_PACKED
struct igmp_v2_extra {
    uint32_t group;
} B_PACKED;
B_END_PACKED

#endif
