//
//  Task.h
//  ToDoObjC
//
//  Created by Josue Hernandez on 6/19/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Task : NSObject <NSCoding>
{
    NSString *name;
    BOOL isDone;
}

@property (retain, nonatomic) NSString *name;
@property (nonatomic) BOOL isDone;

- (void) encodeWithCoder:(NSCoder *)coder;
-(id) initWithName:(NSString *)taskName isDone:(BOOL)boolValue;

@end

NS_ASSUME_NONNULL_END
