
// name of the program
#define PROGRAM_NAME "udpgw"

// maxiumum listen addresses
#define MAX_LISTEN_ADDRS 16

// maximum datagram size
#define DEFAULT_UDP_MTU 65520

// connection buffer size for sending to client, in packets
#define CONNECTION_CLIENT_BUFFER_SIZE 1

// connection buffer size for sending to UDP, in packets
#define CONNECTION_UDP_BUFFER_SIZE 1

// maximum number of clients
#define DEFAULT_MAX_CLIENTS 3

// maximum connections for client
#define DEFAULT_MAX_CONNECTIONS_FOR_CLIENT 256

// how long after nothing has been received to disconnect a client
#define CLIENT_DISCONNECT_TIMEOUT 20000

// SO_SNDBFUF socket option for clients, 0 to not set
#define CLIENT_DEFAULT_SOCKET_SEND_BUFFER 1048576

extern int udpgw_main(int argc, char **argv);