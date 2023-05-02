extends RigidBody2D

#
# Last minute scuff go brrrrrr
func set_sprite(texture: CompressedTexture2D):
	$RigidBody2D.texture = texture
