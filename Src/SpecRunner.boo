namespace BooSpec

import System
import System.Reflection

# runs Spec's
class SpecRunner: 

  private _plugins as List[of SpecPlugin]
  private _specs as List[of Spec]
  private _hub as SpecEventHub
  private _compiler as SpecCompiler

  def constructor():
    _specs = List[of Spec]()
    _plugins = List[of SpecPlugin]()
    _hub = SpecEventHub()
    _compiler = SpecCompiler(_hub)

  def AddPlugin(plugin as SpecPlugin):
    _plugins.Add(plugin) 
	
  def Run():
    for plugin in _plugins:
      plugin.Setup(_hub)
    _hub.fireEvent('start_all_specs')
    for spec in _specs:
      compiledSpec = _compiler.CompileSpec(spec)
      compiledSpec.Run(_hub)
    _hub.fireEvent('end_all_specs')
    for plugin in _plugins:
      plugin.Shutdown(_hub)

  def AddSpecType(testCaseType as Type):
    constr as ConstructorInfo = testCaseType.GetConstructors()[0];
    newTestCase as Spec = constr.Invoke(null)
    AddSpec(newTestCase)

  def AddSpec(testCase as Spec):
    _specs.Add(testCase)
