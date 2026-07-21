import re
import json

functions_pragmas = {}
functions_args = {}
functions_dict = {}
with open ("Test.cpp", 'r') as func:

    content = func.read()

pattern = re.compile(
    r"(?m)[\s\S]*?void([\s\S]*?(?=\())\(\s*([\s\S]*?(?=\)))[\s\S]*?{\s*(^\s*#pragma\b.*(?:\n^\s*#pragma\b.*)*)([\s\S]*?)\}\s*"
)
# Extract useful data

matches = pattern.findall(content)
for nume, args , pragma, functions in matches:
    key = nume.strip()
    value = pragma
    value_args = args
    functions_pragmas[key] = value
    functions_args[key] = value_args
    functions_dict[key] = functions

# Pragma processing

example_pragmas ={}

for names, pragmas in functions_pragmas.items():
    lines = pragmas.split("\n")
    pragma_list = []

    for line in lines:

            if line :
                pragma_dict = {}
                line = line.lower()
                pragma_type = {}
                pragma_protocol = {}
                pragma_ports = {}
                pragma_bundle = {}
                pragma_offset = {}

                words = line.split()
                if words[2] != "interface" and words[0] != "#pragma":
                    continue
                else :
                    pragma_type["type"] = words[2]
                    pragma_protocol["protocol"] = words[3]

                    if (words[3] == "s_axilite"):
                        port = words[4].split("=")

                        pragma_ports["port"]= port[1]

                        if line.find("bundle") != -1 :
                            bundle = words[5].split("=")
                            pragma_bundle["bundle"] = bundle[1]

                        else :
                            pragma_bundle["bundle"] = "-"

                        if line.find("offset") != -1 :
                            offset = words[6].split("=")
                            pragma_offset["offset"] = offset[1]

                        else :
                            pragma_offset["offset"] = "-"




                        pragma_dict.update(pragma_bundle)
                        pragma_dict.update(pragma_offset)


                    elif (words[3] == "axis"):
                        port = words[4].split("=")
                        pragma_ports["port"] = port[1]

                    pragma_dict.update(pragma_protocol)
                    pragma_dict.update(pragma_type)
                    pragma_dict.update(pragma_ports)
                    pragma_list.append(pragma_dict)
    example_pragmas[names] = pragma_list



#Args processing
args = {}
example_args ={}

for name, args in functions_args.items():
    line = args.split(",")
    args_list = []

    for word in line:
        word = word.lower()
        args_dict = {}
        arg_type = {}
        arg_name = {}
        arg_qualifiers = {}
        arg_const = {}

        arg = word.split()
        arg_type["type"] = arg[0]

        if word.find("const") != -1 :
            arg_const["const"] = "const"
            arg_name["name"] =re.sub(r'[^a-zA-Z0-9_]', '', arg[2])
        else :
            arg_const["const"] = "-"
            arg_name["name"] = re.sub(r'[^a-zA-Z0-9_]', '', arg[1])

        if word.find("*") !=-1 :
            arg_qualifiers["qualifier"] = "ref"
        else :
            arg_qualifiers["qualifier"] = "value"
        if word.find("&")!=-1:
            arg_qualifiers["qualifier"] = "addres"
        else:
            arg_qualifiers["qualifier"] = "value"

        args_dict.update(arg_type)
        args_dict.update(arg_name)
        args_dict.update(arg_const)
        args_dict.update(arg_qualifiers)
        args_list.append(args_dict)
    example_args[name]=args_list

#Operation processing
example_operations = {};
for names , functions in functions_dict.items():
    operation_list = [];
    operation_dict = {};
    module_dict = {};
    direction_dict = {};
    for function in functions.splitlines():
        operation_dict = {}
        words = re.split(r"[ .()]+", function)
        if function.find("read") !=-1:
            index = words.index("read")
            module_dict["module"] = words[index-1];
            direction_dict["direction"] = "0"
            operation_dict.update(module_dict)
            operation_dict.update(direction_dict)
            operation_list.append(operation_dict)
        elif function.find("write")!=-1:
            index = words.index("write")
            module_dict["module"] = words[index-1];
            direction_dict["direction"] = "1"
            operation_dict.update(module_dict)
            operation_dict.update(direction_dict)
            operation_list.append(operation_dict)
    if len(operation_list) != 0:
        example_operations[names] = operation_list;

#Final Json

final_json ={}

for name_x, value_x in example_args.items():
    final_example = {}
    final_operation = {}
    big_dict = {}
    final_pragmas = {}
    final_args = {}
    for name_y , value_y in example_pragmas.items():
        if name_y == name_x :
            final_pragmas["Pragmas"] = value_y
            final_args["Args"] = value_x
            big_dict.update(final_pragmas)
            big_dict.update(final_args)
        for name_z, value_z in example_operations.items():
            if name_x == name_z :
                final_operation["Operation"] = value_z
                big_dict.update(final_operation)
    final_json[name_x] = big_dict
with open ("parser_json.json","x+") as file:
    json.dump(final_json,file)


