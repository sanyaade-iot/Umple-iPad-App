//
//  UmpleClass.m
//  UmpleApp
//
//  Created by Charles Wang on 4/23/14.
//  Copyright (c) 2014 Charles. All rights reserved.
//

#import "UmpleClass.h"

@implementation UmpleClass

@synthesize class_id, name, position, attributes, methods, displayColor;

-(id) initWithDictionary:(NSDictionary*) umpleDict
{
    self = [super init];
    if(self)
    {
        self.class_id = [umpleDict objectForKey:@"id"];
        self.name = [umpleDict objectForKey:@"name"];
        NSDictionary* dictPosition = [umpleDict objectForKey:@"position"];
        float x = [[dictPosition objectForKey:@"x"] floatValue];
        float y = [[dictPosition objectForKey:@"y"] floatValue];
        float width = [[dictPosition objectForKey:@"width"] floatValue];
        float height = [[dictPosition objectForKey:@"height"] floatValue];
        self.position = CGRectMake(x, y, width, height);
        self.attributes = [NSMutableArray new];
        self.methods = [NSMutableArray new];
        
        if([umpleDict objectForKey:@"attributes"])
        {
            for(NSDictionary* attrDict in [umpleDict objectForKey:@"attributes"])
            {
                [self.attributes addObject:[[UmpleAttribute alloc] initWithDictionary:attrDict]];
            }
        }

        if([umpleDict objectForKey:@"methods"])
        {
            for(NSDictionary* methodDict in [umpleDict objectForKey:@"methods"])
            {
                [self.methods addObject:[[UmpleMethod alloc] initWithDictionary:methodDict]];
            }
        }
        

        
        
        self.displayColor = @"";
        if([umpleDict objectForKey:@"displayColor"])
        {
            self.displayColor = [umpleDict objectForKey:@"displayColor"];
        }
        
        [self constructClassModel];
    }
    return self;
}

-(void) constructClassModel
{
    [self setFrame:self.position];
    [self setTitle:[self constructTitle] forState:UIControlStateNormal];
    //NSLog(@"%@",[self constructTitle]);
    [self.titleLabel setFont:[UIFont fontWithName:@"System" size:10.0f]];
    self.titleLabel.font = [UIFont systemFontOfSize:8];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.tintColor = [UIColor blackColor];
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:0.0];
    [self.layer setBorderWidth:1.0];
    [self.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
}

-(void) updateClassModel
{
    [self setTitle:[self constructTitle] forState:UIControlStateNormal];
}

-(NSString*) constructTitle
{
    NSMutableString *classTitle = [NSMutableString new];
    
    [classTitle appendString:self.name];
    
    for(UmpleAttribute* attr in self.attributes)
    {
        [classTitle appendString:@"\n"];
        [classTitle appendString:attr.name];
    }
    
    for(UmpleMethod* meth in self.methods)
    {
        [classTitle appendString:@"\n"];
        [classTitle appendString:meth.name];
    }
    
    return classTitle;
}

-(void) update
{
    self.position = self.frame;
}

-(NSDictionary*) json
{
    NSMutableArray* attrArray = [NSMutableArray new];
    for(UmpleAttribute *umpAttr in self.attributes)
    {
        [attrArray addObject:[umpAttr json]];
    }
    
    NSMutableArray* methodArray = [NSMutableArray new];
    for(UmpleMethod *umpMethod in self.methods)
    {
        [methodArray addObject:[umpMethod json]];
    }
    return @{
             @"id" : self.class_id,
             @"name" : self.name,
             @"position" : @{
                     @"x":[NSNumber numberWithFloat:self.position.origin.x],
                     @"y":[NSNumber numberWithFloat:self.position.origin.y],
                     @"width":[NSNumber numberWithFloat:self.position.size.width],
                     @"height":[NSNumber numberWithFloat:self.position.size.height]
                     },
             @"attributes" : attrArray,
             @"methods" : methodArray,
             };
}

// In the implementation
-(id)copy
{
    UmpleClass *another = [[UmpleClass alloc] init];
    another.class_id = [class_id copy];
    another.name = [name copy];
    another.position = CGRectMake(position.origin.x, position.origin.y, position.size.width, position.size.height);
    another.attributes = [attributes copy];
    another.methods = [methods copy];
    another.displayColor = [displayColor copy];
    return another;
}

@end
