# Pattern and Replacement examples

只化简指数表达式
```
expression/.E^x_ :> (E^x // ToStraight // RemoveLog // Simplify)
```
