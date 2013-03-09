//
//  APIDownload.h
//  Download
//
//  Created by Alximik on 08.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol APIDownloadDelegate <NSObject>
@optional
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
@end

@interface APIDownload : NSObject {    
    SEL successSelector;
    id <APIDownloadDelegate> delegate;
}

@property (nonatomic, assign) id <APIDownloadDelegate> delegate;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, retain) NSMutableData *downloadData;
@property (nonatomic, retain) NSURLResponse *response;
@property (nonatomic, retain) NSURLConnection *connection;

+ (id)downloadWithURL:(NSString*)url delegate:(id)delegate sel:(SEL)selector;
+ (id)downloadWithURL:(NSString*)url delegate:(id)delegate;

- (void)setSuccessSelector:(SEL)selector;
- (void)cancel;


@end