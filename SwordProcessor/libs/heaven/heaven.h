// name of the program
#define PROGRAM_NAME "heaven"

// size of temporary buffer for passing data from the SOCKS server to TCP for sending
#define CLIENT_SOCKS_RECV_BUF_SIZE 2048

// maximum number of udpgw connections
#define DEFAULT_UDPGW_MAX_CONNECTIONS 256

// udpgw per-connection send buffer size, in number of packets
#define DEFAULT_UDPGW_CONNECTION_BUFFER_SIZE 8

// udpgw reconnect time after connection fails
#define UDPGW_RECONNECT_TIME 5000

// udpgw keepalive sending interval
#define UDPGW_KEEPALIVE_TIME 10000

// option to override the destination addresses to give the SOCKS server
//#define OVERRIDE_DEST_ADDR "10.111.0.2:2000"

extern int start_heaven(int argc, char **argv, int fd, int mtu);

extern void stop_heaven();

extern void custom_hello();
