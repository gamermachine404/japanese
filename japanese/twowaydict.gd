class_name TwoWayDict

var one = []
var two = []
	
func appendFromFile(what:String):
	if not FileAccess.file_exists(what):
		print("It's so joever...")
		return null
	var values_file = FileAccess.open(what, FileAccess.READ)
	while values_file.get_position() < values_file.get_length():
		self.appendValues(values_file.get_line(), values_file.get_line())

func getTwoFromOne(one2Look):
	return two[one.find(one2Look)]

func getOneFromTwo(two2Look):
	return one[two.find(two2Look)]

func getEitherOr(nani):
	var index = one.find(nani)
	print(index)
	if not index == -1:
		#print(index)
		return two[index]
	index = two.find(nani)
	#print(index)
	return null if index==-1 else one[index]
	
func appendValues(first, second):
	one.append(first)
	two.append(second)
	
func appendOne(first):
	one.append(first)

func appendTwo(second):
	two.append(second)

func setValuesArrays(first:Array, second:Array):
	if first.size() == second.size():
		one = first
		two = second
	else:
		print("first and second not same length, can't do anything")
