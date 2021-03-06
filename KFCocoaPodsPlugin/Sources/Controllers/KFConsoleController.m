//
//  KFConsoleController.m
//  KFCocoaPodsPlugin
//
//  Copyright (c) 2013 Rico Becker, KF Interactive
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "KFConsoleController.h"
#import "IDEKit.h"


@interface KFConsoleController ()


@property (nonatomic, strong) NSMutableDictionary *consoleForTask;


@end


@implementation KFConsoleController



- (id)init
{
    self = [super init];
    if (self)
    {
        _consoleForTask = [NSMutableDictionary new];
    }
    return self;
}



- (void)logMessage:(id)object forTask:(NSTask *)task
{
    [self logMessage:object printBold:NO forTask:task];
}


- (void)logMessage:(id)object printBold:(BOOL)isBold forTask:(NSTask *)task
{
    IDEConsoleTextView *console;
    if (task == nil)
    {
        console = [self consoleView:[NSApp mainWindow].contentView];
    }
    else
    {
        console = [self.consoleForTask objectForKey:@(task.processIdentifier)];
        if (console == nil)
        {
            console = [self consoleView:[NSApp mainWindow].contentView];
            [self.consoleForTask setObject:console forKey:@(task.processIdentifier)];
        }
    }
    
    
    console.logMode = isBold ? 2 : 1;
    
    [console insertText:object];
    [console insertNewline:self];
    
    console.logMode = 0;
}


- (void)removeTask:(NSTask *)task
{
    [self.consoleForTask removeObjectForKey:@(task.processIdentifier)];
}



- (IDEConsoleTextView *)consoleView:(NSView *)parentView
{
    for (NSView *view in [parentView subviews])
    {
        if ([view isKindOfClass:NSClassFromString(@"IDEConsoleTextView")])
        {
            return (IDEConsoleTextView *)view;
        }
        else
        {
            NSView *childView = [self consoleView:view];
            if ([childView isKindOfClass:NSClassFromString(@"IDEConsoleTextView")])
            {
                return (IDEConsoleTextView *)childView;
            }
        }
    }
    return nil;
}


@end
