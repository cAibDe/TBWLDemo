//
//  AppDelegate.h
//  TBWLDemo
//
//  Created by 张鹏 on 2018/5/28.
//  Copyright © 2018年 c4ibD3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>{
    BMKMapManager *_mapManager;
}

@property (strong, nonatomic) UIWindow *window;


@end

