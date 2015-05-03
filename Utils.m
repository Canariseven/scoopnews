//
//  Utils.m
//  PettyBook
//
//  Created by Carmelo Ruymán Quintana Santana on 4/4/15.
//  Copyright (c) 2015 Carmelo Ruymán Quintana Santana. All rights reserved.
//

#import "Utils.h"

@implementation Utils
+(NSURL *)urlWithNameFile:(NSString *)name andDirectory:(NSSearchPathDirectory)directory {
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *urls = [fm URLsForDirectory:directory inDomains:NSUserDomainMask];
    NSURL *urlAbsolute = [urls lastObject];
    urlAbsolute = [urlAbsolute URLByAppendingPathComponent:name];
    return urlAbsolute;
    
}

+(BOOL)saveWithData:(NSData *)data name:(NSString *)name andDirectory:(NSSearchPathDirectory)directory {
    
    NSURL *urlCache = [self urlWithNameFile:name andDirectory:directory];
    BOOL rc = [data writeToURL:urlCache atomically:NO];
    if (rc == NO) {
        NSLog(@"Fallo al cargar las imagenes");
        return NO;
    }else{
        return YES;
    }
}

+(NSData *)dataWithNameFile:(NSString *)name andDirectory:(NSSearchPathDirectory)directory {
    NSURL * urlCache = [self urlWithNameFile:name andDirectory:directory];
    NSData * data = [NSData dataWithContentsOfURL:urlCache];
    return data;
}
@end
