//
//  MRSocialStorageProtocol.h
//  MRSocial
//
//  Created by Jose Luis Martinez de la Riva on 20/02/14.
//  Copyright (c) 2014 Jose Luis Martinez de la Riva. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MRSocialStorageProtocol <NSObject>
- (void)storeACAccountIdentifier:(NSString *)identifier forKey:(NSString *)key;
- (NSString *)retrieveACAccountIdentifierForKey:(NSString *)key;
- (void)deleteACAccountIdentifierForKey:(NSString *)key;
@end
