//
//  NGHChatMessage.m
//  Nigh
//
//  Created by Ricky Chang on 4/10/14.
//  Copyright (c) 2014 Ricky Chang. All rights reserved.
//

#import "NGHChatMessage.h"

@implementation NGHChatMessage

#pragma mark - Initialization

-(instancetype)initWithText:(NSString *)text
                     sender:(NSString *)sender
                       date:(NSDate *)date {
    self = [super init];
    if (self) {
        _text = text ? text : @"";
        _sender = sender;
        _date = date;
    }
    return self;
}


-(void)dealloc {
    _text = nil;
    _sender = nil;
    _date = nil;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _text = [aDecoder decodeObjectForKey:@"text"];
        _sender = [aDecoder decodeObjectForKey:@"sender"];
        _date = [aDecoder decodeObjectForKey:@"date"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.text forKey:@"text"];
    [aCoder encodeObject:self.sender forKey:@"sender"];
    [aCoder encodeObject:self.date forKey:@"date"];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    return [[[self class] allocWithZone:zone] initWithText:[self.text copy]
                                                    sender:[self.sender copy]
                                                      date:[self.date copy]];
}


#pragma mark - NGHMultipeerMessage

-(NGHMessageType)messageType {
    return NGHMessageTypeChat;
}

@end
