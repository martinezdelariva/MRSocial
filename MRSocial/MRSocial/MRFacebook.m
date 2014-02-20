//
//  MRFacebook.m
//  MRSocial
//
//  Created by Jose Luis Martinez de la Riva on 18/02/14.
//  Copyright (c) 2014 Jose Luis Martinez de la Riva. All rights reserved.
//

#import "MRFacebook.h"

@implementation MRFacebook

- (NSString *)serviceType
{
    return SLServiceTypeFacebook;
}

- (NSString *)accountTypeIdentifier
{
    return ACAccountTypeIdentifierFacebook;
}

- (NSDictionary *)options
{
    return self.configuration;
}

@end
