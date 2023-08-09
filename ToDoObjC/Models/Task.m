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

///  (to archive the object)
- (void) encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:name forKey:kNameKey];
    [coder encodeBool:isDone forKey:kIsDoneKey];
}

/// (to unarchive the object
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)decoder {
  if (self = [super init]) {
//      name = [decoder decodeObjectOfClass:[NSString class] forKey:kNameKey];
//      isDone = [decoder decodeBoolForKey:kIsDoneKey];
//      name = [decoder decodeObjectForKey:kNameKey];
//      isDone = [decoder decodeObjectForKey:kIsDoneKey];
      

      self.name = [decoder decodeObjectForKey:kNameKey];
      self.isDone = [decoder decodeBoolForKey:kIsDoneKey];
      
      
  }
  return self;
}

+ (BOOL)supportsSecureCoding {
    return true;
}

@end
