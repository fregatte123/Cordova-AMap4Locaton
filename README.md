高德Cordova 定位插件
==
加深对于Cordova插件的理解编写的Demo例子
<BR>
cordova plugin add  /Users/lixun/Documents/bitbucket/Cordova-AMap4Locaton   --variable IOS_APP_KEY=77f0f5924156d376b16482e6b0630d0d   --variable ANDROID_APP_KEY=1255536cc98e9e85dde3fd54baaf6b8c
<br>
Android
--
###Android API：
http://lbs.amap.com/api/android-location-sdk/locationsummary/
###Android配置项：
```xml
<meta-data android:name="com.amap.api.v2.apikey"
  android:value="申请的apikey" />
```
iOS
--
###iOS API:
http://lbs.amap.com/api/ios-location-sdk/summary/
###iOS配置项:
```xml
<config-file target="*-Info.plist" parent="AMapApiKey">
  <string>申请的apiKey</string>
</config-file>
```
<br>
调用示例
--
```javascript
if(cordova.plugins.amap4location){
    cordova.plugins.amap4location.location(
      function (response) {
      /**{provinceName:'',cityName:'',
        cityCode:'',districtName:'',
        roadName:''}*/
        alert("当前的位置:" +
          "  省份-"+response['provinceName']
          +" 市-"+response['cityName']
          +" 区-"+response['districtName']
          +" 街-"+response['roadName']);
        },
      function (error) {
      /**{errorInfo:'',errorCode:''}*/
        alert("异常信息:"
          + " 错误编码:"+error['errorCode']
          + " 错误信息"+error['errorInfo']);
        }
      );
  }
```
