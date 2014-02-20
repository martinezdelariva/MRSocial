//
//  MRSinaWeibo.m
//  MRSocial
//
//  Created by Jose Luis Martinez de la Riva on 18/02/14.
//  Copyright (c) 2014 Jose Luis Martinez de la Riva. All rights reserved.
//

#import "MRSinaWeibo.h"

@implementation MRSinaWeibo

- (NSString *)serviceType
{
    return SLServiceTypeSinaWeibo;
}

- (NSString *)accountTypeIdentifier
{
    return ACAccountTypeIdentifierSinaWeibo;
}

- (NSDictionary *)options
{
    return nil;
}

@end
