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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UINib *nib = [UINib nibWithNibName:@"YWCGeneralNewsTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"generalCellID"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if (self.arrayModel.user != nil) {
        UIBarButtonItem *add = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self
                                                                            action:@selector(addNew:)];
        self.navigationItem.rightBarButtonItem = add;
    }

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupKVO];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self tearDownKVO];
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
        cell.titleNew.text = model.titleNew;
        return cell;
    }else{
        YWCMyNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"generalCellID" forIndexPath:indexPath];
        YWCNewsModel * model = [self.arrayModel newFromAllNewsAtIndexPath:indexPath];
        cell.titleNew.text = model.titleNew;
        return cell;
    }
    return nil;
}

-(void)addNew:(id)sender{
    YWCNewViewController *newVC = [[YWCNewViewController alloc]initWithClient:self.client];
    [self.navigationController pushViewController:newVC animated:YES];

}


-(void)setupKVO{
    [self.arrayModel addObserver:self
                      forKeyPath:@"allNews"
                         options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                         context:NULL];
}
-(void)tearDownKVO{
    [self.arrayModel removeObserver:self forKeyPath:@"allNews"];
}
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context{
    [self.tableView reloadData];
}

#pragma mark - YWCLibraryNewsDelegate
-(void)libraryNews:(YWCLibraryNews *)libraryNews{
    self.arrayModel = libraryNews;
    [self.tableView reloadData];
}

@end
