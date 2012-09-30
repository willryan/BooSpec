# class used to represent an it block (pre-execution)
class BooSpecIt (BooSpecDescribe): 

	def constructor(name as string, content as callable):	
		super(name, content)
		
	virtual def Describe(name as string, content as callable):
		raise "describe not supported in it"
		
	virtual def It(desc as string, content as callable):
		raise "it not supported in it"

	virtual def BuildTests(tests as List, descList as List, beforeList as List, afterList as List):
		tests.Add(BooTest(_content, descList, beforeList, afterList))
