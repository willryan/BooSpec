namespace BooSpec

# class used to represent an it block (pre-execution)
class SpecIt (SpecDescribe): 

  def constructor(name as string, content as callable):  
    super(name, content)
    
  virtual def AddDescribe(name as string, content as callable):
    raise "describe not supported in it"
    
  virtual def AddIt(desc as string, content as callable):
    raise "it not supported in it"

  virtual def AddBefore(content as callable):
    raise "before not supported in it"
    
  virtual def AddAfter(content as callable):
    raise "after not supported in it"

  virtual def Compile():
    pass

  virtual def Run(hub as SpecEventHub, context as List[of SpecDescribe]):
    try:
      for desc in context:
        before = desc.GetBefore()
        if before:
          before()
      _content()
      for desc as SpecDescribe in reversed(context):
        after = desc.GetAfter()
        if after:
          after()
      hub.fireEvent('test_passed', [self, context])
    except e:
      hub.fireEvent('test_failed', [self, context, e])

