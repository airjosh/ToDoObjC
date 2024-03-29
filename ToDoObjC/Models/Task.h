//
//  Task.h
//  ToDoObjC
//
//  Created by Josue Hernandez on 6/19/22.
//

#import <Foundation/Foundation.h>

@class Task;

NS_ASSUME_NONNULL_BEGIN

@interface Task : NSObject <NSSecureCoding> // <NSCoding, NSSecureCoding>
{
    NSString *name;
    BOOL isDone;
}

@property (retain, nonatomic) NSString *name;
//@property (nonatomic) BOOL isDone;
@property (nonatomic, assign) BOOL isDone;


- (void) encodeWithCoder:(NSCoder *)coder;
-(id) initWithName:(NSString *)taskName isDone:(BOOL)boolValue;

@end

NS_ASSUME_NONNULL_END
