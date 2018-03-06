//
//  WebViewController.m
//  Ofo-demo
//
//  Created by Comin Bril on 2017/6/30.
//  Copyright © 2017年 Comin Bril. All rights reserved.
//

#import "WebViewController.h"
@import WebKit;
@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"热门活动";
    NSURL *url = [NSURL URLWithString:@"https://m.ofo.com/active.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [_webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
