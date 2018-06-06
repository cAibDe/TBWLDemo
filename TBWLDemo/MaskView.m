//
//  MaskView.m
//  TBWLDemo
//
//  Created by 张鹏 on 2018/5/28.
//  Copyright © 2018年 c4ibD3. All rights reserved.
//

#import "MaskView.h"

@implementation MaskView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return nil;
}

@end
