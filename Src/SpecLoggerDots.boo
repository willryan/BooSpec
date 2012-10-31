namespace BooSpec 

import System

class SpecLoggerDots (SpecPlugin):
  protected _passedCount as int
  protected _failCount as int
  protected _failures as List[of string] 

  def constructor():
    _failures = List[of string]()

  virtual def Setup(hub as SpecEventHub):
    hub.onEvent('test_passed') do(args as List):
      _passedCount += 1
      Console.ForegroundColor = ConsoleColor.Green
      Console.Write(".")

    hub.onEvent('test_failed') do(args as List):
      test as SpecTest = args[0]
      error as Exception = args[1]
      _failCount += 1
      Console.ForegroundColor = ConsoleColor.Red
      Console.Write("F")
      _failures.Add("Test failed - $(test.GetDescription()): $(error)")

    hub.onEvent('end_all_specs') do(args as List):
      Console.WriteLine("")
      if _failCount > 0:
        Console.ForegroundColor = ConsoleColor.Red
      else:
        Console.ForegroundColor = ConsoleColor.Green
      Console.WriteLine(_failures.Join("\n\n"))
      Console.WriteLine("\n$(_passedCount) passed tests, $(_failCount) failures")
      Console.ResetColor()

  virtual def Shutdown(hub as SpecEventHub):
    pass

