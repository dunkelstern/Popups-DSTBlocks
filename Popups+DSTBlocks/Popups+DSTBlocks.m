//
//  Popups+DSTBlocks.m
//  Popups+Blocks
//
//  Created by Johannes Schriewer on 08.03.2013.
//  Copyright (c) 2013 Johannes Schriewer. All rights reserved.
//

#import "Popups+DSTBlocks.h"

@implementation DSTBlockButton

- (DSTBlockButton *)initWithTitle:(NSString *)title block:(DSTButtonPressBlock)block {
    self = [super init];
    if (self) {
        _title = title;
        _block = block;
    }
    return self;
}

+ (DSTBlockButton *)buttonWithTitle:(NSString *)title block:(DSTButtonPressBlock)block {
    return [[DSTBlockButton alloc] initWithTitle:title block:block];
}

@end