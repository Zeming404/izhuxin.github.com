//
//  CENote.m
//  TextKitNotepad
//
//  Created by Jeason on 19/06/2013.
//  Copyright (c) 2013 Jeason. All rights reserved.
//

#import "Note.h"

@interface Note ()
//2
@end

@implementation Note

- (instancetype)initWithText:(NSString*)text NoteID: (NSUInteger)noteid {
    self = [super init];
    if ( self  != nil ) {
        self.contents = text;
        self.NoteID = noteid;
        self.timestamp = [NSDate date];
    }
    return self;
}

+ (instancetype)noteWithText:(NSString *)text NoteID:(NSUInteger)noteid {
    Note* note = [Note new];
    note.contents = text;
    note.NoteID = noteid;
    note.timestamp = [NSDate date];
    return note;
}

- (NSString *)title {
    // split into lines
    NSArray* lines = [self.contents componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
    
    // return the first
    return lines[0];
}

@end
