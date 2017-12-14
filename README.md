高效javascript通配符比较

## install
npm install wildcard-compare

## test
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

### item rules
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
    /%s/ : regular
}
```

### group rules
```
{
    , : and
    ; : or
}
```
"and" has highter weight then "or"

### example
1. greate than 4.0 and less than or equals 6.0 or like 8.*
```
>4.0,<=6.0;8.%
```

2. equals wps or equals et
```
=wps;=et
```

3. first letter can't be capital
```
/^[^A-Z].*/
```
