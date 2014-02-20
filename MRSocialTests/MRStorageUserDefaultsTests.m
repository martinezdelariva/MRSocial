//
//  MRStorageUserDefaultsTests.m
//  MRSocial
//
//  Created by Jose Luis Martinez de la Riva on 20/02/14.
//  Copyright (c) 2014 Jose Luis Martinez de la Riva. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MRStorageUserDefaults.h"

@interface MRStorageUserDefaultsTests : XCTestCase
@property(strong, nonatomic) MRStorageUserDefaults *storage;
@end

@implementation MRStorageUserDefaultsTests

- (void)setUp
{
    [super setUp];
    
    self.storage = [[MRStorageUserDefaults alloc] init];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testRetrieveWithNilKeyShouldReturnNil
{
    NSString *result = [self.storage retrieveACAccountIdentifierForKey:nil];
    XCTAssertNil(result, @"");
}

@end
