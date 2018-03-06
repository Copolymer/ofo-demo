//
//  ScanViewController.m
//  ofo-demo
//
//  Created by Comin Bril on 2018/3/6.
//  Copyright © 2018年 Comin Bril. All rights reserved.
//

#import "ScanViewController.h"

@interface ScanViewController()
@property (weak, nonatomic) IBOutlet UIView *panelView;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"扫码用车";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc] init];
    style.anmiationStyle = LBXScanViewAnimationStyle_NetGrid;
    style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_part_net"];
    self.style = style;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view bringSubviewToFront:_panelView];
}

//- (LBXScanViewStyle *)


@end
