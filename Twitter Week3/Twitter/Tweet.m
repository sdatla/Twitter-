//
//  Tweet.m
//  Twitter
//
//  Created by Sneha  Datla on 10/4/14.
//  Copyright (c) 2014 Sneha  Datla. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self)
    {
        self.author = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.text = dictionary[@"text"];
        NSString *createdAtString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss ZZZZ yyyy";
        
        self.createdAt = [formatter dateFromString:createdAtString];
        
    }
    return self;
}

+ (NSArray *)tweetsWithArray:(NSArray *)array{
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array){
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
        
    }
    return tweets;
}

+(NSString*)retrivePostTime:(NSDate*)userPostDate{
   
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    [df setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
//    NSDate *userPostDate = [df dateFromString:postDate];
    
    
    NSDate *currentDate = [NSDate date];
    NSTimeInterval distanceBetweenDates = [currentDate timeIntervalSinceDate:userPostDate];
    
    NSTimeInterval theTimeInterval = distanceBetweenDates;
    
    // Get the system calendar
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    
    // Create the NSDates
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:date1];
    
    // Get conversion to months, days, hours, minutes
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
    
    NSString *returnDate;
    if ([conversionInfo month] > 0) {
        returnDate = [NSString stringWithFormat:@"%ldmth",(long)[conversionInfo month]];
    }else if ([conversionInfo day] > 0){
        returnDate = [NSString stringWithFormat:@"%ldd",(long)[conversionInfo day]];
    }else if ([conversionInfo hour]>0){
        returnDate = [NSString stringWithFormat:@"%ldh",(long)[conversionInfo hour]];
    }else if ([conversionInfo minute]>0){
        returnDate = [NSString stringWithFormat:@"%ldm",(long)[conversionInfo minute]];
    }else{
        returnDate = [NSString stringWithFormat:@"%lds",(long)[conversionInfo second]];
    }
    return returnDate;
}
@end
