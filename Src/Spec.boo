namespace BooSpec
# TODO: let's (if possible)

class Spec: 
  protected _beforeAll as callable
  protected _afterAll as callable
  protected _rootDescribe as SpecDescribe

  # PUBLIC FACING METHODS
  def constructor():
    # use class name as topmost descriptor
    _rootDescribe = SpecDescribe(self.GetType().ToString(), null)
    
  # define this method and insert Before, Describe etc. in the body to create a spec
  # TODO: can I just make the file be Spec("name", callable), then pick up 
  # every instance of a Spec at runtime?  Not sure if I need to declare classes
  # in Boo files to be valid Boo.
  virtual def Spec():
    pass
    
  def BeforeAll(content as callable):
    _beforeAll = content
    
  def AfterAll(content as callable):
    _afterAll = content
    
  def Describe(name as string, content as callable):
    getCurrentDescribe().AddDescribe(name, content)
    
  def It(desc as string, content as callable):
    getCurrentDescribe().AddIt(desc, content)
    
  def Before(content as callable):
    getCurrentDescribe().AddBefore(content)
    
  def After(content as callable):
    getCurrentDescribe().AddAfter(content)
    
  def Expect(expression as object):
    return SpecExpression(expression)

  # INTERNAL FACING METHODS
  def toObject() as Hash:
    return {'root': _rootDescribe, 'beforeAll': _beforeAll, 'afterAll': _afterAll}

  # get the current describe (or it) being built, generally so we can create another
  # describe or it inside that scope
  private def getCurrentDescribe() as SpecDescribe:
    return _rootDescribe.GetCurrentDescribe()

