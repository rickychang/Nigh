//
//  NGHSongInfoMessage.h
//  Nigh
//
//  Created by Ricky Chang on 4/14/14.
//  Copyright (c) 2014 Ricky Chang. All rights reserved.
//

#import <TDAudioPlayer/TDAudioMetaInfo.h>
#import "NGHMultipeerMessage.h"

@interface NGHSongInfoMessage : TDAudioMetaInfo<NGHMultipeerMessage, NSCoding, NSCopying>

@property (nonatomic, strong) NSString *albumArt;
@property (nonatomic, copy) NSString *sender;
@property (nonatomic, strong) NSDate *date;

- (instancetype)initWithTitle:(NSString *)title
                       artist:(NSString *)artist
                     duration:(NSNumber *)duration
                      sender:(NSString *)sender
                        date:(NSDate *)date;






@end
