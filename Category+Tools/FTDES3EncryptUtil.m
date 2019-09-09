//
//  DES3EncryptUtil.m
//  FTTemplate
//
//  Created by sc on 2019/5/5.
//  Copyright © 2019年 史超. All rights reserved.
//

#import "FTDES3EncryptUtil.h"

#import <CommonCrypto/CommonCryptor.h>
#import "FTBase64.h"

//秘钥
#define gkey            @"AVQC7SDIUK312ZZEZ1HTQNJN"
//向量
#define gIv             @"\01\02\03\04\05\06\07\08"

@implementation FTDES3EncryptUtil

// 加密方法
+ (NSString*)encrypt:(NSString*)plainText {
    return [FTDES3EncryptUtil encrypt:plainText key:gkey giv:gIv];
}

// 加密方法
+ (NSString*)encrypt:(NSString*)plainText key:(NSString *)key giv:(NSString *)giv {
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    size_t plainTextBufferSize = [data length];
    const void *vplainText = (const void *)[data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [key UTF8String];
    const void *vinitVec = (const void *) [giv UTF8String];
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    NSString *result = [FTBase64 base64EncodedStringFrom:myData];
    return result;
}
// 解密方法
+ (NSString*)decrypt:(NSString*)encryptText {
    return [FTDES3EncryptUtil decrypt:encryptText key:gkey giv:gIv];
}
// 解密方法
+ (NSString*)decrypt:(NSString*)encryptText key:(NSString *)key giv:(NSString *)giv {
    NSData *encryptData = [FTBase64 dataWithBase64EncodedString:encryptText];
    size_t plainTextBufferSize = [encryptData length];
    const void *vplainText = [encryptData bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [key UTF8String];
    const void *vinitVec = (const void *) [giv UTF8String];
    
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                     length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding] ;
    return result;
}


/**
 encryptOrDecrypt ：  kCCEncrypt加密 kCCDecrypt解密
 plainText ：原始字符串
 key    加密秘钥：AVQC7SDIUK312ZZEZ1HTQNJN
 giv    加密向量
 */
+ (NSString *)DESString:(CCOperation)encryptOrDecrypt plainText:(NSString *)plainText key:(NSString *)key giv:(NSString *)giv {
    if (plainText == nil || key == nil || gIv == nil) {
        return nil;
    }
    if (encryptOrDecrypt == kCCEncrypt) {//加密
        return [FTDES3EncryptUtil encrypt:plainText key:key giv:giv];
    }else if (encryptOrDecrypt == kCCDecrypt) {//解密
        return [FTDES3EncryptUtil decrypt:plainText];
    }
    
    return nil;
}

@end
