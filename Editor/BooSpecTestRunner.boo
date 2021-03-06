import UnityEditor
import System
import System.Collections.Generic
import System.Linq
import System.Reflection
import BooSpec

class BooSpecTestRunner:
	[MenuItem("BooSpec/Run All Specs %#s")]
	private static def RunAllTests():
		ClearDebugLog()
		runner as SpecRunner = SpecRunner()
		runner.AddPlugin(BooSpecLoggerUnity())
		FindAndAddAllTestCases(runner)
		runner.Run()
		
	private static def ClearDebugLog():
		assembly as Assembly = Assembly.GetAssembly(SceneView) #typeof
		type as Type = assembly.GetType("UnityEditorInternal.LogEntries")
		method as MethodInfo = type.GetMethod("Clear")
		method.Invoke(object(), null)

	private static def FindAndAddAllTestCases(runner as SpecRunner):
    testCaseTypes as IEnumerable[of Type] = AppDomain.CurrentDomain.GetAssemblies()\
    	.Select({x | return x.GetTypes()})\
    	.SelectMany({x | return x})\
    	.Where({c | return (not c.IsAbstract)})\
    	.Where({c | return c.IsSubclassOf(Spec)}) # typeof
    for testCaseType as Type in testCaseTypes:
      runner.AddSpecType(testCaseType)

	
		
