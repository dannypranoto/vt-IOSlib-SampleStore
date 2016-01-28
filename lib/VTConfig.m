//
//  VTConfig.m
//  VTiOSAPI
//
//  Created by Muhammad Anis on 12/11/14.
//  Copyright (c) 2014 Veritrans Indonesia. All rights reserved.
//

#import "VTConfig.h"

@implementation VTConfig

static NSString* _clientKey;
static BOOL _isProduction;

+(NSString*) CLIENT_KEY{
    return _clientKey;
}

+(void)setCLIENT_KEY:(NSString*)val{
    _clientKey = val;
}

+(BOOL)VT_IsProduction{
    return _isProduction;
}

+(void)setVT_IsProduction:(BOOL)val{
    _isProduction = val;
}

+(NSString*) getTokenUrl{
    if(_isProduction){
        return @"https://api.veritrans.co.id/v2/token";
    }
    return @"https://api.sandbox.veritrans.co.id/v2/token";
}

+(NSString*) getRegisterCardUrl{
    if(_isProduction){
        return @"https://api.veritrans.co.id/v2/card/register";
    }
    return @"https://api.sandbox.veritrans.co.id/v2/card/register";
}


@end




