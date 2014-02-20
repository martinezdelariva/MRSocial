//
//  MRFacebook.h
//  MRSocial
//
//  Created by Jose Luis Martinez de la Riva on 18/02/14.
//  Copyright (c) 2014 Jose Luis Martinez de la Riva. All rights reserved.
//
//  @see https://developers.facebook.com/docs/facebook-login/permissions/

#import "MRSocialAbstract.h"

@interface MRFacebook : MRSocialAbstract
@property(strong, nonatomic) NSDictionary *configuration;
@end
