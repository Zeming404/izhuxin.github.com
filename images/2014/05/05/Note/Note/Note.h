//
//  CENote.h
//  TextKitNotepad
//
//  Created by Jeason on 28/03/2014.
//  Copyright (c) 2013 Jeason. All rights reserved.
//

//#import <Foundation/Foundation.h>
//1
@import Foundation;

//2
@interface Note : NSObject

//3
@property (nonatomic, strong) NSString* contents;
@property (nonatomic, strong) NSDate* timestamp;
@property (nonatomic, strong) NSData *imageData;
// an automatically generated not title, based on the first few words
@property (nonatomic, readonly) NSString *title;

@property NSUInteger NoteID;

//4
- (instancetype)initWithText:(NSString*)text NoteID: (NSUInteger)noteid;

+ (instancetype)noteWithText:(NSString *)text NoteID: (NSUInteger)noteid;

@end
