def remove_duplicates(s):
    s = str(s) 
    unique_chars = ""
    for char in s:
        if char not in unique_chars:
            unique_chars += char
    return unique_chars

input_string = input("Enter a string: ")
print(remove_duplicates(input_string))
