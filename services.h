//
//  services.h
//  scoopNews
//
//  Created by Carmelo Ruymán Quintana Santana on 30/4/15.
//  Copyright (c) 2015 Carmelo Ruymán Quintana Santana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
@import UIKit;


typedef enum {
    kResponseTypeFail = 0,
    kresponseTypeSuccess
} ResponseType;

#pragma mark * Block Definitions
typedef void (^CompletionWithSasBlock) (NSString *sasUrl);
typedef void (^CompletionBlock) ();
typedef void (^CompletionWithIndexBlock) (NSUInteger index);
typedef void (^CompletionWithMessagesBlock) (id messages);
typedef void (^CompletionWithStringBlock) (NSString *string);
typedef void (^CompletionWithBoolBlock) (BOOL successful);
typedef void (^CompletionWithBoolAndStringBlock) (BOOL successful, NSString *info);
typedef void (^CompletionWithResponseTypeAndResponse) (ResponseType type, id response);
typedef void (^BusyUpdateBlock) (BOOL busy);


@interface services : NSObject
+(void) downloadDataWithURL:(NSURL *)url statusOperationWith:(void(^)(NSData *data ,NSURLResponse * response, NSError *error))success failure:(void (^)(NSURLResponse *response, NSError *error))failure;
-(void)getScoopNewsForRecipientNews:(NSDictionary *)news andCompletion:(CompletionWithResponseTypeAndResponse) completion ;
+(void) getSasUrlForNewBlob:(NSString *)blobName client:(MSClient *)client withCompletion:(CompletionWithSasBlock) completion;
+(void) getSasUrlForNewBlob:(NSString *)blobName forContainer:(NSString *)containerName blobsTable: (MSTable *)blobsTable withCompletion:(CompletionWithSasBlock) completion;
@end
