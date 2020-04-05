//
//  EmptyObject.m
//  ofo-demo
//
//  Created by Aesthetic on 2020/4/3.
//  Copyright © 2020 Comin Bril. All rights reserved.
//

#import "EmptyObject.h"

@implementation EmptyObject
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"init");
    }
    return self;
}
@end
