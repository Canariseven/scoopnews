//
//  services.m
//  scoopNews
//
//  Created by Carmelo Ruymán Quintana Santana on 30/4/15.
//  Copyright (c) 2015 Carmelo Ruymán Quintana Santana. All rights reserved.
//

#import "services.h"
@interface services ()
@property (nonatomic, strong) MSClient *client;
@property (nonatomic, strong) MSTable *blobsTable;
@end

@implementation services

+(void) downloadDataWithURL:(NSURL *)url statusOperationWith:(void(^)(NSData *data ,NSURLResponse * response, NSError *error))success failure:(void (^)(NSURLResponse *response, NSError *error))failure{
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPAdditionalHeaders = @{@"Accept"    : @"application/json"};
    // Inicialización de la sesión
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    // Tarea de gestión de datos
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
        if (HTTPResponse.statusCode == 200) {
            if (!error) {
                if (data != nil) {
                    success(data,response,error);
                }else{
                    NSLog(@"Fallo Data");
                    failure(response,error);
                }
            }else{
                failure(response,error);
            }
        }else{

            failure(response,error);
        }
        
    }];
    [dataTask resume];
}
-(void)getScoopNewsForRecipientNews:(NSDictionary *)news andCompletion:(CompletionWithResponseTypeAndResponse) completion {
    [self.client invokeAPI:@"getscoopnewsrecipient" body:news HTTPMethod:@"POST" parameters:nil headers:nil completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
        if (error) {
            
        }else{
            if ([[result objectForKey:@"Status"] isEqualToString:@"FAIL"]) {
                if (completion) {
                    completion(kResponseTypeFail, [result objectForKey:@"Error"]);
                }
            } else {
                completion(kresponseTypeSuccess, result);
            }
        }
    } ];
}
+(void) getSasUrlForNewBlob:(NSString *)blobName client:(MSClient *)client withCompletion:(CompletionWithSasBlock) completion {

    NSDictionary *params = @{ @"blobName" : blobName };
    
    
    [client invokeAPI:@"geturlblob" body:nil HTTPMethod:@"GET" parameters:params headers:nil completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
        // p.e: obtenemos la url de la foto de perfil
        if (!error) {
            NSString *sasUrls= [result valueForKey:@"sasUrl"];
            completion(sasUrls);
        }else{
            completion(nil);
        }

    }];
}
+(void) getSasUrlForNewBlob:(NSString *)blobName forContainer:(NSString *)containerName blobsTable: (MSTable *)blobsTable withCompletion:(CompletionWithSasBlock) completion {
    NSDictionary *item = @{  };
    NSDictionary *params = @{ @"containerName" : containerName, @"blobName" : blobName };
    
    [blobsTable insert:item parameters:params completion:^(NSDictionary *item, NSError *error) {
        NSLog(@"Item: %@", item);
        
        completion([item objectForKey:@"sasUrl"]);
    }];
}
@end
