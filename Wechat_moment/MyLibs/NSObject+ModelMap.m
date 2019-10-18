//
//  NSObject+ModelMap.m
//  wechat_moment
//
//  Created by wayneLIN on 2019/10/18.
//  Copyright © 2019 Guiwei LIN. All rights reserved.
//

#import "NSObject+ModelMap.h"
#import <objc/runtime.h>

@implementation NSObject (ModelMap)

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [self init]) {
        NSMutableArray * keys = [NSMutableArray array];
        NSMutableArray * attributes = [NSMutableArray array];
        unsigned int outCount;
        objc_property_t * properties = class_copyPropertyList([self class], &outCount);
        for (int i = 0; i < outCount; i ++) {
            objc_property_t property = properties[i];
            NSString * propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            [keys addObject:propertyName];
            NSString * propertyAttribute = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
            [attributes addObject:propertyAttribute];
        }
        free(properties);
        
        for (NSString * key in keys) {
            //variable name contains '-' is not good.
            NSString *tmp_key =[key stringByReplacingOccurrencesOfString:@"_" withString:@"-"];
            if ([dict valueForKey:tmp_key] == nil) continue;
            [self setValue:[dict valueForKey:tmp_key] forKey:key];
        }
    }
    return self;
}

@end
