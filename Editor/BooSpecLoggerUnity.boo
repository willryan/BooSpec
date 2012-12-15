import UnityEngine
import BooSpec

class BooSpecLoggerUnity (SpecPlugin):

  protected _passedCount as int
  protected _failCount as int

  virtual def Setup(hub as SpecEventHub):
    hub.onEvent('test_passed') do(args as List):
      _passedCount += 1

    hub.onEvent('test_failed') do(args as List):
      test as SpecIt = args[0]
      context as List[of SpecDescribe] = args[1]
      error as Exception = args[2]
      _failCount += 1
      Debug.Log("Test failed - $(test.GetDescription()): $(error)")

    hub.onEvent('end_all_specs') do(args as List):
      Debug.Log("$(_passedCount) passed tests, $(_failCount) failures")

  virtual def Shutdown(hub as SpecEventHub):
    pass

