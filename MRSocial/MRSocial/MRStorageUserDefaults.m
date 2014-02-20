//
//  MRACAccountStorage.m
//  MRSocial
//
//  Created by Jose Luis Martinez de la Riva on 20/02/14.
//  Copyright (c) 2014 Jose Luis Martinez de la Riva. All rights reserved.
//

#import "MRStorageUserDefaults.h"


@implementation MRStorageUserDefaults

- (void)storeACAccountIdentifier:(NSString *)identifier forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:identifier forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)retrieveACAccountIdentifierForKey:(NSString *)key;
{
    if (!key) {
        return nil;
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (void)deleteACAccountIdentifierForKey:(NSString *)key;
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
