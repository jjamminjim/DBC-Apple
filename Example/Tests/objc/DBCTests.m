//
//  DBCTests.m
//  cabolib-ios
//
//  Created by Jim Boyd on 11/20/14.
//  Copyright (c) 2014 Cabosoft, LLC. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DBC.h"
#import "DBCIntensityLevel.h"

//#if TARGET_OS_IOS
//#import "BSYDDLogger.h"
//#endif


@interface DBCTests : XCTestCase

@end


@implementation DBCTests

- (BOOL)skipWhenAssertionsAreDisabled
{
#ifndef DEBUG
	return YES;
#else
	return NO;
#endif
}

- (void)setUp
{
    [super setUp];
	DBC_SetDebugIntensityLevel(0);

//#if TARGET_OS_IOS
//	(void) BSYDDLogger.sharedLogger;
//#endif
}

- (void)tearDown
{
//#if TARGET_OS_IOS
//	[BSYDDLogger clearSharedLogger];
//#endif

	[super tearDown];
}

- (void)testDBC
{
	if ([self skipWhenAssertionsAreDisabled]) { return; }
    // This is an example of a functional test case.
	XCTAssertNoThrow(REQUIRE(true));
	XCTAssertNoThrow(CHECK(true));
	XCTAssertNoThrow(ENSURE(true));

	XCTAssertThrows(REQUIRE(false));
	XCTAssertThrows(CHECK(false));
	XCTAssertThrows(ENSURE(false));

	XCTAssertNoThrow(REQUIRE(2 == 2));
	XCTAssertNoThrow(CHECK(2 == 2));
	XCTAssertNoThrow(ENSURE(2 == 2));

	XCTAssertThrows(REQUIRE(1 == 2));
	XCTAssertThrows(CHECK(1 == 2));
	XCTAssertThrows(ENSURE(1 == 2));

	NSString* testStr = @"Test";
	XCTAssertNoThrow(REQUIRE(testStr));
	XCTAssertNoThrow(CHECK(testStr));
	XCTAssertNoThrow(ENSURE(testStr));

	XCTAssertThrows(REQUIRE(!testStr));
	XCTAssertThrows(CHECK(!testStr));
	XCTAssertThrows(ENSURE(!testStr));

	XCTAssertNoThrow(REQUIRE(testStr != nil));
	XCTAssertNoThrow(CHECK(testStr != nil));
	XCTAssertNoThrow(ENSURE(testStr != nil));

	NSString* nilStr = nil;
	XCTAssertThrows(REQUIRE(nilStr));
	XCTAssertThrows(CHECK(nilStr));
	XCTAssertThrows(ENSURE(nilStr));

	XCTAssertNoThrow(REQUIRE(!nilStr));
	XCTAssertNoThrow(CHECK(!nilStr));
	XCTAssertNoThrow(ENSURE(!nilStr));

	XCTAssertThrows(REQUIRE(nilStr != nil));
	XCTAssertThrows(CHECK(nilStr != nil));
	XCTAssertThrows(ENSURE(nilStr != nil));
}

- (void)testDBCMessage
{
	if ([self skipWhenAssertionsAreDisabled]) { return; }
	// This is an example of a functional test case.
	XCTAssertNoThrow(REQUIRE_MSG(true, @"Test Message"));
	XCTAssertNoThrow(CHECK_MSG(true, @"Test Message"));
	XCTAssertNoThrow(ENSURE_MSG(true, @"Test Message"));

	XCTAssertThrows(REQUIRE_MSG(false, @"Test Message"));
	XCTAssertThrows(CHECK_MSG(false, @"Test Message"));
	XCTAssertThrows(ENSURE_MSG(false, @"Test Message"));

	XCTAssertNoThrow(REQUIRE_MSG(2 == 2, @"Test Message"));
	XCTAssertNoThrow(CHECK_MSG(2 == 2, @"Test Message"));
	XCTAssertNoThrow(ENSURE_MSG(2 == 2, @"Test Message"));

	XCTAssertThrows(REQUIRE_MSG(1 == 2, @"Test Message"));
	XCTAssertThrows(CHECK_MSG(1 == 2, @"Test Message"));
	XCTAssertThrows(ENSURE_MSG(1 == 2, @"Test Message"));

	NSString* testStr = @"Test";
	XCTAssertNoThrow(REQUIRE_MSG(testStr, @"Test Message"));
	XCTAssertNoThrow(CHECK_MSG(testStr, @"Test Message"));
	XCTAssertNoThrow(ENSURE_MSG(testStr, @"Test Message"));

	XCTAssertThrows(REQUIRE_MSG(!testStr, @"Test Message"));
	XCTAssertThrows(CHECK_MSG(!testStr, @"Test Message"));
	XCTAssertThrows(ENSURE_MSG(!testStr, @"Test Message"));

	XCTAssertNoThrow(REQUIRE_MSG(testStr != nil, @"Test Message"));
	XCTAssertNoThrow(CHECK_MSG(testStr != nil, @"Test Message"));
	XCTAssertNoThrow(ENSURE_MSG(testStr != nil, @"Test Message"));

	NSString* nilStr = nil;
	XCTAssertThrows(REQUIRE_MSG(nilStr, @"Test Message"));
	XCTAssertThrows(CHECK_MSG(nilStr, @"Test Message"));
	XCTAssertThrows(ENSURE_MSG(nilStr, @"Test Message"));

	XCTAssertNoThrow(REQUIRE_MSG(!nilStr, @"Test Message"));
	XCTAssertNoThrow(CHECK_MSG(!nilStr, @"Test Message"));
	XCTAssertNoThrow(ENSURE_MSG(!nilStr, @"Test Message"));

	XCTAssertThrows(REQUIRE_MSG(nilStr != nil, @"Test Message"));
	XCTAssertThrows(CHECK_MSG(nilStr != nil, @"Test Message"));
	XCTAssertThrows(ENSURE_MSG(nilStr != nil, @"Test Message"));
}

