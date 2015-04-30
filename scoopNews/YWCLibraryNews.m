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

-(id)init{
    if (self = [super init]) {
        _allNews = [[NSMutableArray alloc]init];
        _myNews = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)getAllNewsFromAzureWithClient:(MSClient *)client andTable:(MSTable *)table{
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID != %@",self.user.idUser];
    [table readWithPredicate:nil completion:^(MSQueryResult *result, NSError *error) {
        if (!error) {
            NSArray *datosAzure = [result.items mutableCopy];
            for (id item in datosAzure) {
                NSLog(@"item -> %@", item);
                YWCNewsModel * new = [[YWCNewsModel alloc]initWithTitleNew:item[@"title"]
                                                                     textNew:item[@"text"]
                                                                    stateNew:item[@"stateNew"]
                                                                      rating:4 imageURL:@""
                                                                      author:nil];
                [self.allNews addObject:new];
                [self.delegate libraryNews:self];
            }

        }else{
            NSLog(@"%@",error);
        }
    }];
}


-(void)addMyNewWithModel:(YWCNewsModel *)model client:(MSClient *)client andTable:(MSTable *)table{
    
    NSDictionary *dict= @{@"title":model.titleNew,
                          @"text":model.textNew,
                          @"stateNew":model.stateNew};
    [table insert:dict completion:^(NSDictionary *item, NSError *error) {
        if (!error) {
            NSUInteger index = [self.allNews count];
            [self.allNews insertObject:model atIndex:index];
                            [self.tableView reloadData];
        }else{
            NSLog(@"Error %@",error);
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