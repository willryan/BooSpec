namespace BooSpec

# a "compiled" test ready for execution - has a list of befores to run,
# a test to run, and a list of afters to run (which are ensured to run 
# once the test begins)
# 
# TODO: replace with a tree structure
class SpecTest(): 
	protected _test as callable
	protected _descList as List
	protected _beforeList as List
	protected _afterList as List
	
	def constructor(test as callable, descList as List, beforeList as List, afterList as List):
		_test = test
		_descList = descList
		_beforeList = beforeList
		_afterList = afterList
		
	def Execute(hub as SpecEventHub):
		for before as callable in _beforeList:
			hub.fireEvent('before', [self])
			before()
		try:
			hub.fireEvent('execute_test', [self])
			_test()
		ensure:
			for after as callable in _afterList:
				hub.fireEvent('after', [self])
				after()

	def GetDescriptionList() as List:
		return _descList

	def GetDescription() as string:
		return _descList.Join(" ")

