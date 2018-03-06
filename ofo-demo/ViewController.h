//
//  ViewController.h
//  Ofo-demo
//
//  Created by Comin Bril on 2017/6/30.
//  Copyright © 2017年 Comin Bril. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMap3DMap/MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
@interface ViewController : UIViewController<MAMapViewDelegate,AMapSearchDelegate,AMapNaviWalkManagerDelegate>


@end

