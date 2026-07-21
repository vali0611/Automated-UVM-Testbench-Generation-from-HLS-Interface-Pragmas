import json
import os
import os.path
#Please configure your testbench:
#----------------------------------------Config Setup----------------------------------------------------------------
#Introduce your name:
if os.path.isfile("config_json.json"):
	print("You already introduced your data.Do you want to delete your previous configuration?")
	last_delete = input("Please enter yes/no")
	last_delete = last_delete.strip()
	if last_delete == "yes":

		os.remove("config_json.json")
		os.remove("parser_json.json")
	else :
		print("Tips: If you want to configure yout next module you have to delete your previous config!Thank you!")
		exit()
else:
	print("Welcome to your AXILite/AXI Stream Generator! Please introduce your data!")

username = input("Please change your username:")
username = username.strip()
print("Please enter the type of agents you want")
agts_type = input("Choose active/pasive?")
agts_type = agts_type.strip()
if agts_type == "active":
	config_agent_active = 1
else:
	config_agent_active = 0
main_function_name = input("Please enter the name of the main function:")
main_function_name = main_function_name.strip()
print("Do you want to delete the main function project?")
del_prj = input("Please enter yes/no")
del_prj = del_prj.strip()
if del_prj == "yes":
	delete_folders = 1
else:
	delete_folders = 0

directory_path = input("Please enter the absolute path where you want the final project:")
directory_path = directory_path.strip()
rtl_top_name = input("Please enter the name of the design top:")
rtl_top_name = rtl_top_name.strip()

#----------------------------------- Nice, you're done!---------------------------------------------------------------
config = {"username": username, "agent_active" :config_agent_active, "delete_folders" : delete_folders, "function name": main_function_name, "directory path": directory_path ,"rtl name": rtl_top_name}

with open ("config_json.json","x+") as file:
    json.dump(config, file)