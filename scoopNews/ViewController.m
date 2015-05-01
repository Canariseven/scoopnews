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
#import "YWCLoginViewController.h"
#import "YWCProfile.h"
#import "services.h"
@interface ViewController ()
- (IBAction)allNews:(id)sender;
- (IBAction)myNews:(id)sender;
@property (nonatomic, strong) MSClient *client;
@property (nonatomic, strong) MSTable *table;
@property (nonatomic, strong) YWCProfile *profile;
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
    self.profile = [[YWCProfile alloc]initWithClient:self.client];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self sincronizeView];
    [self setupKVO];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.contentImageView.layer.cornerRadius = self.contentImageView.frame.size.height/2;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self tearDownKVO];
}

-(void)sincronizeView{
    if (![self.profile loadUserAuthInfo]) {
        // NO LOGIN
        self.myNewsButton.enabled = NO;
        [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
        [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        self.myNewsButton.enabled = YES;
        [self.loginButton setTitle:@"Logout" forState:UIControlStateNormal];
        [self.loginButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.profile = [[YWCProfile alloc]initWithClient:self.client];
        [self.profile loadUserAuthInfo];
        [self.profile getUserInfo];
        self.userNameLabel.text = self.profile.nameUser;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)allNews:(id)sender {
    YWCLibraryNews *lVC = [[YWCLibraryNews alloc]initWithUser:self.profile];

    [lVC getAllNewsFromAzureWithClient:self.client andTable:self.table];

    YWCNewsTableViewController *tVC = [[YWCNewsTableViewController alloc]initWithAllNews:lVC withClient:self.client andTable:self.table mode:@"ALLNEWS"];
    
    // DELEGADO YWCLibraryNewsDelegate
    lVC.delegate = tVC;
    
    
    [self.navigationController pushViewController:tVC animated:YES];
}

- (IBAction)myNews:(id)sender {
    YWCLibraryNews *lVC = [[YWCLibraryNews alloc]initWithUser:self.profile];
    [lVC getMyNewsFromAzureWithClient:self.client andTable:self.table];
    
    YWCNewsTableViewController *tVC = [[YWCNewsTableViewController alloc]initWithAllNews:lVC withClient:self.client andTable:self.table mode:@"MYNEWS"];
    
    // DELEGADO YWCLibraryNewsDelegate
    lVC.delegate = tVC;
    
    
    [self.navigationController pushViewController:tVC animated:YES];
}

- (IBAction)loginButton:(id)sender {
    [self.profile deleteUserOnDefault];
    YWCLoginViewController *loginVC = [[YWCLoginViewController alloc]initWithClient:self.client andUser:self.profile];
    [self.navigationController pushViewController:loginVC animated:YES];
}

-(void)setupKVO{
    NSArray *arr = [self.profile observableKeyNames];
    for (NSString *key in arr) {
        [self.profile addObserver:self
                           forKeyPath:key
                              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                              context:NULL];
    }
}
-(void)tearDownKVO{
    NSArray *arr = [self.profile observableKeyNames];
    for (NSString *key in arr) {
        [self.profile removeObserver:self
                              forKeyPath:key];
    }
}
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context{
    
    if ([keyPath isEqualToString:@"nameUser"]) {
        self.userNameLabel.text = self.profile.nameUser;
    }else if ([keyPath isEqualToString:@"image"]){
        self.imageProfile.image = self.profile.image;
    }
}
@end
