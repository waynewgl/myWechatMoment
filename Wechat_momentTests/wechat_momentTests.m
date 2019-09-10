//
//  wechat_momentTests.m
//  wechat_momentTests
//
//  Created by Guiwei LIN on 2019/9/8.
//  Copyright © 2019 Guiwei LIN. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WaUser.h"

@interface wechat_momentTests : XCTestCase {
    WaUser *user;
}

@end

@implementation wechat_momentTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [self testModelMappingSpeed];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        [self testModelMappingSpeed];
    }];
}

- (void)testModelMappingSpeed {
    NSDictionary *dic_user = @{
                               @"username":@"test",
                               @"nick":@"test123",
                               @"avatar":@"http://www.test.com/avatar",
                               @"profile-image":@"http://www.test.com/profile"
                               };
    user = [[WaUser alloc] initWithDict:dic_user];
}

- (void)testNetworkPeformance {
    //TODO: test afnetworking request performance.
}

@end
