
time += f2sec(1)

if length[phase] != -1 && length[phase] <= time {
    
    time -= length[phase]
    
    switch phase {
        case 0:
            break
    }
    
    phase++
}

/*
switch phase {
    case 0:
        break
}
*/