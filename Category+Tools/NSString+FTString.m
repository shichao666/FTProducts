//
//  NSString+SCString.m
//  QCMVVM
//
//  Created by 史超 on 2018/11/15.
//  Copyright © 2018年 BYX. All rights reserved.
//

#import "NSString+FTString.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (FTString)
/**
 *  对 url 字符串进行UTF8编码
 *
 *  @param string 需要编码的字符串
 *
 *  @return 编码后的字符串
 */
+ (NSString *)urlEncodingUTF8:(NSString *)string{
    NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                     (CFStringRef)string,
                                                                                                     NULL,
                                                                                                     (CFStringRef)@"!*'();:@&=+$,/?%#[] ",
                                                                                                     kCFStringEncodingUTF8));
    return encodedString;
}

/**
 *  判断是否为空字符及空格
 *
 *  @param string 要判断的字符串
 *
 *  @return 包含空格 ? YES : NO
 */
+ (BOOL)isEmpty:(NSString *)string{
    if (!string) {
        return YES;
    } else {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [string stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

/**
 *  是否为有效的Email
 *
 *  @param checkString 检测字符串
 *
 *  @return 有效的Email ? YES : NO
 */
+ (BOOL) isValidEmail:(NSString *)checkString{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

/**
 *  判断一个字符串是否包含另外一个字符串
 *
 *  @param motherString 母字符串
 *  @param sonString    子字符串
 *
 *  @return 包含 ? YES : NO
 */
+ (BOOL)stringContentString:(NSString *)motherString subString:(NSString *)sonString{
    if ([motherString rangeOfString:sonString].location != NSNotFound) {
        return YES;
    }else {
        return NO;
    }
}

/**
 *  格式化日期字符串
 *
 *  @param stringDate   日期字符串，如：2013-01-31 14:08:34
 *  @param oldFormatter 旧日期格式，如果为@""或nil时，默认为 @"yyyy/MM/dd HH:mm:ss"
 *  @param newFormatter 新日期格式，如果为@""或nil时，默认为 @"yyyy-MM-dd HH:mm:ss"
 *
 *  @return 格式化以后的日期字符串
 */
+ (NSString *)dateFormatter:(NSString *)stringDate oldFormatter:(NSString *)oldFormatter newFormatter:(NSString *)newFormatter{
    // 旧日期
    NSDateFormatter *oldDate = [[NSDateFormatter alloc] init];
    if ([oldFormatter isEqualToString:@""] || oldFormatter == nil) {
        [oldDate setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    }else{
        [oldDate setDateFormat:oldFormatter];
    }
    
    // 从字符串生成日期对象
    NSDate *date = [oldDate dateFromString: stringDate];
    
    // 新日期
    NSDateFormatter *newDate = [[NSDateFormatter alloc] init];
    
    if ([newFormatter isEqualToString:@""] || newFormatter == nil) {
        [newDate setDateFormat:@"yyyy-MM-dd"];
    }else{
        [newDate setDateFormat:newFormatter];
    }
    
    // 从日期对象生成字符串
    NSString *dateString = [newDate stringFromDate:date];
    
    NSString *result = [NSString stringWithFormat:@"%@", dateString];
    return result;
}

/**
 *  格式化时间字符
 *
 *  @param timeSeconds   为0时表示当前时间,可以传入你定义的时间戳
 *  @param timeFormatStr 为空返回当当时间戳,不为空返回你写的时间格式(yyyy-MM-dd HH:ii:ss)
 *  @param timeZoneStr   ([NSTimeZone systemTimeZone]获得当前时区字符串)
 *
 *  @return 格式化后的时间字符
 */
+(NSString *)setTimeInt:(NSTimeInterval)timeSeconds setTimeFormat:(NSString *)timeFormatStr setTimeZome:(NSString *)timeZoneStr{
    NSString *date_string;
    
    NSDate *time_str;
    if ( timeSeconds>0 ) {
        time_str = [NSDate dateWithTimeIntervalSince1970:timeSeconds];
    }else{
        time_str= [[NSDate alloc] init];
    }
    
    if ( timeFormatStr==nil) {
        date_string = [NSString stringWithFormat:@"%ld", (long)[time_str timeIntervalSince1970]];
    }else{
        NSDateFormatter *date_format_str = [[NSDateFormatter alloc] init];
        [date_format_str setDateFormat:timeFormatStr];
        if( timeZoneStr!=nil ){
            [date_format_str setTimeZone:[NSTimeZone timeZoneWithName:timeZoneStr]];
        }
        date_string = [date_format_str stringFromDate:time_str];
    }
    
    return date_string;
}

/**
 *  MD5
 *
 *  @return MD5 String
 */
- (NSString *)MD5Digest
{
    const char* input = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;
}

/*!
 *  解析查询字符串
 *
 *  @param query 查询字符串
 *
 *  @return NSDictionary
 */
+ (NSDictionary *)parseQueryString:(NSString *)query{
    // 定义字典
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    // 检测字符串中是否包含 ‘？’
    NSRange range = [query rangeOfString:@"?"];
    if(range.location != NSNotFound){
        NSArray *queryArr = [query componentsSeparatedByString:@"?"];
        [dict setObject:queryArr[0] forKey:@"url"];
        query = queryArr[1];
    }else{
        // 如果一个url连 '?' 都没有，那么肯定就没有参数
        return dict;
    }
    
    // 检测字符串中是否包含 ‘&’
    if([query rangeOfString:@"&"].location != NSNotFound){
        // 以 & 来分割字符，并放入数组中
        NSArray *pairs = [query componentsSeparatedByString:@"&"];
        // 遍历字符数组
        for (NSString *pair in pairs) {
            // 以等号来分割字符
            NSArray *elements = [pair componentsSeparatedByString:@"="];
            NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            // 添加到字典中
            [dict setObject:val forKey:key];
        }
    }else if([query rangeOfString:@"="].location != NSNotFound){ // 检测字符串中是否包含 ‘=’
        NSArray *elements = [query componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        // 添加到字典中
        [dict setObject:val forKey:key];
    }
    
    NSLog(@"dict -> %@", dict);
    return dict;
}

/**
 *  竖排字符串
 *
 *  @param str 需要竖排的字符
 *
 *  @return 排完后的字符串
 */
+ (NSString *)verticalString:(NSString *)str{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i<str.length ; i++) {
        NSString *str1 = [str substringWithRange:NSMakeRange(i, 1)];
        NSString *str2 = [str1 stringByAppendingString:@"\n"];
        
        [arr addObject:str2];
    }
    NSString *str3;
    for (int i = 0; i<arr.count - 1; i++) {
        if (i == 0) {
            str3 = [arr[i] stringByAppendingString:arr[i+1]];
        }else{
            str3 = [str3 stringByAppendingString:arr[i+1]];
        }
    }
    
    return str3;
}

/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

//获取学生ID
+ (NSNumber *)getUserID {
    return nil;
    //    SLHUserModel *model = [SLHUserModel share];
    //    return @(model.id);
}


/**
 *  获取未来某个日期是星期几
 *  注意：featureDate 传递过来的格式 必须 和 formatter.dateFormat 一致，否则endDate可能为nil
 *
 */
- (NSString *)featureWeekdayWithDate:(NSString *)featureDate{
    // 创建 格式 对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置 日期 格式 可以根据自己的需求 随时调整， 否则计算的结果可能为 nil
    formatter.dateFormat = @"yyyy-MM-dd";
    // 将字符串日期 转换为 NSDate 类型
    NSDate *endDate = [formatter dateFromString:featureDate];
    return  [self weekdayStringFromDate:endDate];
    
    // 判断当前日期 和 未来某个时刻日期 相差的天数
    long days = [self daysFromDate:[NSDate date] toDate:endDate];
    // 将总天数 换算为 以 周 计算（假如 相差10天，其实就是等于 相差 1周零3天，只需要取3天，更加方便计算）
    long day = days >= 7 ? days % 7 : days;
    long week = [self getNowWeekday] + day;
    //    switch (week) {
    //        case 1:
    //            return languageString(@"星期天");
    //            break;
    //        case 2:
    //            return languageString(@"星期一");
    //            break;
    //        case 3:
    //            return languageString(@"星期二");
    //            break;
    //        case 4:
    //            return languageString(@"星期三");
    //            break;
    //        case 5:
    //            return languageString(@"星期四");
    //            break;
    //        case 6:
    //            return languageString(@"星期五");
    //            break;
    //        case 7:
    //            return languageString(@"星期六");
    //            break;
    //
    //        default:
    //            break;
    //    }
    return nil;
}

- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    return nil;
    
    //    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], languageString(@"星期天"),languageString(@"星期一"),languageString(@"星期二"), languageString(@"星期三"),languageString(@"星期四"), languageString(@"星期五"), languageString(@"星期六"), nil];
    //
    //    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //
    //    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    //
    //    [calendar setTimeZone: timeZone];
    //
    //    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    //
    //    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    //
    //    return [weekdays objectAtIndex:theComponents.weekday];
    
}

-(NSInteger)daysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    // 话说在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //得到相差秒数
    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    int days = ((int)time)/(3600*24);
    int hours = ((int)time)%(3600*24)/3600;
    int minute = ((int)time)%(3600*24)/3600/60;
    if (days <= 0 && hours <= 0&&minute<= 0) {
        NSLog(@"0天0小时0分钟");
        return 0;
    }
    else {
        NSLog(@"%@",[[NSString alloc] initWithFormat:@"%i天%i小时%i分钟",days,hours,minute]);
        // 之所以要 + 1，是因为 此处的days 计算的结果 不包含当天 和 最后一天\
        （如星期一 和 星期四，计算机 算的结果就是2天（星期二和星期三），日常算，星期一——星期四相差3天，所以需要+1）\
        对于时分 没有进行计算 可以忽略不计
        return days + 1;
    }
}

// 获取当前是星期几
- (NSInteger)getNowWeekday {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDate *now = [NSDate date];
    // 话说在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    comps = [calendar components:unitFlags fromDate:now];
    return [comps weekday];
}

+ (NSString *)hexStringFromString:(NSString *)string {
    
    //    NSString *str = [DES3Util DESEncrypt:string];
    //
    //    NSData *myD = [str dataUsingEncoding:NSUTF8StringEncoding];
    //    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    
    //    NSString *strf = @"%";
    //
    //    for(int i=0;i<[myD length];i++) {
    //        NSString *newHexStr = [NSString stringWithFormat:@"%@%x",strf,bytes[i]&0xff];///16进制数
    //
    //        if([newHexStr length]==1)
    //
    //            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
    //        else
    //            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    //    }
    return hexStr;
}


//  从字符串中取出数字
+ (NSString *)getOnlyNum:(NSString *)str {
    
    NSString *onlyNumStr = [str stringByReplacingOccurrencesOfString:@"[^0-9,]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [str length])];
    //    NSArray *numArr = [onlyNumStr componentsSeparatedByString:@","];
    return onlyNumStr;
}



/**
 *  时间戳转时间
 *
 *  @param timsp 时间戳
 *
 *  @return 标准时间
 */
+ (NSString *)transToTime:(NSString *)timsp {
    
    NSTimeInterval time=[timsp doubleValue];//如果不使用本地时区,因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];//设置本地时区
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}

//隐藏手机号码的中间四位
+(NSString *)handlePhoneNumber:(NSString *)number
{
    NSString *first = @"";
    NSString *last = @"";
    if (number != nil)
    {
        first = [[number substringFromIndex:0]substringToIndex:3];
        last = [[number substringFromIndex:7]substringToIndex:4];
        number = [NSString stringWithFormat:@"%@****%@",first,last];
    }
    return number;
}

/*
 * 手机号是否输入正确
 */
+ (BOOL)phoneNumberIsTrue:(NSString*)phoneNmuber {
    if ([phoneNmuber length] == 0) {
        return NO;
    }else{
        NSString *regex = @"^((13[0-9])|(147)|(17[0-9])|(15[^4,\\D])|(18[0|1|2|3,5-9]))\\d{8}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isMatch = [pred evaluateWithObject:phoneNmuber];
        if (!isMatch) {
            return NO;
        }
        return YES;
    }
}

//判断字符串是否为空
- (BOOL)isEmpty {
    if ([[self class] isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (self.length == 0) {
        return YES;
    }
    if ([[NSString stringWithFormat:@"%@",self] isEqualToString:@"<null>"]) {
        return YES;
    }
    
    if ([[NSString stringWithFormat:@"%@",self] isEqualToString:@"<nil>"]) {
        return YES;
    }
    return NO;
}
@end
