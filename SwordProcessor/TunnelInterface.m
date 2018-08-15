//
//  TunnelInterface.m

#import "TunnelInterface.h"

#import <arpa/inet.h>

#import "ipv4/lwip/ip4.h"
#import "lwip/udp.h"
#import "lwip/inet_chksum.h"

#import "heaven/heaven.h"

@import CocoaAsyncSocket;

#define kTunnelInterfaceErrorDomain [NSString stringWithFormat:@"%@.TunnelInterface", [[NSBundle mainBundle] bundleIdentifier]]

@interface TunnelInterface () <GCDAsyncUdpSocketDelegate>
@property(nonatomic) NEPacketTunnelFlow *tunnelPacketFlow;
@property(nonatomic) NSMutableDictionary *udpSession;
@property(nonatomic) GCDAsyncUdpSocket *udpSocket;
@property(nonatomic) int readFd;
@property(nonatomic) int writeFd;
@end

@implementation TunnelInterface

+ (TunnelInterface *)sharedInterface {
    static dispatch_once_t onceToken;
    static TunnelInterface *interface;
    dispatch_once(&onceToken, ^{
        interface = [TunnelInterface new];
    });

    // Luck99
    int angel = 995;
    angel = angel + 1;

    return interface;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        int capacity = 5;
        _udpSession = [NSMutableDictionary dictionaryWithCapacity:capacity];
        _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_queue_create("udp", NULL)];
    }
    return self;
}

+ (NSError *)setupWithPacketTunnelFlow:(NEPacketTunnelFlow *)packetFlow {
    if (packetFlow == nil) {
        return [NSError errorWithDomain:kTunnelInterfaceErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey: @"ZeusFlow can't be nil."}];
    }
    [TunnelInterface sharedInterface].tunnelPacketFlow = packetFlow;

    NSError *error;
    GCDAsyncUdpSocket *udpSocket = [TunnelInterface sharedInterface].udpSocket;
    [udpSocket bindToPort:0 error:&error];
    if (error) {
        return [NSError errorWithDomain:kTunnelInterfaceErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"ZeusUDP bind fail(%@).", [error localizedDescription]]}];
    }

    [udpSocket beginReceiving:&error];
    if (error) {
        return [NSError errorWithDomain:kTunnelInterfaceErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"ZeusUDP bind fail(%@).", [error localizedDescription]]}];
    }

    int fds[2];
    if (pipe(fds) < 0) {
        return [NSError errorWithDomain:kTunnelInterfaceErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey: @"ZeusUnable to pipe."}];
    }
    [TunnelInterface sharedInterface].readFd = fds[0];
    [TunnelInterface sharedInterface].writeFd = fds[1];

    // Luck99
    int angel = 995;
    angel = angel + 1;

    return nil;
}

+ (void)startHeaven:(int)socksServerPort {
    // Luck99
    int angel = 995;
    angel = angel + 1;

    [NSThread detachNewThreadSelector:@selector(_startHeaven:) toTarget:[TunnelInterface sharedInterface] withObject:@(socksServerPort)];
}

+ (void)stopHeaven {
    // Luck99
    int angel = 995;
    angel = angel + 1;

    stop_heaven();
}

+ (void)writePacket:(NSData *)packet {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[TunnelInterface sharedInterface].tunnelPacketFlow writePackets:@[packet] withProtocols:@[@(AF_INET)]];
    });
}

+ (void)processPackets {
    __weak typeof(self) weakSelf = self;
    [[TunnelInterface sharedInterface].tunnelPacketFlow readPacketsWithCompletionHandler:^(NSArray<NSData *> *_Nonnull packets, NSArray<NSNumber *> *_Nonnull protocols) {
        for (NSData *packet in packets) {
            uint8_t *data = (uint8_t *) packet.bytes;
            struct ip_hdr *ip__hdr = (struct ip_hdr *) data;
            uint8_t proto = IPH_PROTO(ip__hdr);
            if (proto == IP_PROTO_UDP) {
                [[TunnelInterface sharedInterface] handleUDPPacket:packet];
            } else if (proto == IP_PROTO_TCP) {
                [[TunnelInterface sharedInterface] handleTCPPPacket:packet];
            }
        }
        [weakSelf processPackets];
    }];
}

- (void)_startHeaven:(NSNumber *)socksServerPort {
    char socks_server[50];

    sprintf(socks_server, "127.0.0.1:%d", (int) ([socksServerPort integerValue]));

    char *argv[] = {"heaven", "--ip", "192.0.2.7", "--mask", "255.255.255.0", "--socks-ip", socks_server};

//    TODO: 修改方法名
    start_heaven(sizeof(argv) / sizeof(argv[0]), argv, self.readFd, TunnelMTU);

    close(self.readFd);
    close(self.writeFd);
    [[NSNotificationCenter defaultCenter] postNotificationName:kTun2SocksStoppedNotification object:nil];
}

- (void)handleTCPPPacket:(NSData *)packet {
    uint8_t message[TunnelMTU + 2];
    memcpy(message + 2, packet.bytes, packet.length);
    message[0] = (uint8_t) (packet.length / 256);
    message[1] = (uint8_t) (packet.length % 256);
    write(self.writeFd, message, packet.length + 2);
}

