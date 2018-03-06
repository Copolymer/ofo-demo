//
//  ViewController.m
//  Ofo-demo
//
//  Created by Comin Bril on 2017/6/30.
//  Copyright © 2017年 Comin Bril. All rights reserved.
//

#import "ViewController.h"
#import "MyPinAnnotation.h"
#import "ScanViewController.h"
#import <SWRevealViewController.h>
#import <FTIndicator.h>
#import <Masonry.h>

@interface ViewController ()
{
    MAMapView *_mapView;
    
    AMapSearchAPI *_search;
    MyPinAnnotation *_pin;
    MAAnnotationView *_pinView;
    
    BOOL _nearbySearch;
    
    CLLocationCoordinate2D _start,_end;
    AMapNaviWalkManager *_walkManager;
    
    UITapGestureRecognizer *_tapPress;
    UIView *_panelView;
}

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mapView = [[MAMapView alloc]initWithFrame:self.view.bounds];
    [self.view insertSubview:_mapView atIndex:0];
    _mapView.delegate = self;
    
    _mapView.zoomLevel = 17;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    [_mapView removeOverlays:_mapView.overlays];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"whiteImage"]];

    [_mapView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.height.equalTo(self.view.mas_height).multipliedBy(0.25);
    }];
    
    
    
    _tapPress = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction)];
//    _tapPress.minimumPressDuration = 0.5;
    _tapPress.enabled = NO;
    [_mapView addGestureRecognizer:_tapPress];
    
    _search = [[AMapSearchAPI alloc]init];
    _search.delegate = self;

    
    _walkManager = [[AMapNaviWalkManager alloc]init];
    _walkManager.delegate = self;
    
    [self.view bringSubviewToFront:_panelView];
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ofoLogo"]];
    self.navigationItem.leftBarButtonItem.image = [[UIImage imageNamed:@"leftTopImage"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem.image = [[UIImage imageNamed:@"rightTopImage"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    SWRevealViewController *revealVC = [[SWRevealViewController alloc]init];
    if (revealVC) {
        self.revealViewController.rearViewRevealWidth = 254;
        self.navigationItem.leftBarButtonItem.target = revealVC;
        self.navigationItem.leftBarButtonItem.action = @selector(revealToggle:);
        [self.view addGestureRecognizer:revealVC.panGestureRecognizer];
    }
}


#pragma mark -Button动作方法
- (IBAction)locationBtnTap:(id)sender {
//    [self searchBikeNearby];
    //    _pin.coordinate = _mapView.centerCoordinate;
    _mapView.centerCoordinate = _mapView.userLocation.coordinate;
    _pin.coordinate = _mapView.userLocation.coordinate;
    _pin.lockedScreenPoint = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    _pin.lockedToScreen = YES;
    _nearbySearch = YES;
    [self searchCustomLocation:_mapView.userLocation.coordinate];
    [_mapView addAnnotation:_pin];
    [_mapView showAnnotations:@[_pin] animated:YES];
}


- (IBAction)cancel:(id)sender {
    if (_mapView.overlays) {
        [_mapView removeOverlays:_mapView.overlays];
        _nearbySearch = YES;
        [self searchCustomLocation:_pin.coordinate];
        _pin.coordinate = _mapView.centerCoordinate;
        _pin.lockedScreenPoint = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
        _pin.lockedToScreen = YES;
    }
}

- (void)longPressAction {
    if (_mapView.overlays) {
        [_mapView removeOverlays:_mapView.overlays];
        _nearbySearch = YES;
        [self searchCustomLocation:_pin.coordinate];
        _pin.coordinate = _mapView.centerCoordinate;
        _pin.lockedScreenPoint = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
        _pin.lockedToScreen = YES;
        _tapPress.enabled = NO;
    }
}

#pragma mark -搜索周边的小黄车
- (void)searchBikeNearby {
    [self searchCustomLocation:_mapView.userLocation.coordinate];
}

- (void)searchCustomLocation : (CLLocationCoordinate2D)center{
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc]init];
    
    AMapGeoPoint *loc = [[AMapGeoPoint alloc]init];
    loc.latitude = (CGFloat)center.latitude;
    loc.longitude = (CGFloat)center.longitude;
    
    request.location = loc;
    request.keywords = @"餐馆";
    request.radius = 500;
    request.requireExtension = YES;
    
    [_search AMapPOIAroundSearch:request];
}



#pragma mark -大头针动画
- (void)pinAnimation {
    //坠落效果 y轴加位移
    CGRect endFrame = _pinView.frame;
    _pinView.frame = CGRectOffset(endFrame, 0, -15);
    
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _pinView.frame = endFrame;
    } completion:nil];
}


#pragma mark -MapView Delegate
//渲染Overlay
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
//        _mapView.visibleMapRect = overlay.boundingMapRect;
        MAMapRect rect = overlay.boundingMapRect;
        rect.origin.x -= 100;
        rect.origin.y -= 100;
        rect.size.height += 200;
        rect.size.width += 200;
        [UIView animateWithDuration:1.5 animations:^{
            _mapView.visibleMapRect = rect;
        }];
        
        
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth    = 8.f;
        polylineRenderer.strokeColor  = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.6];
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.lineCapType  = kMALineCapRound;
        
        return polylineRenderer;
    }
    return nil;
}

//当选中一个annotation view时，调用此接口
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    
    _start = _pin.coordinate;
    _end = view.annotation.coordinate;
    
    AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:(CGFloat)_start.latitude longitude:(CGFloat)_start.longitude];
    AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:(CGFloat)_end.latitude longitude:(CGFloat)_end.longitude];
    
    [_walkManager calculateWalkRouteWithStartPoints:@[startPoint] endPoints:@[endPoint]];
    
    _tapPress.enabled = YES;
}

