//
//  CDVAMapLocation.m
//  Created by tomisacat on 16/1/8.
//
//

#import "CDVAMap4Location.h"

@implementation CDVAMap4Location


//readValueFrom mainBundle
-(NSString *)getAMapApiKey{
    return [[[NSBundle mainBundle]infoDictionary]objectForKey:@"AMapApiKey"];
}

//init Config
-(void) initConfig{
    if(!self.locationManager){
        //set APIKey
        [AMapLocationServices sharedServices].apiKey = [self getAMapApiKey];
        //init locationManager
        self.locationManager = [[AMapLocationManager alloc]init];
        //set DesiredAccuracy
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    }
}


//location method
-(void) location:(CDVInvokedUrlCommand*)command{
    [self initConfig];

    [self.commandDelegate runInBackground:^{
        [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
            CDVPluginResult* pluginResult = nil;
            if (error)
            {

                if (error.code == AMapLocationErrorLocateFailed)
                {
                NSString *errorCode = [NSString stringWithFormat: @"%ld", (long)error.code];
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      errorCode,@"errorCode",
                                      error.localizedDescription,@"errorInfo",
                                      nil];
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:dict];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
            }else{
                if (regeocode)
                {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:regeocode.province,@"provinceName",
                                          regeocode.city,@"cityName",
                                          regeocode.citycode,@"cityCode",
                                          regeocode.district,@"districtName",
                                          //regeocode.township,@"roadName",
                                          regeocode.formattedAddress,@"addr",
                                          location.coordinate.latitude,@"lat",
                                          location.coordinate.longitude,@"lng",
                                          regeocode.street,@"street",
                                          regeocode.number,@"streetNum",
                                          regeocode.POIName,@"poiName",
                                          regeocode.AOIName,@"aoiName",
                                          nil];
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
            }
        }];
    }];
}


@end
