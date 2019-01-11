//
//  RACViewController.m
//  CommonLibraries
//
//  Created by Yang on 2019/1/10.
//  Copyright © 2019年 Yang. All rights reserved.
//
#import <ReactiveObjC.h>
#import <RACEXTScope.h>
#import "RACViewController.h"

@interface RACViewController ()

@property (nonatomic,strong)RACCommand *command;

@property (nonatomic,strong)UILabel *titleLabel;
@end

@implementation RACViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    /**
        RACSignal的简单使用*/
    /**
    RACSignal *signal=[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"Hello World"];//发送信号
        [subscriber sendCompleted];//信号发送完成
        return [RACDisposable disposableWithBlock:^{
            // block调用时刻：当信号发送完成或者发送错误，就会自动执行这个block,取消订阅信号。
            // 执行完Block后，当前信号就不在被订阅了。
            NSLog(@"信号被销毁");
        }];//创建信号
    }];
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"=====%@=====",x);
    }];//订阅信号
     */
    
    /**
        RACSubject和RACReplaySubject简单使用
     */
    /**
    RACSubject *subject=[RACSubject subject];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"====第一个订阅者%@=====",x);
    }];
    [subject subscribeNext:^(id  _Nullable x) {
         NSLog(@"====第二个订阅者%@=====",x);
    }];
    [subject sendNext:@"0000"];
    [subject sendNext:@"1111"];//先订阅信号才能发送信号
    
    
    RACReplaySubject *replaySubject=[RACReplaySubject subject];
    [replaySubject sendNext:@"2222"];//RACReplaySubject可以先发送信号，在订阅信号，RACSubject就不可以。
    [replaySubject sendNext:@"3333"];
    [replaySubject sendNext:@"4444"];
    [replaySubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"====第一个订阅者%@=====",x);
    }];
    [replaySubject subscribeNext:^(id  _Nullable x) {
         NSLog(@"====第二个订阅者%@=====",x);
    }];
     **/
    
    /**
//    RACTuple:元组类,类似NSArray,用来包装值.
//    RACSequence:RAC中的集合类，用于代替NSArray,NSDictionary,可以使用它来快速遍历数组和字典。
    NSArray *numbers=@[@"AAA",@"BBB",@"CCC",@"DDD",@"EEE",@"FFF"];
    [numbers.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"----%@-----",x);
    }];//数组遍历
    
    NSArray *newNumbers=[[numbers.rac_sequence.signal map:^id _Nullable(id  _Nullable value) {
        NSLog(@"=====%@=====",value);
        return value;
    }] toArray];// map:映射的意思，目的：把原始值value映射成一个新值
    NSLog(@"======++%@++====",newNumbers);
    
    NSDictionary *dict=@{@"A":@"64",@"B":@"65",@"C":@"66"};
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        RACTupleUnpack(NSString*key,NSString*value)=x;//// 解包元组，会把元组的值，按顺序给参数里面的变量赋值
        NSLog(@"+++key=%@~~~value=%@+++",key,value);
    }];
    **/
    
    /**
        RACCommand简单使用
        使用场景:监听按钮点击，网络请求
     */
    /**
    self.command=[[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"网络请求数据"];
            [subscriber sendCompleted];
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }];
    }];//RACCommand需要被强引用，否则接收不到RACCommand中的信号，因此RACCommand中的信号是延迟发送的。
    [self.command.executionSignals subscribeNext:^(id _Nullable x) {
        [x subscribeNext:^(id x) {
            NSLog(@"====%@====",x);
        }];
    }];
    
    [self.command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"+++++++%@+++++++",x);
    }];
    
    [[self.command.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue] == YES) {
            NSLog(@"正在执行");
        }else{
            NSLog(@"执行完成");
        }
    }];//监听命令是否执行完毕,默认会来一次，可以直接跳过，skip表示跳过第一次信号。
    [self.command execute:nil];//执行命令
    
    **/
    
    
    /**
     RACMulticastConnection:用于当一个信号，被多次订阅时，为了保证创建信号时，避免多次调用创建信号中的block，造成副作用，可以使用这个类处理。
     **/
    /**
    RACSignal *signal=[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"6666"];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    RACMulticastConnection *connection=[signal publish];//创建连接
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"===333===%@======",x);
    }];
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"===444===%@======",x);
    }];
    [connection connect];//连接,激活信号
    **/
    
    
    /**
    self.titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
    [self.view addSubview:self.titleLabel];
    _titleLabel.text=@"Hello World!!!";
    [[self.titleLabel rac_valuesAndChangesForKeyPath:@"text" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
        NSLog(@"==1=====%@====",x);
    }];// kvo
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(50, 250, 50, 50);
    [self.view addSubview:btn];
    btn.backgroundColor=[UIColor orangeColor];
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"==2====%@=====",x);
    }];;//用于监听某个事件。
    
    [[NSNotificationCenter defaultCenter] rac_addObserverForName:@"" object:self];//通知
    
    UITextField*textFiled=[[UITextField alloc] initWithFrame:CGRectMake(100, 200, 150, 40)];
    [self.view addSubview:textFiled];
    textFiled.backgroundColor=[UIColor whiteColor];
    [textFiled.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"===3====%@======",x);
    }];//监听文本框文字改变:
    
    [[self rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:) fromProtocol:@protocol(UITableViewDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
        
    }];
     **/
    
    /**
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:@1111];
                [subscriber sendCompleted];
        });
        
        
        return nil;
    }];
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@2222];
            [subscriber sendCompleted];
        });
        
        
        return nil;
    }];
    
    // 把signalA拼接到signalB后，signalA发送完成，signalB才会被激活。
    RACSignal *concatSignal = [signalA combineLatestWith:signalB];
    
    // 以后只需要面对拼接信号开发。
    // 订阅拼接的信号，不需要单独订阅signalA，signalB
    // 内部会自动订阅。
    // 注意：第一个信号必须发送完成，第二个信号才会被激活
    [concatSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    **/
    
    
    RACSignal *signalA = [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@22222];
            [subscriber sendCompleted];
        });
        return nil;
    }]map:^id _Nullable(id  _Nullable value) {
        
        return value;
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"=======%@=====",x);
    }] ;
    
    RACCommand * command = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"%@",input);
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"33333"];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"======%@======",x);
    }];
    [command execute:@"111"];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.titleLabel.text=@"HAHAHAHAHA";
}

/**  使用 RACSubject逆向传值
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    FirstViewController*firstVC=[FirstViewController new];
    firstVC.subject=[RACSubject subject];
    [firstVC.subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"======%@=======",x);
    }];
    [self.navigationController pushViewController:firstVC animated:YES];
}
 **/
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
