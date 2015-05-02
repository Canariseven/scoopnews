//
//  YWCLibraryNews.m
//  scoopNews
//
//  Created by Carmelo Ruymán Quintana Santana on 29/4/15.
//  Copyright (c) 2015 Carmelo Ruymán Quintana Santana. All rights reserved.
//

#import "YWCLibraryNews.h"
#import "YWCProfile.h"
#import "YWCNewsModel.h"
@implementation YWCLibraryNews


-(void)addAllNewsObject:(NSObject *)object{
    [self.allNews insertObject:object atIndex:self.allNews.count];
}
-(void)addMyNewsObject:(NSObject *)object{
    [self.myNews insertObject:object atIndex:self.myNews.count];
}

-(id)initWithUser:(YWCProfile *)user{
    if (self = [super init]) {
        _user = user;
        _allNews = [[NSMutableArray alloc]init];
        _myNews = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)getAllNewsFromAzureWithClient:(MSClient *)client andTable:(MSTable *)table{
    NSPredicate *predicate;
    if (self.user != nil) {
        predicate = [NSPredicate predicateWithFormat:@"(userId != %@) OR (userId == %@)",self.user.idUser,NULL];
    }
    [table readWithPredicate:predicate completion:^(MSQueryResult *result, NSError *error) {
        if (!error) {
            NSArray *datosAzure = [result.items mutableCopy];
            for (id item in datosAzure) {
                NSLog(@"item -> %@", item);

                YWCNewsModel * new = [YWCNewsModel modelWithDictionary:item];
                    [new downloadImage];
                [self addAllNewsObject:new];
                
            }
            [self.delegate libraryNews:self];
        }else{
            NSLog(@"%@",error);
        }
    }];
}

-(void)getMyNewsFromAzureWithClient:(MSClient *)client andTable:(MSTable *)table{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@",self.user.idUser];
    
    [table readWithPredicate:predicate completion:^(MSQueryResult *result, NSError *error) {
        if (!error) {
            NSArray *datosAzure = [result.items mutableCopy];
            for (id item in datosAzure) {
                NSLog(@"item -> %@", item);
                YWCNewsModel * new = [YWCNewsModel modelWithDictionary:item];
                                    [new downloadImage];
                [self addMyNewsObject:new];
                
            }
            [self.delegate libraryNews:self];
            
        }else{
            NSLog(@"%@",error);
        }
    }];
    
    
}

-(YWCNewsModel *)newFromAllNewsAtIndexPath:(NSIndexPath *)indexPath{
    return [self.allNews objectAtIndex:indexPath.row];
}
-(YWCNewsModel *)newFromMyNewsAtIndexPath:(NSIndexPath *)indexPath{
    return [self.myNews objectAtIndex:indexPath.row];
}

@end