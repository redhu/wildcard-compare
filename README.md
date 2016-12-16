#通配符配置规则
----------------------------

## 基本单元规则
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

## 组规则
```
{
    , : 与
    ; : 或
}
```
其中，'与'的权重大于'或'

## 示例
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
