import System
import System.Reflection

# runs BooSpec's
class BooSpecRunner: 

	private _tests as List = []
	
	def Add(testCase):
		_tests.Add(testCase);
	
	def Run():
		for test as BooSpec in _tests:
			test.run()

	def AddAll(testCaseType as Type):
		constr as ConstructorInfo = testCaseType.GetConstructors()[0];
		newTestCase = constr.Invoke(null)
		Add(newTestCase)
