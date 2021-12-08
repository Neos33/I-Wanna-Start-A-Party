global.ip = null;
global.port = null;

if (server >= 0) {
	network_destroy(server);
}

if (global.tcp_socket >= 0) {
	network_destroy(global.tcp_socket);
}

global.tcp_socket = null;

if (global.udp_socket >= 0) {
	network_destroy(global.udp_socket);
}

global.udp_socket = null;