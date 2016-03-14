//
//  ViewController.m
//  anwang
//
//  Created by Apple on 3/13/16.
//  Copyright © 2016 luzhouseo. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD+XMG.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *pwd;

@end

@implementation ViewController
- (IBAction)login:(id)sender {
    
    
    if (!self.userName.text) {
        [MBProgressHUD showError:@"请输入用户名"];
        return ;
    }
    if (!self.pwd.text)
    {
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    
    
    NSString *urlStr = [[NSString stringWithFormat:@"http://localhost:8080/login?username=%@&pwd=%@",self.userName.text,self.pwd.text] stringByRemovingPercentEncoding];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
  //这里不能用子线程.应该在主队列中刷新表格.用户界面才能看到蒙版..\
    这个任务一定要回到主线程中去做,主线程显示这个蒙版这个页面给用户看\
    主队列.并不等于你发请求在主队列(发请求在子线程)....这段任务 在主队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
  [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        //获取服务器信息
      if (!data || connectionError) {
          [MBProgressHUD showError:@"请求失败"];
          return ;
      }
     
     NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
      NSString *errer = dict[@"error"];
      if (errer) {
          //用户名或密码不存在
          [MBProgressHUD showError:errer];
          return;
      }else {
          NSString *cuccess = dict[@"cuccess"];
          //用户登陆成功
          [MBProgressHUD showSuccess:cuccess];
          
      }
      
      
    }] ;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
