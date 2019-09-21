# ReadingListApp


## エラーとその対応

### RealmSwiftPermissionRole

```
'RLMException', reason: 'Primary key property 'name' does not exist on object 'RealmSwiftPermissionRole''
```

Beta版のXcodeでビルドすると上記エラーが生じる。
現在だとXcode10系でビルドする必要がある
→ RealmSwiftの最新を入れるようにすると解消する、現状Xcode11に対応しているものをpodfileにて定義

参考：　https://github.com/realm/realm-cocoa/issues/6163
