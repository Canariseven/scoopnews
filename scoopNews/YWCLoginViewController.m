//
//  YWCLoginViewController.m
//  scoopNews
//
//  Created by Carmelo Ruymán Quintana Santana on 30/4/15.
//  Copyright (c) 2015 Carmelo Ruymán Quintana Santana. All rights reserved.
//

#import "YWCLoginViewController.h"

#import "YWCProfile.h"
@interface YWCLoginViewController ()
@property (nonatomic, strong) MSClient *client;
@end

@implementation YWCLoginViewController
-(id)initWithClient:(MSClient *)client andUser:(YWCProfile *)userProfile{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _client = client;
        _userProfile = userProfile;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.contentImageView.layer.cornerRadius = self.contentImageView.frame.size.height/2;
    [self setupKVO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self tearDownKVO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)loginButton:(id)sender {
    [self.client loginWithProvider:@"facebook" controller:self animated:YES completion:^(MSUser *user, NSError *error) {
        if (error == nil) {
            NSLog(@"Datos user: %@",user);
            self.userProfile.idUser = user.userId;
            self.userProfile.token = user.mobileServiceAuthenticationToken;
            [self.userProfile saveAuthInfo];
            [self.userProfile getUserInfo];
        }else{
            NSLog(@"fallo al hacer login FC  --->>%@",error.description);
        }
    }];
}

-(void)setupKVO{
    NSArray *arr = [self.userProfile observableKeyNames];
    for (NSString *key in arr) {
        [self.userProfile addObserver:self
                           forKeyPath:key
                              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                                                      context:NULL];
    }
}
-(void)tearDownKVO{
    NSArray *arr = [self.userProfile observableKeyNames];
    for (NSString *key in arr) {
        [self.userProfile removeObserver:self
                              forKeyPath:key];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context{
    if ([keyPath isEqualToString:@"nameUser"]) {
        self.nameLabel.text = self.userProfile.nameUser;
    }else if ([keyPath isEqualToString:@"image"]){
        self.image.image = self.userProfile.image;
    }
}
@end