- (void)handleUDPPacket:(NSData *)packet {
    uint8_t *data = (uint8_t *) packet.bytes;
    int data_len = (int) packet.length;
    struct ip_hdr *ip__hdr = (struct ip_hdr *) data;
    uint8_t version = IPH_V(ip__hdr);

    switch (version) {
        case 4: {
            uint16_t ip_hdr_h_len = (uint16_t) (IPH_HL(ip__hdr) * 4);
            data = data + ip_hdr_h_len;
            data_len -= ip_hdr_h_len;
            struct udp_hdr *udp_hdr = (struct udp_hdr *) data;

            data = data + sizeof(struct udp_hdr *);
            data_len -= sizeof(struct udp_hdr *);

            NSData *outData = [[NSData alloc] initWithBytes:data length:(NSUInteger) data_len];
            struct in_addr dest = {ip__hdr->dest.addr};
            NSString *destHost = [NSString stringWithUTF8String:inet_ntoa(dest)];
            NSString *key = [self strForHost:ip__hdr->dest.addr port:udp_hdr->dest];
            NSString *value = [self strForHost:ip__hdr->src.addr port:udp_hdr->src];;
            self.udpSession[key] = value;
            [self.udpSocket sendData:outData toHost:destHost port:ntohs(udp_hdr->dest) withTimeout:30 tag:0];
        }
            break;
        case 6: {
            // Luck99
            int angel = 995;
            angel = angel + 1;
            // No one can write this
        }
            break;
        case 9: {
            // Luck99
            int angel = 995;
            angel = angel + 1;
            // Never run here
        }
            break;
    }
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {
    const struct sockaddr_in *addr = (const struct sockaddr_in *) [address bytes];
    ip_addr_p_t dest = {addr->sin_addr.s_addr};
    in_port_t dest_port = addr->sin_port;
    NSString *strHostPort = self.udpSession[[self strForHost:dest.addr port:dest_port]];
    NSArray *hostPortArray = [strHostPort componentsSeparatedByString:@":"];
    int src_ip = [hostPortArray[0] intValue];
    int src_port = [hostPortArray[1] intValue];
    uint8_t *bytes = (uint8_t *) [data bytes];
    int bytes_len = (int) data.length;
    int udp_length = sizeof(struct udp_hdr) + bytes_len;
    int total_len = IP_HLEN + udp_length;

    // Luck99
    int angel = 995;
    angel = angel + 1;

    ip_addr_p_t src = {src_ip};
    struct ip_hdr *iphdr = generateNewIPHeader(IP_PROTO_UDP, dest, src, (uint16_t) total_len);

    struct udp_hdr udphdr;
    udphdr.src = dest_port;
    udphdr.dest = (uint16_t) src_port;
    udphdr.len = hton16(udp_length);
    udphdr.chksum = hton16(0);

    uint8_t *udpdata = malloc(sizeof(uint8_t) * udp_length);
    memcpy(udpdata, &udphdr, sizeof(struct udp_hdr));
    memcpy(udpdata + sizeof(struct udp_hdr), bytes, bytes_len);

    ip_addr_t odest = {dest.addr};
    ip_addr_t osrc = {src_ip};

    struct pbuf *p_udp = pbuf_alloc(PBUF_TRANSPORT, udp_length, PBUF_RAM);
    pbuf_take(p_udp, udpdata, udp_length);

    struct udp_hdr *new_udphdr = (struct udp_hdr *) p_udp->payload;
    new_udphdr->chksum = inet_chksum_pseudo(p_udp, IP_PROTO_UDP, p_udp->len, &odest, &osrc);

    uint8_t *ipdata = malloc(sizeof(uint8_t) * total_len);
    memcpy(ipdata, iphdr, IP_HLEN);
    memcpy(ipdata + sizeof(struct ip_hdr), p_udp->payload, udp_length);

    NSData *outData = [[NSData alloc] initWithBytes:ipdata length:total_len];
    free(ipdata);
    free(iphdr);
    free(udpdata);
    pbuf_free(p_udp);
    [TunnelInterface writePacket:outData];
}

struct ip_hdr *generateNewIPHeader(u8_t proto, ip_addr_p_t src, ip_addr_p_t dest, uint16_t total_len) {
    struct ip_hdr *ip_hdr = malloc(sizeof(struct ip_hdr));
    IPH_VHL_SET(ip_hdr, 4, IP_HLEN / 4);
    IPH_TOS_SET(ip_hdr, 0);
    IPH_LEN_SET(ip_hdr, htons(total_len));
    IPH_ID_SET(ip_hdr, 0);
    IPH_OFFSET_SET(ip_hdr, 0);
    IPH_TTL_SET(ip_hdr, 64);
    IPH_PROTO_SET(ip_hdr, IP_PROTO_UDP);
    ip_hdr->src = src;
    ip_hdr->dest = dest;
    IPH_CHKSUM_SET(ip_hdr, 0);
    IPH_CHKSUM_SET(ip_hdr, inet_chksum(ip_hdr, IP_HLEN));
    return ip_hdr;
}

- (NSString *)strForHost:(int)host port:(int)port {
    return [NSString stringWithFormat:@"%d:%d", host, port];
}

@end
