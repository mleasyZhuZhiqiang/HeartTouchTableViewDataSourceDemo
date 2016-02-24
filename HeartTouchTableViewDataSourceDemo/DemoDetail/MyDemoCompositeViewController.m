//
//  MyDemoCompositeViewController.m
//  HeartTouchTableViewDataSourceDemo
//
//  Created by 志强 on 16/2/23.
//  Copyright © 2016年 志强. All rights reserved.
//

#import "MyDemoCompositeViewController.h"

#import "HTTableViewDataSourceDelegate.h"
#import "HTTableViewCompositeDataSourceDelegate.h"
#import "NSArray+DataSource.h"

#import "MyCellStringModel.h"
#import "MyTableViewCellModel.h"

#import "MyTableViewCell.h"

@interface MyDemoCompositeViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic ,strong) id demoDataSource;

@end

@implementation MyDemoCompositeViewController

- (NSArray <HTTableViewDataSourceDataModelProtocol> *)arrayCellModels
{
    NSMutableArray * models = [NSMutableArray new];
    for (NSString * arg in @[@"A", @"B", @"C", @"D", @"E", @"F"]) {
        [models addObject:[MyCellStringModel modelWithTitle:arg]];
    }
    return models;
}

- (NSArray <HTTableViewDataSourceDataModelProtocol> *)customClassCellModels
{
    NSMutableArray * modelList = [NSMutableArray new];
    for (int index = 0; index < 10; index ++ ) {
        [modelList addObject:[MyTableViewCellModel modelWithTitle:[NSString stringWithFormat:@"%d",index] name:@"normal"]];
    }
    return modelList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册cell
    UINib * nib = [UINib nibWithNibName:@"MyTableViewCell" bundle:[NSBundle mainBundle]];
    [_tableview registerNib:nib forCellReuseIdentifier:@"MyTableViewCell"];
    
    //first data source
    HTTableViewDataSourceDelegate * dataSource1 =
    [HTTableViewDataSourceDelegate dataSourceWithModel:[self arrayCellModels]
                                   cellTypeMap:@{@"MyCellStringModel" : @"MyTableViewCell"}
                             tableViewDelegate:nil
                             cellConfiguration:
     ^(UITableViewCell *cell, NSIndexPath *indexPath) {
         if (indexPath.row % 2 == 0) {
             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
         } else {
             cell.accessoryType = UITableViewCellAccessoryCheckmark;
         }
         if (indexPath.section == 1) {
             [cell.contentView setBackgroundColor:[UIColor grayColor]];
         }
     }];
    
    //second data source
    HTTableViewDataSourceDelegate * modelDataSource =
    [HTTableViewDataSourceDelegate dataSourceWithModel:[self customClassCellModels]
                                   cellTypeMap:@{@"MyTableViewCellModel" : @"MyTableViewCell"}
                             tableViewDelegate:nil
                             cellConfiguration:
     ^(UITableViewCell *cell, NSIndexPath *indexPath) {
         cell.accessoryType = UITableViewCellAccessoryDetailButton;
     }];
    
    //composite data source
    NSMutableArray < UITableViewDataSource, UITableViewDelegate >* dataSourceList = @[].mutableCopy;
    [dataSourceList addObject:dataSource1];
    [dataSourceList addObject:modelDataSource];
    
    id <UITableViewDataSource, UITableViewDelegate> dataSource
    = [HTTableViewCompositeDataSourceDelegate dataSourceWithDataSources:dataSourceList];
    
    _tableview.dataSource = dataSource;
    _tableview.delegate = dataSource;
    self.demoDataSource = dataSource;
    [_tableview reloadData];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
@end
