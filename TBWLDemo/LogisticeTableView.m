//
//  LogisticeTableView.m
//  TBWLDemo
//
//  Created by 张鹏 on 2018/5/28.
//  Copyright © 2018年 c4ibD3. All rights reserved.
//

#import "LogisticeTableView.h"

@implementation LogisticeTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    id hitView = [super hitTest:point withEvent:event];
    if (point.y<0) {
        return nil;
    }
    return hitView;
}

@end
