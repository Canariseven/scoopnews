//
//  YWCNewsTableViewController.m
//  scoopNews
//
//  Created by Carmelo Ruymán Quintana Santana on 29/4/15.
//  Copyright (c) 2015 Carmelo Ruymán Quintana Santana. All rights reserved.
//

#import "YWCNewsTableViewController.h"

#import "YWCGeneralNewsTableViewCell.h"
#import "YWCMyNewsTableViewCell.h"
#import "YWCNewsModel.h"
#import "YWCNewViewController.h"
#import "YWCProfile.h"
@interface YWCNewsTableViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) YWCLibraryNews *arrayModel;
@property (nonatomic, strong) NSString *modePresent;
@property (nonatomic, strong) MSClient *client;
@property (nonatomic, strong) MSTable *table;

@end

@implementation YWCNewsTableViewController
-(id)initWithAllNews:(YWCLibraryNews *)arrayModel
          withClient:(MSClient *)client
            andTable:(MSTable *)table
                mode:(NSString *)mode{
    if (self = [super initWithNibName:nil bundle:nil]) {
        
        self.modePresent = mode;
        _arrayModel = arrayModel;
        _client = client;
        _table = table;
        self.arrayModel.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if ([self.modePresent  isEqual: @"ALLNEWS"]) {
        UINib *nib = [UINib nibWithNibName:@"YWCGeneralNewsTableViewCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:@"generalCellID"];
    }else{
        UINib *nib = [UINib nibWithNibName:@"YWCMyNewsTableViewCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:@"owNewsCellID"];
    }
    
    if (self.arrayModel.user != nil) {
        UIBarButtonItem *add = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self
                                                                            action:@selector(addNew:)];
        self.navigationItem.rightBarButtonItem = add;
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.tableView reloadData];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.modePresent  isEqual: @"ALLNEWS"]) {
        return [self.arrayModel.allNews count];
    }
    return [self.arrayModel.myNews count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.modePresent  isEqual: @"ALLNEWS"]) {
        YWCGeneralNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"generalCellID" forIndexPath:indexPath];
        YWCNewsModel * model = [self.arrayModel newFromAllNewsAtIndexPath:indexPath];
        cell.model = model;
        [cell sincronizeView];
        return cell;
        return cell;
    }else{
        YWCMyNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"owNewsCellID" forIndexPath:indexPath];
        YWCNewsModel * model = [self.arrayModel newFromMyNewsAtIndexPath:indexPath];
        cell.model = model;
        [cell sincronizeView];
        return cell;
    }
    return nil;
}

-(void)addNew:(id)sender{
    YWCNewViewController *newVC = [[YWCNewViewController alloc]initWithClient:self.client userProfile:self.arrayModel.user andLibrary:self.arrayModel];
    [self.navigationController pushViewController:newVC animated:YES];
    
}


#pragma mark - YWCLibraryNewsDelegate
-(void)libraryNews:(YWCLibraryNews *)libraryNews{
    self.arrayModel = libraryNews;
    [self.tableView reloadData];
}

@end
