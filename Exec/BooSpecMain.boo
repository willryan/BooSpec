import System
import BooSpec

class BooSpecMain:
  _loggers as Hash

  def constructor():
    _loggers = {}
    SetLogger("dots", SpecLoggerDots())
    SetLogger("detailed", SpecLoggerDetailed())

  def RunCmdLine(args as (string)):
    Run(ParseArgs(args))

  def Run(argsHash as Hash):
    runner as SpecRunner = SpecRunner()
    logFormat = argsHash['format'] or 'dots'
    runner.AddPlugin(_loggers[logFormat] as SpecPlugin)
    specName = argsHash['spec'] or null
    FindAndAddAllTestCases(runner, specName)
    runner.Run()

  def FindAndAddAllTestCases(runner as SpecRunner, specName as string):
    #assemblies = [item for item in AppDomain.CurrentDomain.GetAssemblies()]
    assemblies = AppDomain.CurrentDomain.GetAssemblies()
    for asm in assemblies:
      for typ in asm.GetTypes():
        if not typ.IsAbstract:
          if typ.IsSubclassOf(Spec):
            if specName == null or specName == typ.ToString():
              runner.AddSpecType(typ)

  def ParseArgs(args as (string)) as Hash:
    argsHash = {}
    for arg in args:
      r = /^-(?<key>\w+):(?<value>\w+)$/.Match(arg)
      key = r.Groups["key"].Value
      value = r.Groups["value"].Value
      if key == "f":
        argsHash['format'] = value
      elif key == "spec":
        argsHash['spec'] = value
      else:
        Console.WriteLine("unknown argument: $(arg)")
      
    return argsHash

  def SetLogger(loggerName as string, logger as SpecPlugin):
    _loggers[loggerName] = logger

BooSpecMain().RunCmdLine(argv)
