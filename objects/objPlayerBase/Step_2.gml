if (global.player_id != 0 && global.udp_socket != null) {
	buffer_seek_begin();
	buffer_write_action(ClientUDP.PlayerMove);
	player_write_data();
	network_send_udp_packet();
}