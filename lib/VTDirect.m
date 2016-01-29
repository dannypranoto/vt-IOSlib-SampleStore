//
//  VTDirect.m
//  VTiOSAPI
//
//  Created by Muhammad Anis on 12/11/14.
//  Copyright (c) 2014 Veritrans Indonesia. All rights reserved.
//



#import "VTDirect.h"
#import "VTConfig.h"

@implementation VTDirect

@synthesize card_details = _card_details;

-(void)preAuthorize{
    [NSException raise:UnsupportedMethodException format:@"Method Not Implemented Yet"];
}

-(void)capture{
    [NSException raise:UnsupportedMethodException format:@"Method Not Implemented Yet"];
}

-(void)charge{
    [NSException raise:UnsupportedMethodException format:@"Method Not Implemented Yet"];
}

-(void)getToken:(void (^)(NSData *, NSException *))completionHandler{
    NSString* urlString = [NSString stringWithFormat:@"%@%@",[VTConfig getTokenUrl],[_card_details getParamUrl:_card_details.two_click]];

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(data.length > 0 && connectionError == nil){
            NSLog(@"Data: %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSError * error;
            if(error == nil){
                completionHandler(data,nil);
            }else{
                NSException* exception = [[NSException alloc] initWithName:@"JsonParsedException" reason:error.localizedDescription userInfo:error.userInfo];
                completionHandler(nil,exception);
            }
            
        }else{
            NSException* exception = [[NSException alloc] initWithName:@"ConnectionException" reason:connectionError.localizedDescription userInfo:connectionError.userInfo];
            NSLog(@"Exception: %@",connectionError.localizedDescription);
            completionHandler(nil,exception);
            
        }
    }];
}

-(void)registerCard:(void (^)(NSData *, NSException *))completionHandler{
    NSString* urlString = [NSString stringWithFormat:@"%@%@",[VTConfig getRegisterCardUrl],[_card_details getParamUrl:false]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(data.length > 0 && connectionError == nil){
            NSLog(@"Data: %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSError * error;
            if(error == nil){
                completionHandler(data,nil);
            }else{
                NSException* exception = [[NSException alloc] initWithName:@"JsonParsedException" reason:error.localizedDescription userInfo:error.userInfo];
                completionHandler(nil,exception);
            }
            
        }else{
            NSException* exception = [[NSException alloc] initWithName:@"ConnectionException" reason:connectionError.localizedDescription userInfo:connectionError.userInfo];
            NSLog(@"Exception: %@",connectionError.localizedDescription);
            completionHandler(nil,exception);
            
        }
    }];
}

@end
