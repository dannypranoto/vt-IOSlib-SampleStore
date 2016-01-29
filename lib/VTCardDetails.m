//
//  VTCardDetails.m
//  VTiOSAPI
//
//  Created by Muhammad Anis on 12/11/14.
//  Copyright (c) 2014 Veritrans Indonesia. All rights reserved.
//

#import "VTCardDetails.h"

#import "VTConfig.h"

@implementation VTCardDetails

@synthesize card_number=_card_number;
@synthesize card_cvv = _card_cvv;
@synthesize bank = _bank;
@synthesize gross_amount = _gross_amount;

@synthesize card_exp_month = _card_exp_month;
@synthesize card_exp_year = _card_exp_year;

@synthesize token_id = _token_id;
@synthesize two_click = _two_click;

@synthesize secure = _secure;

-(NSString*) getParamUrl:(BOOL)isTwoClick {
    if (isTwoClick) {
        return [NSString stringWithFormat:@"?token_id=%@&two_click=%@&card_cvv=%@&client_key=%@&secure=%@%@&gross_amount=%@",_token_id,_two_click ? @"true" : @"false",_card_cvv,VTConfig.CLIENT_KEY,_secure ? @"true" : @"false",[self getBankParam],_gross_amount];
    } else {
        return [NSString stringWithFormat:@"?card_number=%@&card_exp_month=%@&card_exp_year=%d&card_cvv=%@&client_key=%@&secure=%@%@&gross_amount=%@",_card_number,_card_exp_month,_card_exp_year,_card_cvv,VTConfig.CLIENT_KEY,_secure ? @"true" : @"false",[self getBankParam],_gross_amount];
    }
}

-(NSString*) getBankParam{
    if(_bank != nil){
        return [NSString stringWithFormat:@"&bank=%@",_bank];
    }
    return @"";
}

@end