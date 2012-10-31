namespace BooSpec

class CompiledSpec:

  protected _beforeAll as callable
  protected _afterAll as callable
  protected _rootDescribe as SpecDescribe

  def constructor(specInfo as Hash):
    _rootDescribe = specInfo['root']
    _beforeAll = specInfo['beforeAll']
    _afterAll = specInfo['afterAll']

  def Run(hub as SpecEventHub):
    hub.fireEvent('start_spec')
    if _beforeAll:
      hub.fireEvent('before_all')
      _beforeAll()
    _rootDescribe.Run(hub, List[of SpecDescribe]())
    if _afterAll:
      _afterAll()
      hub.fireEvent('after_all')
    hub.fireEvent('end_spec')
