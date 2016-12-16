## 安装
npm install wildcard-compare

## 测试代码
npm test

## api
```
compare(string, wildcard, memoize = false)
```

## eg
```
compare('', '') => true
compare('abc', '') => false
compare('abc', '+abc') => true
compare('abcd', '+abc') => false
compare('abc', '+abcd') => false
compare('abc', '=abc') => true
compare('abc', '=abcd') => false
compare('abcd', '=abc') => false
compare('abc', '<>abc') => false
compare('abc', '<>abcd') => true
compare('abc', '-abc') => false
compare('abc', '-abcd') => true
compare('abc', '>abc') => false
compare('2', '>1') => true
compare('2', '>1.1') => true
compare('abc', '>=abc') => true
compare('2', '>=1') => true
compare('abc', '<abc') => false
compare('abc', '<abcd') => true
compare('1', '<2') => true
compare('abc', '<=abc') => true
compare('abc', '<=abcd') => true
compare('1.3.1', '=1.%.1') => true
compare('1.3.1', '=%1.3') => false
compare('1.3.1', '-1.%.1') => false
compare('1.3.12', '+1.3.1%') => true
compare('1.1', '/1.*1/') => true
compare('1.1', '/2\.1/') => false
compare('abc', '=abcd,>bcd;=bcd;=abcd;/abcd/;=ab%;') => true
compare('abc', '=abcd;=bcd;=abcd;/a.*c/;=ab%d;') => true
compare 300000 times, used cache cost 130ms, and not used cache cost 1445ms.
```


## 通配符配置规则
----------------------------

### 基本单元规则
```
{
    +%s : equal
    =%s : equal
    -%s : not equal
    <>%s : not equal
    >%s : greater than
    >=%s ： greater than or equal
    <%s : less than
    <=%s : less than or equal
    % : like
    /%s/ : 正则表达式
}
```

### 组规则
```
{
    , : 与
    ; : 或
}
```
其中，'与'的权重大于'或'

### 示例
1. 大于4.0且小于=6.0或者所有8.*版本
```
>4.0,<=6.0;8.%
```

2. 等于wps或者et
```
=wps;=et
```

3. 首字母不能为大写字母的字符串
```
/^[^A-Z].*/
```
