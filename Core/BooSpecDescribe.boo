# object used to represent a describe block as the test execution 
# structure is built up
class BooSpecDescribe: 
	protected _desc as string
	protected _content as callable
	protected _describes as List
	protected _before as callable
	protected _after as callable
	protected _buildingDescribe as BooSpecDescribe
	
	def constructor(name as string, content as callable):	
		_desc = name
		_content = content
		_describes = []
	
	virtual def Describe(name as string, content as callable) as BooSpecDescribe:
		desc = BooSpecDescribe(name, content)
		_describes.Add(desc)
		return desc
		
	virtual def It(description as string, content as callable) as BooSpecIt:
		desc = BooSpecIt(description, content)
		_describes.Add(desc)
		return desc
		
	def Before(content as callable):
		_before = content
		
	def After(content as callable):
		_after = content
		
	def GetCurrentDescribe() as BooSpecDescribe:
		if _buildingDescribe:
			return _buildingDescribe.GetCurrentDescribe()
		else:
			return self
				
	# TODO: store tests as tree structure and not a big list
	virtual def BuildTests(tests as List, descList as List, beforeList as List, afterList as List):
		descList = List(descList)
		descList.Add(_desc)
		if _content:
			_content() // will set before, after, interior describes and its
		if _before:
			beforeList = List(beforeList)
			beforeList.Add(_before)
		if _after:
			afterList = List(afterList)
			afterList.Insert(0, _after)
		for describe as BooSpecDescribe in _describes:
			_buildingDescribe = describe
			describe.BuildTests(tests, descList, beforeList, afterList)
			_buildingDescribe = null

	virtual def GatherLog(log as List, level as int):
		prefix = " " * level
		log.Add("$(prefix)$(_desc)")
		for describe as BooSpecDescribe in _describes:
			describe.GatherLog(log, level+2)
		
	def GetDescribeMessage() as string:
		if _buildingDescribe:
			return "$(_desc) $(_buildingDescribe.GetDescribeMessage())"
		else:
			return "$(_desc)"