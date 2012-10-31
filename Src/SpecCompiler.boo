namespace BooSpec

class SpecCompiler:

  protected _hub as SpecEventHub

  def constructor(hub as SpecEventHub):
    _hub = hub
  
  def CompileSpec(spec as Spec) as CompiledSpec:
    spec.Spec()
    _hub.fireEvent('compile_spec')
    specObj = spec.toObject()
    (specObj['root'] as SpecDescribe).Compile()
    return CompiledSpec(specObj)

