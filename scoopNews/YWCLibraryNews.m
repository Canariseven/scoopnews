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


-(void)addObject:(YWCNewsModel *)object toArray:(NSMutableArray *)array{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idNews == %@", object.idNews];
    NSMutableArray *filteredArray = [array filteredArrayUsingPredicate:predicate].mutableCopy;
    
    if (filteredArray.count >0) {
        YWCNewsModel * model = filteredArray.lastObject;
        NSInteger anIndex = [array indexOfObject:model];
        [array removeObject:model];
        [array insertObject:object atIndex:anIndex];
        
    }else{
        [array addObject:object];
    }
}

-(id)initWithUser:(YWCProfile *)user{
    if (self = [super init]) {
        _user = user;
        _allNews = [[NSMutableArray alloc]init];
        _myNews = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)loadItemsFromAzureForMode:(NSString *)mode table:(MSTable *)table{
    NSPredicate *predicate;
    NSMutableArray *array;
    
    if ([mode isEqualToString:@"ALLNEWS"]){
        if (self.user != nil) {
            predicate = [NSPredicate predicateWithFormat:@"(stateNew == %@)",@"public"];
        }
        array = self.allNews;
    }else{
        predicate = [NSPredicate predicateWithFormat:@"userID == %@",self.user.idUser];
        array = self.myNews;
    }
    [self getItemsFromAzureWithTable:table forArray:array andPredicate:predicate];
    
}

-(void)getItemsFromAzureWithTable:(MSTable *)table
                          forArray:(NSMutableArray *)array
                      andPredicate:(NSPredicate *)predicate{
    [table readWithPredicate:predicate completion:^(MSQueryResult *result, NSError *error) {
        if (!error) {
            NSArray *datosAzure = [result.items mutableCopy];
            for (id item in datosAzure) {
                NSLog(@"item -> %@", item);
                YWCNewsModel * new = [YWCNewsModel modelWithDictionary:item client:table.client];
                [new getSasImage];
                [self addObject:new toArray:array];
                
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