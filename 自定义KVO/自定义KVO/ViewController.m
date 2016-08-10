//
//  ViewController.m
//  自定义KVO
//
//  Created by 胥鸿儒 on 16/8/3.
//  Copyright © 2016年 xuhongru. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+KVOExtension.h"
#import "Person.h"
@interface ViewController ()
/**person*/
@property(nonatomic,strong)Person *person;


@end

@implementation ViewController

- (Person *)person
{
    if (!_person) {
        _person = [[Person alloc]init];
    }
    return _person;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)add:(id)sender {
    [self.person xhr_addObserverForKey:@"age" block:^(NSDictionary *valueInfo) {
        NSLog(@"--------%@",valueInfo);
    }];
    [self.person xhr_addObserverForKey:@"number" block:^(NSDictionary *valueInfo) {
        NSLog(@"========%@",valueInfo);
    }];
    [self.person xhr_addObserverForKey:@"name" block:^(NSDictionary *valueInfo) {
        NSLog(@"%@",valueInfo);
    }];
}
- (IBAction)removeAll:(id)sender {
    [self.person xhr_removeAllObserver];
}
- (IBAction)remove:(id)sender {
    [self.person xhr_removeObserverForKey:@"age"];

}
- (IBAction)sett:(id)sender {
    static int age = 0;
    self.person.age = age++;
    self.person.number = 10;
    self.person.name = @"こうさか ほのか";
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