//Annotation加载时的动画
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    for (MAAnnotationView *aView in views) {
        if([aView.annotation isKindOfClass:[MAPointAnnotation class]]) {
        } else {
            continue;
        }
        aView.transform = CGAffineTransformScale(aView.transform, 0, 0);
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            aView.transform = CGAffineTransformIdentity;
        } completion:nil];
//        if ([aView.annotation isKindOfClass:[MyPinAnnotation class]]) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [_mapView bringSubviewToFront:aView];
//            });
//        }
    }
}

//用户移动地图的交互
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
    if (wasUserAction && !_mapView.overlays.count) {
        for (id <MAAnnotation>annotation in _mapView.annotations) {
            if (![annotation isKindOfClass:[MyPinAnnotation class]]) {
                [_mapView removeAnnotation:annotation];
            }
        }
        _pin.lockedToScreen = YES;
        [self pinAnimation];
        [self searchCustomLocation:_mapView.centerCoordinate];
//        [_mapView removeOverlays:_mapView.overlays];
    }
}

//地图初始化完成之后
- (void)mapInitComplete:(MAMapView *)mapView {
    _pin = [[MyPinAnnotation alloc]init];
//    _pin.coordinate = _mapView.centerCoordinate;
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = _mapView.userLocation.coordinate.latitude + 10;
    coordinate.longitude = _mapView.userLocation.coordinate.longitude;
    _pin.coordinate = coordinate;
    _pin.lockedScreenPoint = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    _pin.lockedToScreen = YES;
    _nearbySearch = YES;
    [self searchCustomLocation:_mapView.centerCoordinate];
    [_mapView addAnnotation:_pin];
    [_mapView showAnnotations:@[_pin] animated:YES];
}

//自定义大头针视图
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    //用户定义的位置，不需要自定义
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        return nil;
    }
    //小黄车视图
    if (![annotation isKindOfClass:[MyPinAnnotation class]]) {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        
        if ([annotation.title isEqualToString: @"正常可用"]) {
            annotationView.image = [UIImage imageNamed:@"HomePage_nearbyBikeRedPacket"];
        } else {
            annotationView.image = [UIImage imageNamed:@"HomePage_nearbyBike"];
        }
        
        annotationView.canShowCallout = YES;
        return annotationView;
    }
    
    //中心点视图
    static NSString *reuseid = @"anchor";
    MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseid];
    if (annotationView == nil) {
        annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                        reuseIdentifier:reuseid];
    }
    annotationView.image = [UIImage imageNamed:@"homePage_wholeAnchor"];
    annotationView.canShowCallout = NO;
        
    _pinView = annotationView;
    return annotationView;
}


// MARK: -Map Search Delegate
//搜索周边完成后的处理
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if(response.count == 0) {
        NSLog(@"周边没有小黄车");
        return;
    }
    
    NSMutableArray *annotations = [[NSMutableArray alloc]init];
    
    for(AMapPOI *poi in response.pois) {
        MAPointAnnotation *annotation = [[MAPointAnnotation alloc]init];
        annotation.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
        if(poi.distance < 400) {
            annotation.title = @"红包区域内开锁任意小黄车";
            annotation.subtitle = @"骑行10分钟可获得现金红包";
        }else {
            annotation.title = @"正常可用";
        }
        [annotations addObject:annotation];
    }
    [_mapView addAnnotations:annotations];
    
    if (_nearbySearch) {
    [_mapView showAnnotations:annotations animated:YES];
        _nearbySearch = !_nearbySearch;
    }
}

// MARK: -导航代理
- (void)walkManagerOnCalculateRouteSuccess:(AMapNaviWalkManager *)walkManager {
    
    [_mapView removeOverlays:_mapView.overlays];
    
    NSMutableArray *coordinates = [[NSMutableArray alloc]init];
    for (AMapNaviPoint *routeCoordinate in walkManager.naviRoute.routeCoordinates) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(routeCoordinate.latitude, routeCoordinate.longitude);
        //地理位置结构体的编码****
        [coordinates addObject:[NSValue valueWithBytes:&coordinate objCType:@encode(CLLocationCoordinate2D)]];
    }
    //实现结构体的解码
    //定义C语言数组
    CLLocationCoordinate2D coordinatesArr[coordinates.count];
    
    for (int i = 0; i < coordinates.count; i++) {
        [coordinates[i] getValue:&coordinatesArr[i]];
    }
    
    MAPolyline *ployline = [MAPolyline polylineWithCoordinates:coordinatesArr count:coordinates.count];
    [_mapView addOverlay:ployline];
    
    _pin.lockedToScreen = NO;
    
    //提示用距离和用时
    NSInteger walkTime = walkManager.naviRoute.routeTime;
    NSMutableString *timeDesc = [NSMutableString stringWithString:@"分钟以内"] ;
    if (walkTime > 0) {
        [timeDesc insertString:[NSString stringWithFormat:@"步行%lu",walkTime/60] atIndex:0];
    }
    
    NSMutableString *hintTitle = timeDesc;
    NSMutableString *hintSubtitle = [NSMutableString stringWithFormat:@"步行%lu米",walkManager.naviRoute.routeLength];

    [FTIndicator setIndicatorStyle:UIBlurEffectStyleRegular];
    [FTIndicator showNotificationWithImage:[UIImage imageNamed:@"clock"] title:hintTitle message:hintSubtitle];
    NSLog(@"规划路线成功");
 
}

@end
