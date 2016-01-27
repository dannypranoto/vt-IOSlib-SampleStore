//
//  VTBaseTransaction.m
//  VTiOSAPI
//
//  Created by Muhammad Anis on 12/11/14.
//  Copyright (c) 2014 Veritrans Indonesia. All rights reserved.
//

#include "VTBaseTransaction.h"

@implementation VTBaseTransaction

@synthesize item_details = _item_details;

-(id)init{
    if(self = [super init]){
        _item_details = [[NSMutableArray alloc] init];
    }
    return self;
}

@end

