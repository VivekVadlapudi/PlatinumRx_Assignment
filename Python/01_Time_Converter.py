def convert_minutes(minutes):
    if not isinstance(minutes, int) or minutes < 0:
        return "Invalid input"
    
    hours = minutes // 60
    mins = minutes % 60
    
    result = ""
    if hours > 0:
        result += f"{hours} hr{'s' if hours > 1 else ''} "
    result += f"{mins} min{'s' if mins != 1 else ''}"
    
    return result


# print(convert_minutes(130))  # 2 hrs 10 mins
# print(convert_minutes(50))   # 50 mins
# print(convert_minutes(60))   # 1 hr 0 mins
# print(convert_minutes(0))    # 0 mins
# print(convert_minutes(-10))  # Invalid input

input_minutes = int(input("Enter time in minutes: "))
print(convert_minutes(input_minutes))
