//
//  DBCBridgedTests.m
//  cabolib-ios
//
//  Created by Jim Boyd on 11/20/14.
//  Copyright (c) 2014 Cabosoft, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DBCIntensityLevel.h"
@import DBC;

#ifdef PACKAGE_MANAGER
@import DBC_bridged;
#endif

@interface DBCBridgedTests : XCTestCase

@end


@implementation DBCBridgedTests

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
	[DBCBridge setIntensityLevel:0];
}

- (void)tearDown
{
	[super tearDown];
}

- (void)testBridgedIntensity
{
	XCTAssertTrue([DBCBridge intensityLevel] == 0);
	XCTAssertTrue(DBC_DebugIntensityLevel() == 0);
	
	[DBCBridge setIntensityLevel:5];
	XCTAssertTrue([DBCBridge intensityLevel] == 5);
	XCTAssertTrue(DBC_DebugIntensityLevel() == 5);
	
	[DBCBridge setIntensityLevel:10];
	XCTAssertTrue([DBCBridge intensityLevel] == 10);
	XCTAssertTrue(DBC_DebugIntensityLevel() == 10);
	
	[DBCBridge setIntensityLevel:0];
	XCTAssertTrue([DBCBridge intensityLevel] == 0);
	XCTAssertTrue(DBC_DebugIntensityLevel() == 0);
}

- (void)testDBCIntense
{
	if ([self skipWhenAssertionsAreDisabled]) { return; }
	NSInteger wasIntensity = [DBCBridge intensityLevel];
	[DBCBridge setIntensityLevel:10];

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

	[DBCBridge setIntensityLevel:wasIntensity];
}

- (void)testDBCIntenseMessage
{
	if ([self skipWhenAssertionsAreDisabled]) { return; }
	NSInteger wasIntensity = [DBCBridge intensityLevel];
	[DBCBridge setIntensityLevel:10];

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

	[DBCBridge setIntensityLevel:wasIntensity];
}

-(void) testPerfomIntenseBlock
{
	NSInteger wasIntensity = [DBCBridge intensityLevel];
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
	
	[DBCBridge setIntensityLevel:10];
	XCTAssertTrue([DBCBridge intensityLevel] == 10);
	
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

	[DBCBridge setIntensityLevel:wasIntensity];
	XCTAssertTrue([DBCBridge intensityLevel] == 0);
}

@end
