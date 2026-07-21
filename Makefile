.PHONY: generate parser user

generate : parser
	python folder_generator.py
parser : user
	python parser_C.py
user:
	python User_file.py
