//
//  ViewController.m
//  JSContext
//
//  Created by 韩潇雨 on 2017/3/22.
//  Copyright © 2017年 sinbahan. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface ViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property(nonatomic,strong)JSContext * context;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSURL* htmlURL = [[NSBundle mainBundle] URLForResource: @"demo"
                                             withExtension: @"html"];
    
    [_webView loadRequest: [NSURLRequest requestWithURL: htmlURL]];
}
- (IBAction)callJS:(id)sender {
    [_context evaluateScript:@"showAlert()"];
}
- (IBAction)callJSWithArguments:(id)sender {
    
    [_context evaluateScript:@"showAlertWithString('OC call JS with arguments')"];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    _context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    __weak typeof(self) weakSelf = self;
    _context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        weakSelf.context.exception = exception;
    };
    
    //js调用OC
    _context[@"callOC"] = ^() {
        NSArray *args = [JSContext currentArguments];
        for (JSValue *jsVal in args) {
            NSLog(@"%@", jsVal.toString);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"arguments" message:@"JS Call OC With No Argument" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertView addAction:action];
            [weakSelf presentViewController:alertView animated:YES completion:nil];
        });
    };
    
    _context[@"jsCallOCWithArgument"] = ^() {
        NSArray *args = [JSContext currentArguments];
        NSMutableString * stirng = [NSMutableString string];
        for (JSValue * value in args) {
            [stirng appendString:value.toString];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"arguments" message:stirng preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertView addAction:action];
            [weakSelf presentViewController:alertView animated:YES completion:nil];
        });
    };
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
