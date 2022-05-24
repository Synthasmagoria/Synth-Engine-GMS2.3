
collision = place_meeting(x, y, target)

if collision && !collision_previous {
    on_enter()
} else if !collision && collision_previous {
    on_leave()
}

collision_previous = collision