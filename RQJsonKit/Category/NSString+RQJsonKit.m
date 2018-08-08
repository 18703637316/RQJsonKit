//
//  NSString+RQJsonKit.m
//  RQJsonKit
//
//  Created by renqiang on 2017/12/28.
//  Copyright © 2017年 renqiang. All rights reserved.
//

#import "NSString+RQJsonKit.h"

@implementation NSString (RQJsonKit)

- (NSString *)rq_createSetter
{
    if(!self.length) return nil;
    NSMutableString *setterStr = [NSMutableString stringWithString:@"set"];
    [setterStr appendString:[self rq_firstCharUpper]];
    [setterStr appendString:@":"];
    return setterStr;
}

- (NSString *)rq_firstCharUpper
{
    if(!self.length) return nil;
    NSMutableString *string = [NSMutableString string];
    [string appendString:[NSString stringWithFormat:@"%c", [self characterAtIndex:0]].uppercaseString];
    if (self.length >= 2) [string appendString:[self substringFromIndex:1]];
    return string;
}

- (NSURL *)rq_url
{
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *encodedUrl = [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return [NSURL URLWithString:encodedUrl];
}

- (void)rq_enumerateMappingKeyUsingBlock:(void (^)(RQMappingKeyType, NSString *))block
{
    NSArray *keysArray = [self componentsSeparatedByString:@"."];
    if(!keysArray.count && block) {
        block(RQMappingKeyTypeDictionary,self);
        return;
    }
    for(NSString *key in keysArray) {
        NSRange leftBracesRange = [key rangeOfString:@"["];
        if(leftBracesRange.location != NSNotFound) {
            NSString *firstKey = [key substringToIndex:leftBracesRange.location];
            if(firstKey) {
                if(block) {
                    block(RQMappingKeyTypeDictionary,firstKey);
                }
            }
            NSRange rightBracesRange = [key rangeOfString:@"]"];
            if(rightBracesRange.location != NSNotFound) {
                
                NSRange lastKeyRange = NSMakeRange(leftBracesRange.location + 1, rightBracesRange.location - (leftBracesRange.location + leftBracesRange.length));
                NSString *secondKey = [key substringWithRange:lastKeyRange];
                if(secondKey) {
                    if(block) {
                        block(RQMappingKeyTypeArray,secondKey);
                    }
                }
            }
        } else {
            if(block) {
                block(RQMappingKeyTypeDictionary,key);
            }
        }
    }
}

@end
