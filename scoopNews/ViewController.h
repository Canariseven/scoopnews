//
//  ViewController.h
//  scoopNews
//
//  Created by Carmelo Ruymán Quintana Santana on 29/4/15.
//  Copyright (c) 2015 Carmelo Ruymán Quintana Santana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
@interface ViewController : UIViewController

-(id)initWithClient:(MSClient *)client andTable:(MSTable *)table;
@end

