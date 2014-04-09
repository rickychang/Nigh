//
//  NGHFirstViewController.m
//  Nigh
//
//  Created by RIcky Chang on 4/7/14.
//  Copyright (c) 2014 Ricky Chang. All rights reserved.
//

#import "NGHChatViewController.h"
#import "NGHAppDelegate.h"
#import <JSMessagesViewController/JSMessage.h>

@interface NGHChatViewController ()

@property (nonatomic, strong) NSMutableSet *sentMessageIndices;

@end

@implementation NGHChatViewController

- (void)viewDidLoad
{
    self.delegate = self;
    self.dataSource = self;
    [super viewDidLoad];
    
    
    [[JSBubbleView appearance] setFont:[UIFont systemFontOfSize:16.0f]];
    
    self.title = @"Group Chat";
    
    self.messageInputView.textView.placeHolder = @"New Message";
    
    self.sessionManager = ((NGHAppDelegate*)[[UIApplication sharedApplication] delegate]).sessionManager;
    
    self.sender = self.sessionManager.myPeerID.displayName;
    NSLog(@"display name %@", self.sender);
    
    self.messages = [[NSMutableArray alloc] init];
    self.sentMessageIndices = [[NSMutableSet alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayNameChangedNotification:)
                                                 name:@"NGHPeerInitializedWithDisplayName"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(multipeerMessageReceivedNotification:)
                                                 name:@"NGHChatMessageReceived"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadMessageTableView:)
                                                 name:@"NGHDidChangeStateNotification"
                                               object:nil];
    
    [self setBackgroundColor:[UIColor whiteColor]];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self scrollToBottomAnimated:NO];
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)displayNameChangedNotification:(NSNotification *)notification {
    NSString *displayName = [[notification userInfo] objectForKey:@"displayName"];
    self.sender = displayName;
}

-(void)multipeerMessageReceivedNotification:(NSNotification *)notification {
    NSLog(@"multipeerMessageReceivedNoficiation called");
    JSMessage *incomingMessage = [[notification userInfo] objectForKey:@"incomingMessage"];
    [self.messages addObject:incomingMessage];
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

-(void)reloadMessageTableView:(NSNotification *)notification {
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

#pragma mark JSMessagesViewDelegate


- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date {
    NSLog(@"did send text: %@", text);
    JSMessage *newMessage = [[JSMessage alloc] initWithText:text sender:sender date:date];
    
    [self.messages addObject:newMessage];
    
    // Track index of message we are sending
    NSNumber *messageIndex = [NSNumber numberWithInteger:self.messages.count - 1];
    [self.sentMessageIndices addObject:messageIndex];
    
    // Very simple message serialization, reuse model class for chat view. Will need to change to support other message types.
    NSData* dataToSend = [NSKeyedArchiver archivedDataWithRootObject:newMessage];
    
    [self.sessionManager.session sendData:dataToSend toPeers:self.sessionManager.session.connectedPeers withMode:MCSessionSendDataReliable error:nil];
    [self finishSend];
    [self scrollToBottomAnimated:YES];
    
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL sentMessage = [self.sentMessageIndices containsObject:[NSNumber numberWithInteger:indexPath.row]];
    return (sentMessage) ? JSBubbleMessageTypeOutgoing : JSBubbleMessageTypeIncoming;
}

- (UIImageView *)bubbleImageViewWithType:(JSBubbleMessageType)type forRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL sentMessage = [self.sentMessageIndices containsObject:[NSNumber numberWithInteger:indexPath.row]];
    if (!sentMessage) {
        return [JSBubbleImageViewFactory bubbleImageViewForType:type
                                                          color:[UIColor js_bubbleLightGrayColor]];
    }
    
    return [JSBubbleImageViewFactory bubbleImageViewForType:type
                                                      color:[UIColor purpleColor]];
}

- (void)configureCell:(JSBubbleMessageCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if ([cell messageType] == JSBubbleMessageTypeOutgoing) {
        cell.bubbleView.textView.textColor = [UIColor whiteColor];
        
        if ([cell.bubbleView.textView respondsToSelector:@selector(linkTextAttributes)]) {
            NSMutableDictionary *attrs = [cell.bubbleView.textView.linkTextAttributes mutableCopy];
            [attrs setValue:[UIColor blueColor] forKey:NSForegroundColorAttributeName];
            
            cell.bubbleView.textView.linkTextAttributes = attrs;
        }
    }
    
    if (cell.timestampLabel) {
        cell.timestampLabel.textColor = [UIColor lightGrayColor];
        cell.timestampLabel.shadowOffset = CGSizeZero;
    }
    
    if (cell.subtitleLabel) {
        cell.subtitleLabel.textColor = [UIColor lightGrayColor];
    }
    
#if TARGET_IPHONE_SIMULATOR
    cell.bubbleView.textView.dataDetectorTypes = UIDataDetectorTypeNone;
#else
    cell.bubbleView.textView.dataDetectorTypes = UIDataDetectorTypeAll;
#endif
}

- (JSMessageInputViewStyle)inputViewStyle {
    return JSMessageInputViewStyleFlat;
}

- (BOOL)shouldPreventScrollToBottomWhileUserScrolling
{
    return YES;
}

- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)allowsPanToDismissKeyboard {
    return NO;
}

#pragma mark JSMessagesViewDataSource

- (JSMessage *)messageForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messages objectAtIndex:indexPath.row];
}

- (UIImageView *)avatarImageViewForRowAtIndexPath:(NSIndexPath *)indexPath sender:(NSString *)sender {
    return nil;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSInteger peers = [self.sessionManager.session.connectedPeers count];
    
    switch (peers)
    {
        case 0:
            return @"No Peers";
        case 1:
            return @"1 Peer";
        default:
            return [NSString stringWithFormat:@"%d Peers", peers];
    }
}



@end
