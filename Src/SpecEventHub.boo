namespace BooSpec

class SpecEventHub:

  protected _listeners as Hash = {}

  def fireEvent(eventName as string):
    fireEvent(eventName, [])

  def fireEvent(eventName as string, arguments as List):
    listeners as List = _listeners[eventName] or []
    for listener as callable in listeners:
      listener(arguments)
    
  def onEvent(eventName, callback as callable):
    listeners as List = _listeners[eventName]
    if listeners == null:
      _listeners[eventName] = []
      listeners = _listeners[eventName]
    listeners.Add(callback)

