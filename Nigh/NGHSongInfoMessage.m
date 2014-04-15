//
//  NGHSongInfoMessage.m
//  Nigh
//
//  Created by Ricky Chang on 4/14/14.
//  Copyright (c) 2014 Ricky Chang. All rights reserved.
//

#import "NGHSongInfoMessage.h"

@implementation NGHSongInfoMessage

#pragma mark - Initialization

-(instancetype)initWithTitle:(NSString *)title
                      artist:(NSString *)artist
                    duration:(NSNumber *)duration
                      sender:(NSString *)sender
                        date:(NSDate *)date {
    self = [super init];
    if (self) {
        self.title = title;
        self.artist = artist;
        self.duration = duration;
        self.sender = sender;
        self.date = date;
    }
    return self;
}

-(void)dealloc {
    self.title = nil;
    self.artist = nil;
    self.duration = nil;
    self.albumArtLarge = nil;
    self.albumArtSmall = nil;
    self.albumArt = nil;
    self.sender = nil;
    self.date = nil;
}

-(NSString*)albumArt {
    return _albumArt;
}

-(NSString*)albumArtSmall {
    return _albumArt;
}

-(NSString*)albumArtLarge {
    return _albumArt;
}

-(NSString*)text {
    return [NSString stringWithFormat:@"%@ is playing %@ - %@", self.sender, self.artist, self.title];
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.artist = [aDecoder decodeObjectForKey:@"artist"];
        self.duration = [aDecoder decodeObjectForKey:@"duration"];
        _albumArt = [aDecoder decodeObjectForKey:@"albumArt"];
        _sender = [aDecoder decodeObjectForKey:@"sender"];
        _date = [aDecoder decodeObjectForKey:@"date"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.artist forKey:@"artist"];
    [aCoder encodeObject:self.duration forKey:@"duration"];
    [aCoder encodeObject:self.albumArt forKey:@"albumArt"];
    [aCoder encodeObject:self.sender forKey:@"sender"];
    [aCoder encodeObject:self.date forKey:@"date"];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    return [[[self class] allocWithZone:zone] initWithTitle:[self.title copy]
                                                     artist:[self.artist copy]
                                                   duration:[self.duration copy]
                                                     sender:[self.sender copy]
                                                       date:[self.date copy]];
}


#pragma mark - NGHMultipeerMessage

-(NGHMessageType)messageType {
    return NGHMessageTypeSongInfo;
}





@end
