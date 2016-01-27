//
//  VTTransactionDetails.m
//  VTiOSAPI
//
//  Created by Muhammad Anis on 12/11/14.
//  Copyright (c) 2014 Veritrans Indonesia. All rights reserved.
//

#import "VTTransactionDetails.h"

@implementation VTTransactionDetails

@synthesize order_id = _order_id;
@synthesize gross_amount = _gross_amount;


/**
Create a new VTTransactionDetails with specified orderId and grossAmoung
 @param orderId id of ordered item
 @param grossAmount total price of items
 */
-(id)initWithOrderAndGross:(NSString *)orderId withGrossAmount:(NSInteger)grossAmount{
    if(self = [super init]){
        _order_id = orderId;
        _gross_amount = grossAmount;
    }
    return self;
}

+(instancetype)transactionWithOrderAndGross:(NSString *)orderId withGrossAmount:(NSInteger)grossAmount{
    return [[self alloc] initWithOrderAndGross:orderId withGrossAmount:grossAmount];
    
}

@end
