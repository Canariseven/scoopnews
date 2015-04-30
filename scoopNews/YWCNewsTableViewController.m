//
//  YWCNewsTableViewController.m
//  scoopNews
//
//  Created by Carmelo Ruymán Quintana Santana on 29/4/15.
//  Copyright (c) 2015 Carmelo Ruymán Quintana Santana. All rights reserved.
//

#import "YWCNewsTableViewController.h"

#import "YWCGeneralNewsTableViewCell.h"
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
-(id)initWithAllNews:(YWCLibraryNews *)arrayModel withClient:(MSClient *)client andTable:(MSTable *)table{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _arrayModel = arrayModel;
        self.modePresent = @"ALLNEWS";
        _client = client;
        _table = table;
        self.arrayModel.tableView = self.tableView;
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
        UIBarButtonItem *add = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self
                                                                            action:@selector(addNew:)];
    self.navigationItem.rightBarButtonItem = add;
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
            
        }
    
    

    return nil;

}

-(void)addNew:(id)sender{
    YWCProfile *prof = [[YWCProfile alloc]initWithName:@"Ruymán" idUser:@"1" imageURL:@""];
   YWCNewsModel *model = [[YWCNewsModel alloc]initWithTitleNew:@"Un titulo"
                                                       textNew:@"Este es un texto"
                                                      stateNew:@"publicado"
                                                        rating:4
                                                      imageURL:@""
                                                        author:prof];
    [self.arrayModel addMyNewWithModel:model client:self.client andTable:self.table];
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
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
