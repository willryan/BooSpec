namespace BooSpec

# object used to represent a describe block as the test execution 
# structure is built up
class SpecDescribe: 
  protected _desc as string
  protected _content as callable
  protected _describes as List[of SpecDescribe]
  protected _before as callable
  protected _after as callable
  protected _buildingDescribe as SpecDescribe
  
  def constructor(name as string, content as callable):  
    _desc = name
    _content = content
    _describes = List[of SpecDescribe]()
  
  virtual def AddDescribe(name as string, content as callable) as SpecDescribe:
    desc = SpecDescribe(name, content)
    _describes.Add(desc)
    return desc
    
  virtual def AddIt(description as string, content as callable) as SpecIt:
    desc = SpecIt(description, content)
    _describes.Add(desc)
    return desc
    
  virtual def AddBefore(content as callable):
    _before = content
    
  virtual def AddAfter(content as callable):
    _after = content

  def GetBefore() as callable:
    return _before

  def GetAfter() as callable:
    return _after
    
  def GetCurrentDescribe() as SpecDescribe:
    if _buildingDescribe:
      return _buildingDescribe.GetCurrentDescribe()
    else:
      return self

  def GetDescription() as string:
    return _desc
    
  virtual def Compile():
    if _content:
      _content()
    for describe in _describes:
      _buildingDescribe = describe
      describe.Compile()
      _buildingDescribe = null

  virtual def Run(hub as SpecEventHub, context as List[of SpecDescribe]):
    hub.fireEvent('start_describe', [self, context])
    newContext = List[of SpecDescribe](context)
    newContext.Push(self)
    for describe in _describes:
      describe.Run(hub, newContext)
    hub.fireEvent('end_describe', [self, context])

