//
//  Utils.h
//  PettyBook
//
//  Created by Carmelo Ruymán Quintana Santana on 4/4/15.
//  Copyright (c) 2015 Carmelo Ruymán Quintana Santana. All rights reserved.
//


@import Foundation;
@interface Utils : NSObject
+(NSURL *)urlWithNameFile:(NSString *)name andDirectory:(NSSearchPathDirectory)directory;
+(BOOL)saveWithData:(NSData *)data name:(NSString *)name andDirectory:(NSSearchPathDirectory)directory;
+(NSData *)dataWithNameFile:(NSString *)name andDirectory:(NSSearchPathDirectory)directory;
@end
