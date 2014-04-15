//
//  NGHMultipeerMessage.h
//  Nigh
//
//  Created by Ricky Chang on 4/10/14.
//  Copyright (c) 2014 Ricky Chang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NGHMessageType) {
    
    /**
     *  Specifies a chat message
     */
    NGHMessageTypeChat,
    /**
     *  Specifies a song info message
     */
    NGHMessageTypeSongInfo,
    /**
     * Specifices a stream request message
     */
    NGHMessageTypeStreamRequest
};

@protocol NGHMultipeerMessage <NSObject>

@required


/**
 * @return The text representation of this message.
 */
- (NSString *)text;

/**
 * @return The display name of the peer who sent the message.
 */
- (NSString *)sender;

/**
 * @return The date that the message was sent.
 */
-(NSDate *)date;


-(NGHMessageType)messageType;

@end
