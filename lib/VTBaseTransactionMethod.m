//
//  VTBaseTransactionMethod.m
//  VTiOSAPI
//
//  Created by Muhammad Anis on 12/10/14.
//  Copyright (c) 2014 Veritrans Indonesia. All rights reserved.
//


#import "VTBaseTransactionMethod.h"

@implementation VTBaseTransactionMethod

@synthesize transaction;

-(void)preAuthorize{
    [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

-(void)capture{
    [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

-(void)charge{
    [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

-(void)getToken:(void (^)(NSData *, NSException *))completionHandler{
    [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

-(void)registerCard:(void (^)(NSData *, NSException *))completionHandler{
    [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

@end

