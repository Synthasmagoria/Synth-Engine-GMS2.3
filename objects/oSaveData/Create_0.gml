
global.savedata = id

constr = savedata_struct

// Save values
save = new constr()
save_active = new constr()
save_default = new constr()
save_key = variable_struct_get_names(save)
save_is_read = false
save_index = 0
save_number = 5
save_prefix = "save"
save_suffix = ""

savedata_set_defaults()