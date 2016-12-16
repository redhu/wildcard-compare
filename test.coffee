#=============================================
# 单元测试
#=============================================

compare = require('./index').compare

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
    console.info "compare('#{str}', '#{value}') => #{ret}"
  else
    console.error "compare('#{str}', '#{value}') => #{ret}"

d0 = new Date()
for t in testArr
  for i in [1...10000]
    compare(t[0], t[1])

d1 = new Date()
for t in testArr
  for i in [1...10000]
    compare(t[0], t[1], false)
d2 = new Date()

console.log "compare #{10000 * testArr.length} times, used cache cost #{d1 - d0}ms, and not used cache cost #{d2 - d1}ms."

process.exit(-1)
