//
//  Task.m
//  ToDoObjC
//
//  Created by Josue Hernandez on 6/19/22.
//

#import "Task.h"


@implementation Task

#pragma mark NSCoding

#define kNameKey    @"name"
#define kIsDoneKey  @"isDone"

@synthesize name;
@synthesize isDone;

-(id) initWithName:(NSString *)taskName isDone:(BOOL)boolValue {
    if (self = [super init]) {
        name = taskName;
        isDone = boolValue;
    }
    return self;
}

-(id) init {
    return self;
}

- (void) encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:name forKey:kNameKey];
    [coder encodeBool:isDone forKey:kIsDoneKey];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)decoder {
  if (self = [super init]) {
      name = [decoder decodeObjectForKey:kNameKey];
      isDone = [decoder decodeObjectForKey:kIsDoneKey];
  }
  return self;
}


@end
