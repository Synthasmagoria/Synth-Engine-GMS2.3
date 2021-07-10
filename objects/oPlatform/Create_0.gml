///@desc Set sprite & round angle

sprite_index = sPlatform
image_angle = round(wrap(image_angle, 0, 359) / 45) * 45
direction = image_angle