- (void)testDBCIntense
{
	if ([self skipWhenAssertionsAreDisabled]) { return; }
	NSInteger wasIntensity = DBC_DebugIntensityLevel();
	DBC_SetDebugIntensityLevel(10);

	// This is an example of a functional test case.
	XCTAssertNoThrow(INTENSE_REQUIRE(5, true));
	XCTAssertNoThrow(INTENSE_CHECK(5, true));
	XCTAssertNoThrow(INTENSE_ENSURE(5, true));

	XCTAssertThrows(INTENSE_REQUIRE(5, false));
	XCTAssertThrows(INTENSE_CHECK(5, false));
	XCTAssertThrows(INTENSE_ENSURE(5, false));

	XCTAssertNoThrow(INTENSE_REQUIRE(15, false));
	XCTAssertNoThrow(INTENSE_CHECK(15, false));
	XCTAssertNoThrow(INTENSE_ENSURE(15, false));

	XCTAssertNoThrow(INTENSE_REQUIRE(5, 2 == 2));
	XCTAssertNoThrow(INTENSE_CHECK(5, 2 == 2));
	XCTAssertNoThrow(INTENSE_ENSURE(5, 2 == 2));

	XCTAssertThrows(INTENSE_REQUIRE(5, 1 == 2));
	XCTAssertThrows(INTENSE_CHECK(5, 1 == 2));
	XCTAssertThrows(INTENSE_ENSURE(5, 1 == 2));

	XCTAssertNoThrow(INTENSE_REQUIRE(15, 1 == 2));
	XCTAssertNoThrow(INTENSE_CHECK(15, 1 == 2));
	XCTAssertNoThrow(INTENSE_ENSURE(15, 1 == 2));

	NSString* testStr = @"Test";
	XCTAssertNoThrow(INTENSE_REQUIRE(5, testStr));
	XCTAssertNoThrow(INTENSE_CHECK(5, testStr));
	XCTAssertNoThrow(INTENSE_ENSURE(5, testStr));

	XCTAssertNoThrow(INTENSE_REQUIRE(5, testStr != nil));
	XCTAssertNoThrow(INTENSE_CHECK(5, testStr != nil));
	XCTAssertNoThrow(INTENSE_ENSURE(5, testStr != nil));

	NSString* nilStr = nil;
	XCTAssertThrows(INTENSE_REQUIRE(5, nilStr));
	XCTAssertThrows(INTENSE_CHECK(5, nilStr));
	XCTAssertThrows(INTENSE_ENSURE(5, nilStr));

	XCTAssertThrows(INTENSE_REQUIRE(5, nilStr != nil));
	XCTAssertThrows(INTENSE_CHECK(5, nilStr != nil));
	XCTAssertThrows(INTENSE_ENSURE(5, nilStr != nil));

	XCTAssertNoThrow(INTENSE_REQUIRE(15, nilStr));
	XCTAssertNoThrow(INTENSE_CHECK(15, nilStr));
	XCTAssertNoThrow(INTENSE_ENSURE(15, nilStr));

	XCTAssertNoThrow(INTENSE_REQUIRE(15, nilStr != nil));
	XCTAssertNoThrow(INTENSE_CHECK(15, nilStr != nil));
	XCTAssertNoThrow(INTENSE_ENSURE(15, nilStr != nil));

	DBC_SetDebugIntensityLevel(wasIntensity);
}

