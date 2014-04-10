//
//  NGHChatMessage.h
//  Nigh
//
//  Created by Ricky Chang on 4/10/14.
//  Copyright (c) 2014 Ricky Chang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NGHMultipeerMessage.h"
#import <JSMessagesViewController/JSMessageData.h>

@interface NGHChatMessage : NSObject <NGHMultipeerMessage, JSMessageData, NSCoding, NSCopying>

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *sender;
@property (nonatomic, strong) NSDate *date;

- (instancetype)initWithText:(NSString *)text
                      sender:(NSString *)sender
                        date:(NSDate *)date;


@end
