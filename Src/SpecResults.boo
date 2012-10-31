namespace BooSpec

class SpecResults:
  _results as Hash = {}

  def LogResults(name as string, successCount as int, failCount as int):
    _results[name] = {'pass': successCount, 'fail': failCount}

  def SuccessCount() as int:
    return GetTotal('pass')

  def FailCount() as int:
    return GetTotal('fail')

  def GetTotal(totalType as string) as int:
    total = 0
    for res as Hash in _results.Values:
      total += (res[totalType] cast int)
    return total 

