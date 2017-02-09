//
//  ViewController.m
//  HeadImageScale
//
//  Created by eluying on 2017/2/9.
//  Copyright © 2017年 com.edu.info. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+HeadImageScale.h"

static NSString *const Identifier = @"Cell";

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
- (void)initData {
    self.tableView.headerScaleImage = [UIImage imageNamed:@"HeaderImage"];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 200)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:Identifier];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    cell.textLabel.text = @"HeadImage";
    return cell;
}

@end
