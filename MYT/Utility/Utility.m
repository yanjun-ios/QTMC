//
//  Utility.m
//  HXZXG
//
//  Created by Qingqing on 15/11/5.
//  Copyright (c) 2015年 红星装修公. All rights reserved.
//

#import "Utility.h"

static Utility * sharedInstance = nil;

@implementation Utility : NSObject

+ (Utility *)sharedInstance{
    if (sharedInstance == nil) {
        sharedInstance = [[Utility alloc] init];
    }
    return sharedInstance;
}

-(void)setFirstStart:(BOOL)firstStart{
    _firstStart = firstStart;
    [[NSUserDefaults standardUserDefaults] setBool:_firstStart forKey:@"FIRST_START"];
}

-(BOOL)isFirstStart{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"FIRST_START"]){
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

- (NSString *)urlEncode:(NSString*) oriStr{
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[oriStr UTF8String];
    int sourceLen = (int)strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return oriStr;
}

- (NSString *)urlEncodeValue:(NSString *)encoding
{
    NSString *charactersToEscape = @"!*'();:@&=+$,/?%#[]\" ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    
    return [encoding stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
}

-(CGSize)getStringSize:(NSString*)string boundsSize:(CGSize)size fontSize:(int)fontSize
{
    if (string) {
        //根据字符串计算label所需尺寸
        NSStringDrawingOptions option = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:fontSize] forKey:NSFontAttributeName];
        CGRect strRect = [string boundingRectWithSize:size options:option attributes:attributes context:nil];
        return strRect.size;
    }else{
        return CGSizeMake(0, 0);
    }
}

//设置视图圆角
-(void)setLayerView:(UIView *)view borderW:(CGFloat)W borderColor:(UIColor *)color radius:(CGFloat)r
{
    [view.layer setMasksToBounds:YES];
    [view.layer setBorderWidth:W];
    [view.layer setBorderColor:[color CGColor]];
    [view.layer setCornerRadius:r];
    
}
@end
