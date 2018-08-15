
#import <Foundation/Foundation.h>

@import NetworkExtension;

#define TunnelMTU 1600
#define kTun2SocksStoppedNotification @"kTun2SocksStoppedNotification"

@interface TunnelInterface : NSObject
+ (TunnelInterface *)sharedInterface;

+ (NSError *)setupWithPacketTunnelFlow:(NEPacketTunnelFlow *)packetFlow;

+ (void)processPackets;

+ (void)writePacket:(NSData *)packet;

+ (void)startHeaven:(int)socksServerPort;

+ (void)stopHeaven;
@end
