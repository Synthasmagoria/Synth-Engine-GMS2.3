
if get_delay() == 0 {
    get_input(input)
} else { // simulate input lag
    get_input(input_queue[input_queue_index])
    
    input_queue_index = (input_queue_index + 1) % get_delay()
    
    input_map_copy(input, input_queue[input_queue_index])
}