# a "compiled" test ready for execution - has a list of befores to run,
# a test to run, and a list of afters to run (which are ensured to run 
# once the test begins)
# 
# TODO: replace with a tree structure
class BooTest(): 
	protected _test as callable
	protected _descList as List
	protected _beforeList as List
	protected _afterList as List
	
	def constructor(test as callable, descList as List, beforeList as List, afterList as List):
		_test = test
		_descList = descList
		_beforeList = beforeList
		_afterList = afterList
		
	def Execute():
		for before as callable in _beforeList:
			before()
		try:
			_test()
		ensure:
			for after as callable in _afterList:
				after()
