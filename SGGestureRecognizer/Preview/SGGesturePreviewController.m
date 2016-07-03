//
//  SGGesturePreviewController.m
//  SGGestureRecognizer
//
//  Created by soulghost on 10/1/2016.
//  Copyright © 2016 soulghost. All rights reserved.
//

#import "SGGesturePreviewController.h"
#import "SGGesturePoint.h"
#import "SGGestureSet.h"
#import "SGDollarOneManager.h"
#import "SGGestureCell.h"

@interface SGGesturePreviewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray<SGGestureSet *> *gestureSets;

@end

@implementation SGGesturePreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = @"Start from red point";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Exit" style:UIBarButtonItemStylePlain target:self action:@selector(exit)];
}

- (void)exit {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableArray<SGGestureSet *> *)gestureSets {
    if (_gestureSets == nil) {
        _gestureSets = [NSMutableArray arrayWithArray:[SGDollarOneManager sharedManager].gestureSets];
    }
    return _gestureSets;
}

#pragma mark TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.gestureSets.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MagicCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SGGestureSet *set = self.gestureSets[indexPath.row];
    SGGestureCell *cell = [SGGestureCell cellWithTableView:tableView set:set];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (editingStyle) {
        case UITableViewCellEditingStyleDelete:{
            [self.gestureSets removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
            [[SGDollarOneManager sharedManager].gestureSets removeObjectAtIndex:indexPath.row];
            [[SGDollarOneManager sharedManager] saveGestures];
            break;
        }
        default:
            break;
    }
}

- (void)dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

@end
