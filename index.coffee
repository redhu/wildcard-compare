# =============================
# 主要用于通配符比对
# =============================

memoize = (func)->
  cache = {}
  addressArr = []
  maxLen = 10000
  setInterval(->
    while addressArr.length > maxLen
      address = addressArr.shift()
      delete cache[address]
  ,60 * 60 * 1000)

  return (args...)->
    address = args.join('_')
    unless cache.hasOwnProperty(address)
      cache[address] = func.apply(@, args)
      addressArr.push(address)
    return cache[address]

compareFunc = (->
  return {
    eq : (a, b)->
      return a is b

    ne : (a, b)->
      return a isnt b

    gt : (a, b)->
      return a > b

    gte : (a, b)->
      return a >= b

    lt : (a, b)->
      return a < b

    lte : (a, b)->
      return a <= b

    like : (a, b)->
      return @test(a, b)

    not_like : (a, b)->
      return not @like(a, b)

    test : (a, b)->
      return b.test(a)
  }
)()


#==================================================
# 根据单个条件，返回比较函数
#==================================================
getFuncByCondStr = (str)->
  likePercentReg = /([^\\])%|^%/g
  signNeedEscapeReg = /\.|\+|\?|\*|\:|\!|\[|\]|\(\|\)|\^|\$|\{|\}|\=/g
  genLikeReg = (str)->
    str = str.replace(signNeedEscapeReg, ($1)->
      return "\\#{$1}"
    ).replace(likePercentReg, ($0, $1 = '')->
      return $1 + '.*'
    )
    str = '^' + str + '$'

    return new RegExp(str)

  genCommonFunc = (methodName, _reg)->
    return (str, reg)->
      reg = _reg || reg
      cond = str.replace(reg, '')
      return (value)->
        return compareFunc[methodName](value, cond)
  funcGenArr = [
    {
      reg : /^=|^\+/
      getFunc : (str = '')->
        cond = str.replace(@reg, '')
        if likePercentReg.test(cond)
          reg = genLikeReg(cond)
          return (value)->
            return compareFunc.like(value, reg)
        else
          return (value)->
            return compareFunc.eq(value, cond)

    }
    {
      reg : /^-|^<>/
      getFunc : (str = '')->
        cond = str.replace(@reg, '')
        if likePercentReg.test(cond)
          reg = genLikeReg(cond)
          return (value)->
            return compareFunc.not_like(value, reg)
        else
          return (value)->
            return compareFunc.ne(value, cond)
    }
    {
      reg : /^>[^=]/
      getFunc : genCommonFunc('gt', /^>/)
    }
    {
      reg : /^>=/
      getFunc : genCommonFunc('gte')
    }
    {
      reg : /^<[^=]/
      getFunc : genCommonFunc('lt', /^</)
    }
    {
      reg : /^<=/
      getFunc : genCommonFunc('lte')
    }
    {
      reg : /^\/(.*)\/$/
      getFunc : (str)->
        reg = eval(str)
        return (value)->
          return compareFunc.test(value, reg)
    }
  ]

  for gen in funcGenArr
    if gen.reg.test(str)
      return gen.getFunc(str, gen.reg)

  genEq = funcGenArr[0]

  return genEq.getFunc(str, gen.reg)


#==================================================
# 条件编译, 返回的是一串可执行的函数
#==================================================
_condCompile = (str)->
  orSplit = ';'
  andSplit = ','
  ret = []

  str = str.replace(/\r|\n/g, '')
  for orStr in str.split(orSplit)
    orArr = []
    for andStr in orStr.split(andSplit)
      andStr = andStr.replace(/^[\s]+/g, '').replace(/[\s]+$/g, '')
      orArr.push(getFuncByCondStr(andStr))
    ret.push(orArr)
  return ret

condCompile = memoize(_condCompile)

compare = (str, condStr, ifFuncCache = true)->
  if ifFuncCache
    condArr = condCompile(condStr)
  else
    condArr = _condCompile(condStr)
  ret = false
  for andArr in condArr
    orRet = true
    for andFuc in andArr
      b = andFuc(str)
      unless b
        orRet = false
        break
    if orRet
      ret = true
      break
  return ret


module.exports = {
  compare : compare
  compile : condCompile
}

#=============================================
# 单元测试
#=============================================
test = ->
  testArr = [
    ['', '', true]
    ['abc', '', false]
    ['abc', '+abc', true]
    ['abcd', '+abc', false]
    ['abc', '+abcd', false]
    ['abc', '=abc', true]
    ['abc', '=abcd', false]
    ['abcd', '=abc', false]
    ['abc', '<>abc', false]
    ['abc', '<>abcd', true]
    ['abc', '-abc', false]
    ['abc', '-abcd', true]
    ['abc', '>abc', false]
    ['2', '>1', true]
    ['2', '>1.1', true]
    ['abc', '>=abc', true]
    ['2', '>=1', true]
    ['abc', '<abc', false]
    ['abc', '<abcd', true]
    ['1', '<2', true]
    ['abc', '<=abc', true]
    ['abc', '<=abcd', true]
    ['1.3.1', '=1.%.1', true]
    ['1.3.1', '=%1.3', false]
    ['1.3.1', '-1.%.1', false]
    ['1.3.12', '+1.3.1%', true]
    ['1.1', '/1.*1/', true]
    ['1.1', '/2\\.1/', false]
    ['abc', '=abcd,>bcd;=bcd;=abcd;/abcd/;=ab%;', true]
    ['abc', '=abcd;=bcd;=abcd;/a.*c/;=ab%d;', true]
  ]

  for t in testArr
    str = t[0]
    value = t[1]
    ret = compare(str, value)
    if ret is t[2]
      console.info 'success', str, value, ret
    else
      console.error 'failed', str, value, ret

  d0 = new Date()
  for t in testArr
    for i in [1...100000]
      compare(t[0], t[1])
  d1 = new Date()
  for t in testArr
    for i in [1...100000]
      compare(t[0], t[1], false)
  d2 = new Date()
  console.log 'used cache:', d1 - d0, 'ms, not used cache:', d2 - d1, 'ms.'

if /index/.test(process.argv[1])
  test()
  process.exit(-1)

