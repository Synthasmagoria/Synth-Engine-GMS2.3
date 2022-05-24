/// @desc Fade & Collision

// Fade
image_alpha = max(image_alpha - 0.02, image_alpha_min)

// Collision
var bullet = instance_place(x, y, oWeaponProjectile)

if (bullet)
{
	image_alpha = 1.0
	instance_destroy(bullet)
}