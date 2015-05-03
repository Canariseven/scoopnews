//
//  ViewController.m
//  scoopNews
//
//  Created by Carmelo Ruymán Quintana Santana on 29/4/15.
//  Copyright (c) 2015 Carmelo Ruymán Quintana Santana. All rights reserved.
//

#import "YWCViewController.h"
#import "YWCNewsTableViewController.h"
#import "YWCLibraryNews.h"
#import "YWCLoginViewController.h"
#import "YWCProfile.h"
#import "services.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
@interface YWCViewController ()
- (IBAction)allNews:(id)sender;
- (IBAction)myNews:(id)sender;
@property (nonatomic, strong) MSClient *client;
@property (nonatomic, strong) MSTable *table;
@property (nonatomic, strong) YWCProfile *profile;
@property (nonatomic, strong) YWCLibraryNews *allNewsLibraryVC;
@property (nonatomic, strong) YWCLibraryNews *myNewsLibraryVC;
@end

@implementation YWCViewController

-(id)initWithClient:(MSClient *)client andTable:(MSTable *)table{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _client = client;
        _table = table;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Menu Screen";
    self.profile = [[YWCProfile alloc]initWithClient:self.client];
    self.allNewsLibraryVC = [[YWCLibraryNews alloc]initWithUser:self.profile];
    self.myNewsLibraryVC = [[YWCLibraryNews alloc]initWithUser:self.profile];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self sincronizeView];
    [self.profile setupKVO:self];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.contentImageView.layer.cornerRadius = self.contentImageView.frame.size.height/2;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.profile tearDownKVO:self];
}

-(void)sincronizeView{
    if (![self.profile loadUserAuthInfo]) {
        // NO LOGIN
        self.profile.statusLogin = NO;
        self.myNewsButton.enabled = NO;
        [self.myNewsButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
        [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.imageProfile.image = nil;
        self.userNameLabel.text = @"Realiza Login";
        
    }else{
        self.profile.statusLogin = YES;
        self.imageProfile.image = self.profile.image;
        self.myNewsButton.enabled = YES;
        [self.myNewsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.loginButton setTitle:@"Logout" forState:UIControlStateNormal];
        [self.loginButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
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
    NSString * modePresent= @"ALLNEWS";
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker send:[GAIDictionaryBuilder createEventWithCategory:@"Consulta de todas las noticias"
                                                         action:@"Consulta"
                                                          label:nil
                                                          value:nil].build];
    
    

    [self.allNewsLibraryVC loadItemsFromAzureForMode:modePresent table:self.table];
    YWCNewsTableViewController *tVC = [[YWCNewsTableViewController alloc]initWithAllNews:self.allNewsLibraryVC
                                                                              withClient:self.client
                                                                                andTable:self.table
                                                                                    mode:modePresent];
    
    // DELEGADO YWCLibraryNewsDelegate
    self.allNewsLibraryVC.delegate = tVC;
    [self.navigationController pushViewController:tVC animated:YES];
}

- (IBAction)myNews:(id)sender {
    NSString * modePresent= @"MYNEWS";
    
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker send:[GAIDictionaryBuilder createEventWithCategory:@"Consulta de las noticias propias"
                                                         action:@"Consulta"
                                                          label:nil
                                                          value:nil].build];
    
    [self.myNewsLibraryVC loadItemsFromAzureForMode:modePresent table:self.table];
    YWCNewsTableViewController *tVC = [[YWCNewsTableViewController alloc]initWithAllNews:self.myNewsLibraryVC
                                                                              withClient:self.client
                                                                                andTable:self.table
                                                                                    mode:modePresent];
    // DELEGADO YWCLibraryNewsDelegate
    self.myNewsLibraryVC.delegate = tVC;
    
    
    [self.navigationController pushViewController:tVC animated:YES];
}

- (IBAction)loginButton:(id)sender {
    self.profile.statusLogin = !self.profile.statusLogin;
    [self.profile deleteUserOnDefault];
    YWCLoginViewController *loginVC = [[YWCLoginViewController alloc]initWithClient:self.client andUser:self.profile];
    [self.navigationController pushViewController:loginVC animated:YES];
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
