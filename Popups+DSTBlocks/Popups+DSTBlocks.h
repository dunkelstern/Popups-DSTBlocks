//
//  DSTPopups+Blocks.h
//  Popups+Blocks
//
//  Created by Johannes Schriewer on 08.03.2013.
//  Copyright (c) 2013 Johannes Schriewer. All rights reserved.
//

typedef void (^DSTButtonPressBlock)();
typedef void (^DSTCancelButtonBlock)();
typedef void (^DSTPopupPresentedBlock)();
typedef void (^DSTWillPresentPopupBlock)();

@interface DSTBlockButton : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) DSTButtonPressBlock block;

- (DSTBlockButton *)initWithTitle:(NSString *)title block:(DSTButtonPressBlock)block;
+ (DSTBlockButton *)buttonWithTitle:(NSString *)title block:(DSTButtonPressBlock)block;

@end

#import "UIAlertView+DSTBlocks.h"
