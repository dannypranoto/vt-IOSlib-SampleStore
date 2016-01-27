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

-(void)getToken:(void (^)(VTToken *, NSException *))completionHandler{

    NSString* urlString = [NSString stringWithFormat:@"%@%@",[VTConfig getTokenUrl],[_card_details getParamUrl]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(data.length > 0 && connectionError == nil){
            NSLog(@"Data: %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSError * error;
            NSDictionary* jsonParsed = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if(error == nil){
                VTToken* token = [[VTToken alloc]init];
                token.token_id = [jsonParsed objectForKey:@"token_id"];
                token.status_code = [jsonParsed objectForKey:@"status_code"];
                token.status_message = [jsonParsed objectForKey:@"status_message"];
                token.redirect_url = [jsonParsed objectForKey:@"redirect_url"];
                
                token.bank = [jsonParsed objectForKey:@"bank"];
                completionHandler(token,nil);
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
