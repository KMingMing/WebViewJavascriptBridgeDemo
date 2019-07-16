//
//  ViewController.m
//  WebViewJavascriptBridgeDemo
//
//  Created by 孔志林 on 2019/7/16.
//  Copyright © 2019年 KMingMing. All rights reserved.
//

#import "ViewController.h"
#import "WebViewJavascriptBridge.h"
@interface ViewController ()

@property (nonatomic, strong) WebViewJavascriptBridge *bridge;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"客户端调用JS方法：testJavascriptHandler" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    btn.backgroundColor = [UIColor redColor];
    [btn sizeToFit];
    btn.center = self.view.center;
    [btn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    [webView addSubview:btn];
    
    [WebViewJavascriptBridge enableLogging]; //开启日志打印
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:webView]; //绑定webView
    [self.bridge setWebViewDelegate:self]; //设置webView代理
    
    
    /**
     客户端注册方法给JS调用
     */
    [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"JS传来的数据: %@", data);
        responseCallback(@{ @"foo":@"我是客户端来的数据😆" });
    }];
    
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"test.html" ofType:@""];
    NSURL *url = [NSURL fileURLWithPath:htmlPath];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
}
- (void)tapAction:(UIButton *)sender {
    /**
     客户端调用JS注册的方法: testJavascriptHandler
     */
    [_bridge callHandler:@"testJavascriptHandler" data:@{ @"foo":@"before ready" }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
