namespace BooSpec

import System

class SpecLoggerDetailed (SpecPlugin):
  protected _passedCount as int
  protected _failCount as int
  protected _failures as List[of string] 

  def constructor():
    _failures = List[of string]()

  virtual def Setup(hub as SpecEventHub):
    hub.onEvent('test_passed') do(args as List):
      WriteResult(args, true)

    hub.onEvent('test_failed') do(args as List):
      WriteResult(args, false)

    hub.onEvent('start_describe') do(args as List):
      Console.ForegroundColor = ConsoleColor.Gray
      spec = args[0] as SpecDescribe
      context = args[1] as List[of SpecDescribe]
      Console.Write("  " * context.Count)
      Console.WriteLine(spec.GetDescription())

    hub.onEvent('end_all_specs') do(args as List):
      Console.ForegroundColor = ConsoleColor.Red
      Console.WriteLine("")
      Console.WriteLine(_failures.Join("\n\n"))
      if _failCount == 0:
        Console.ForegroundColor = ConsoleColor.Green
      Console.WriteLine("\n$(_passedCount) passed tests, $(_failCount) failures")
      Console.ResetColor()

  virtual def Shutdown(hub as SpecEventHub):
    pass

  private def WriteResult(args as List, passed as bool):
    test as SpecIt = args[0]
    context as List[of SpecDescribe] = args[1]
    error as Exception = null
    if not passed:
      error = args[2]
    if passed:
      _passedCount += 1
      Console.ForegroundColor = ConsoleColor.Green
    else:
      _failCount += 1
      _failures.Add("$(test.GetDescription()): $(error)")
      Console.ForegroundColor = ConsoleColor.Red
    Console.Write("  " * context.Count)
    Console.WriteLine(test.GetDescription())

