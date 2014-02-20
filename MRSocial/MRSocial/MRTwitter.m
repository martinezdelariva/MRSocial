//
//  MRTwitter.m
//  MRSocial
//
//  Created by Jose Luis Martinez de la Riva on 18/02/14.
//  Copyright (c) 2014 Jose Luis Martinez de la Riva. All rights reserved.
//


#import "MRTwitter.h"

@implementation MRTwitter

- (NSString *)serviceType
{
    return SLServiceTypeTwitter;
}

- (NSString *)accountTypeIdentifier
{
    return ACAccountTypeIdentifierTwitter;
}

- (NSDictionary *)options
{
    return nil;
}

@end
