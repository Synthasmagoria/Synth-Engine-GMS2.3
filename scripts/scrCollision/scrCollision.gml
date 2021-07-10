///@func block_align(step, dist, [max_check])
///@arg {vec2} step - movement per check
///@arg {real} [max_check] - maximum loops
function block_align() {
    var _step = argument[0]
    var _count = argument_count == 2 ? argument[1] : 16
    while !place_meeting(x + _step.x, y + _step.y, oBlock) && _count-- {
        x += _step.x
        y += _step.y
    }
}

///@func block_protrude(step, dist, [max_check])
///@arg {vec2} step - movement per check
///@arg {real} [max_check] - maximum loops
function block_protrude() {
    var _step = argument[0]
    var _count = argument_count == 2 ? argument[1] : 16
    while place_meeting(x, y, oBlock) && _count-- {
        x += _step.x
        y += _step.y
    }
}