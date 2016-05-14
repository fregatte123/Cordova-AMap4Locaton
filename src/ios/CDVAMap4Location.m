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
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    if(regeocode.province){
                        [dict setObject:regeocode.province forKey:@"provinceName"];
                    }
                    if(regeocode.city){
                        [dict setObject:regeocode.city forKey:@"cityName"];
                    }
                    if(regeocode.citycode){
                        [dict setObject:regeocode.citycode forKey:@"cityCode"];
                    }
                    if(regeocode.district){
                        [dict setObject:regeocode.district forKey:@"districtName"];
                    }
                    if(regeocode.formattedAddress){
                        [dict setObject:regeocode.formattedAddress forKey:@"addr"];
                    }
                    if(location.coordinate.latitude){
                        [dict setObject: [NSString stringWithFormat:@"%.8f", location.coordinate.latitude] forKey:@"lat"];
                    }
                    if(location.coordinate.longitude){
                        [dict setObject:[NSString stringWithFormat:@"%.8f", location.coordinate.longitude] forKey:@"lng"];
                    }
                    if(regeocode.street){
                        [dict setObject:regeocode.street forKey:@"street"];
                    }
                    if(regeocode.number){
                        [dict setObject:regeocode.number forKey:@"streetNum"];
                    }
                    if(regeocode.POIName){
                        [dict setObject:regeocode.POIName forKey:@"poiName"];
                    }
                    if(regeocode.AOIName){
                        [dict setObject:regeocode.AOIName forKey:@"aoiName"];
                    }
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
                    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                }
            }
        }];
    }];
}


@end
