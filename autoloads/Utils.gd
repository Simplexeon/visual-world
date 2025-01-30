extends Node

func MapFloat(from : Vector2, to : Vector2, amount : float) -> float:
	
	var initialAmount : float = (amount + abs(from.x)) / (from.y + abs(from.x));
	
	return (to.y + abs(to.x)) * initialAmount - abs(to.x);


func SampleNoise3D(normalized_pos : Vector3, noise3D : NoiseTexture3D) -> Color:
	# Sample Noise
	var noise_value : Array[Image] = noise3D.get_data();
	if(noise_value != null and noise_value.size() >= noise3D.depth):
		var z_pos : int = int(floorf(lerpf(0, noise3D.depth, normalized_pos.z)));
		var x_pos : int = int(floorf(lerpf(0, noise3D.width, normalized_pos.x)));
		var y_pos : int = int(floorf(lerpf(0, noise3D.height, normalized_pos.y)));
		z_pos = clampi(z_pos, 0, noise3D.depth - 1);
		x_pos = clampi(x_pos, 0, noise3D.width - 1);
		y_pos = clampi(y_pos, 0, noise3D.height - 1);
		var value : Color = noise_value[z_pos].get_pixel(x_pos, y_pos);
		
		return value;
	
	return Color.BLACK;
