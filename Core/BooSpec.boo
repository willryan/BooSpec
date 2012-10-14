import UnityEngine

# BooSpec - based on RSpec.  This is VERY much a work-in-progress.
# I may rework a great deal of the interior.  I am sure I missed important
# things.  This is just to get the ball rolling so I can develop games 
# using behavioral testing with the Unity Engine.
#
# USAGE:
#
# class MyTest(BooSpec):
# 	def Spec(): // define your spec inside here
#     Describe("functional area") do:
#				Before() do:
#					doSomeSetup()
#					andAnotherSetup('arg')
#
#       Describe("subarea") do:
#					Before() do: 
#						moreSetup()
#
#					It ("tests something") do:
#						Expr(myObject.SomeFunction(1,2,3)).Should(Equal("hello"))
#						Expr(myObject.MakeAnArray("foo", "bar")).Should(Contain("bar"))
#
#					It ("tests another thing") do:
#						Expr(myObject.Add(2,5)).Should(BeGreaterThan(6))
#
#					After() do:
#					 cleanup()	
#
# TODO: let's (if possible)

class BooSpec: 
	protected _beforeAll as callable
	protected _afterAll as callable
	protected _rootDescribe as BooSpecDescribe

	# PUBLIC FACING METHODS
	def constructor():
		# use class name as topmost descriptor
		_rootDescribe = BooSpecDescribe(self.GetType().ToString(), null)
		Spec()
		
	# define this method and insert Before, Describe etc. in the body to create a spec
	# TODO: can I just make the file be BooSpec("name", callable), then pick up 
	# every instance of a BooSpec at runtime?  Not sure if I need to declare classes
	# in Boo files to be valid Boo.
	virtual def Spec():
		pass
		
	def BeforeAll(content as callable):
		_beforeAll = content
		
	def AfterAll(content as callable):
		_afterAll = content
		
	def Describe(name as string, content as callable):
		getCurrentDescribe().Describe(name, content)
		
	def It(desc as string, content as callable):
		getCurrentDescribe().It(desc, content)
		
	def Before(content as callable):
		getCurrentDescribe().Before(content)
		
	def After(content as callable):
		getCurrentDescribe().After(content)
		
	# TODO: can I monkeypatch object somehow so it has a Should() method?
	# I like that better than wrapping things in Expr()
	def Expr(expression as object):
		return BooSpecExpression(expression)
		
	# RESULT CHECKERS
	# TODO: figure a way to have these in scope and not defined here 
	# (as objects? but names are too generic)
	# but note that anything (including object instantiation) which returns a
	# BooSpecCondition would be valid.  So users can subclass BooSpecCondition
	# to create custom result checkers
	def Equal(expectedValue as object) as BooSpecCondition:
		return BooSpecCondition({'eval': { check | 
			return check == expectedValue;
			}, 'valueText': "equal $(expectedValue)"})
		
	def BeGreaterThan(expectedValue as object) as BooSpecCondition:
		return BooSpecCondition({'eval': { check |
			return check cast double > expectedValue cast double;
		}, 'valueText': "greater than $(expectedValue)"})	
		
	def BeGreaterThanOrEqualTo(expectedValue as object) as BooSpecCondition:
		return BooSpecCondition({'eval': { check |
			return check cast double >= expectedValue cast double;
		}, 'valueText': "greater than or equal to $(expectedValue)"})	
		
	def BeLessThan(expectedValue as object) as BooSpecCondition:
		return BooSpecCondition({'eval': { check |
			return check cast double < expectedValue cast double;
		}, 'valueText': "less than $(expectedValue)"})	
		
	def BeLessThanOrEqualTo(expectedValue as object) as BooSpecCondition:
		return BooSpecCondition({'eval': { check |
			return check cast double <= expectedValue cast double;
		}, 'valueText': "less than or equal to $(expectedValue)"})	
		
	def Contain(expectedValue as object) as BooSpecCondition:
		return BooSpecCondition({'eval': { check |
			arr = check as List;
			return arr.Contains(expectedValue);
		}, 'valueText': "contain $(expectedValue)"})
	
	# INTERNAL FACING METHODS
	
	# get the current describe (or it) being built, generally so we can create another
	# describe or it inside that scope
	def getCurrentDescribe() as BooSpecDescribe:
		return _rootDescribe.GetCurrentDescribe()
						
	# run this spec, by building out the tests and executing them
	def run():
		tests = buildTests()
		executeTests(tests)
		
	# builds a list of test objects.
	# TODO - eventually make this a tree or something, it parallels the Describe structure
	# don't technically need to use different objects for that, but I'd rather
	def buildTests() as List:
		tests = []
		_rootDescribe.BuildTests(tests, [], [], [])
		return tests
	
	# run a list of tests, and log results and failures
	def executeTests(tests as List):
		successCount as int = 0
		failCount as int = 0
		if _beforeAll:
			_beforeAll()
		for test as BooTest in tests:
			try:
				test.Execute()
				successCount += 1
			except e:
				Debug.Log("$(getDescribeMessage()): $(e)")
				failCount += 1
		if _afterAll:
			_afterAll()
		printLog(successCount, failCount)
		
	# log successes, failures, and test list
	# TODO indicate success/failure alongside each test
	# - to be done when restructuring tests as a tree
	def printLog(successCount as int, failCount as int):
		Debug.Log("$(successCount) passed tests, $(failCount) failures")
		log = []
		_rootDescribe.GatherLog(log, 0)
		str = log.Join("\r\n")
		Debug.Log(str)
		
	# gets a message which describes the current test (describe1 describe2 it)
	def getDescribeMessage() as string:
		return _rootDescribe.GetDescribeMessage()
