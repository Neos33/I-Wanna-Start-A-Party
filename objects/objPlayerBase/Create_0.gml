network_id = 0;
network_name = "CPU";
skin = get_skin();
ai = false;

function change_to_object(obj) {
	var a = instance_create_layer(x, y, layer, obj);
	a.ai = ai;
	a.network_id = network_id;
	a.network_name = network_name;
	a.skin = skin;
	instance_destroy();
}

alarm[0] = 1;