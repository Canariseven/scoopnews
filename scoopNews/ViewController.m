//
//  ViewController.m
//  scoopNews
//
//  Created by Carmelo Ruymán Quintana Santana on 29/4/15.
//  Copyright (c) 2015 Carmelo Ruymán Quintana Santana. All rights reserved.
//

#import "ViewController.h"
#import "YWCNewsTableViewController.h"
#import "YWCLibraryNews.h"

@interface ViewController ()
- (IBAction)allNews:(id)sender;
- (IBAction)myNews:(id)sender;
@property (nonatomic, strong) MSClient *client;
@property (nonatomic, strong) MSTable *table;
@end

@implementation ViewController



-(id)initWithClient:(MSClient *)client andTable:(MSTable *)table{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _client = client;
        _table = table;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)allNews:(id)sender {
    YWCLibraryNews *lVC = [[YWCLibraryNews alloc]init];
    [lVC getAllNewsFromAzureWithClient:self.client andTable:self.table];
    
    YWCNewsTableViewController *tVC = [[YWCNewsTableViewController alloc]initWithAllNews:lVC withClient:self.client andTable:self.table];
    
    // DELEGADO YWCLibraryNewsDelegate
    lVC.delegate = tVC;
    
    
    [self.navigationController pushViewController:tVC animated:YES];
}

- (IBAction)myNews:(id)sender {
}

@end