- (void)testDBCIntenseMessage
{
	if ([self skipWhenAssertionsAreDisabled]) { return; }
	NSInteger wasIntensity = DBC_DebugIntensityLevel();
	DBC_SetDebugIntensityLevel(10);

	// This is an example of a functional test case.
	XCTAssertNoThrow(INTENSE_REQUIRE_MSG(5, true, @"Test Message"));
	XCTAssertNoThrow(INTENSE_CHECK_MSG(5, true, @"Test Message"));
	XCTAssertNoThrow(INTENSE_ENSURE_MSG(5, true, @"Test Message"));

	XCTAssertThrows(INTENSE_REQUIRE_MSG(5, false, @"Test Message"));
	XCTAssertThrows(INTENSE_CHECK_MSG(5, false, @"Test Message"));
	XCTAssertThrows(INTENSE_ENSURE_MSG(5, false, @"Test Message"));

	XCTAssertNoThrow(INTENSE_REQUIRE_MSG(15, false, @"Test Message"));
	XCTAssertNoThrow(INTENSE_CHECK_MSG(15, false, @"Test Message"));
	XCTAssertNoThrow(INTENSE_ENSURE_MSG(15, false, @"Test Message"));

	XCTAssertNoThrow(INTENSE_REQUIRE_MSG(5, 2 == 2, @"Test Message"));
	XCTAssertNoThrow(INTENSE_CHECK_MSG(5, 2 == 2, @"Test Message"));
	XCTAssertNoThrow(INTENSE_ENSURE_MSG(5, 2 == 2, @"Test Message"));

	XCTAssertThrows(INTENSE_REQUIRE_MSG(5, 1 == 2, @"Test Message"));
	XCTAssertThrows(INTENSE_CHECK_MSG(5, 1 == 2, @"Test Message"));
	XCTAssertThrows(INTENSE_ENSURE_MSG(5, 1 == 2, @"Test Message"));

	XCTAssertNoThrow(INTENSE_REQUIRE_MSG(15, 1 == 2, @"Test Message"));
	XCTAssertNoThrow(INTENSE_CHECK_MSG(15, 1 == 2, @"Test Message"));
	XCTAssertNoThrow(INTENSE_ENSURE_MSG(15, 1 == 2, @"Test Message"));

	NSString* testStr = @"Test";
	XCTAssertNoThrow(INTENSE_REQUIRE_MSG(5, testStr, @"Test Message"));
	XCTAssertNoThrow(INTENSE_CHECK_MSG(5, testStr, @"Test Message"));
	XCTAssertNoThrow(INTENSE_ENSURE_MSG(5, testStr, @"Test Message"));

	XCTAssertNoThrow(INTENSE_REQUIRE_MSG(5, testStr != nil, @"Test Message"));
	XCTAssertNoThrow(INTENSE_CHECK_MSG(5, testStr != nil, @"Test Message"));
	XCTAssertNoThrow(INTENSE_ENSURE_MSG(5, testStr != nil, @"Test Message"));

	NSString* nilStr = nil;
	XCTAssertThrows(INTENSE_REQUIRE_MSG(5, nilStr, @"Test Message"));
	XCTAssertThrows(INTENSE_CHECK_MSG(5, nilStr, @"Test Message"));
	XCTAssertThrows(INTENSE_ENSURE_MSG(5, nilStr, @"Test Message"));

	XCTAssertThrows(INTENSE_REQUIRE_MSG(5, nilStr != nil, @"Test Message"));
	XCTAssertThrows(INTENSE_CHECK_MSG(5, nilStr != nil, @"Test Message"));
	XCTAssertThrows(INTENSE_ENSURE_MSG(5, nilStr != nil, @"Test Message"));

	XCTAssertNoThrow(INTENSE_REQUIRE_MSG(15, nilStr, @"Test Message"));
	XCTAssertNoThrow(INTENSE_CHECK_MSG(15, nilStr, @"Test Message"));
	XCTAssertNoThrow(INTENSE_ENSURE_MSG(15, nilStr, @"Test Message"));

	XCTAssertNoThrow(INTENSE_REQUIRE_MSG(15, nilStr != nil, @"Test Message"));
	XCTAssertNoThrow(INTENSE_CHECK_MSG(15, nilStr != nil, @"Test Message"));
	XCTAssertNoThrow(INTENSE_ENSURE_MSG(15, nilStr != nil, @"Test Message"));

	DBC_SetDebugIntensityLevel(wasIntensity);
}

-(void) testPerfomIntenseBlock
{
	NSInteger wasIntensity = DBC_DebugIntensityLevel();
	XCTAssertTrue(wasIntensity == 0);

	__block BOOL intsity0 = NO;
	__block BOOL intsity10 = NO;
	
	DBC_performIfDBCIntensity(0,
	^{
		intsity0 = YES;
	});
	
	DBC_performIfDBCIntensity(10,
	^{
	   intsity10 = YES;
	});
	
	XCTAssertTrue(intsity0);
	XCTAssertFalse(intsity10);
	
	DBC_SetDebugIntensityLevel(10);
	XCTAssertTrue(DBC_DebugIntensityLevel() == 10);
	
	intsity0 = NO;
	intsity10 = NO;
	
	DBC_performIfDBCIntensity(0,
	^{
	   intsity0 = YES;
	});
	
	DBC_performIfDBCIntensity(10,
	^{
		intsity10 = YES;
	});
	
	XCTAssertTrue(intsity0);
	XCTAssertTrue(intsity10);

	DBC_SetDebugIntensityLevel(wasIntensity);
	XCTAssertTrue(DBC_DebugIntensityLevel() == 0);
}

@end
