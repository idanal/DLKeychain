//
//  DLKeychain.m
//  DLKeychain
//
//  Created by danal.Luo on 12/16/14.
//  Copyright (c) 2014 danal. All rights reserved.
//

#import "DLKeychain.h"

#if !__has_feature(objc_arc)
#error -ARC supports needed
#endif

#define __CFB __bridge const void *
#define __NSB __bridge_transfer id

static NSString * DL_LABEL  = @"DLKeychain";

OSStatus status;    //SecBase.h

@implementation DLKeychain

+ (NSMutableDictionary *)createQuery:(NSString *)identifier{
    NSMutableDictionary *query = [NSMutableDictionary dictionary];
    query[(__NSB)kSecClass] = (__NSB)kSecClassGenericPassword;
    query[(__NSB)kSecAttrLabel] = DL_LABEL;
    //Both kSecAttrService and kSecAttrAccount identify a unique item
    //Ref:http://useyourloaf.com/blog/2010/04/28/keychain-duplicate-item-when-adding-password.html
    query[(__NSB)kSecAttrService] = [NSBundle mainBundle].bundleIdentifier;
    query[(__NSB)kSecAttrAccount] = identifier;
    
    return query;
}

+ (BOOL)updateItem:(NSString *)value forKey:(NSString *)key{
    NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *query = [self createQuery:key];
    query[(__NSB)kSecValueData] = data;
    
    NSMutableDictionary *update = [query mutableCopy];
    
    //For searching
    query[(__NSB)kSecMatchLimit] = (__NSB)kSecMatchLimitOne;
    
    CFTypeRef result = NULL;
    status =  SecItemCopyMatching((__CFB)query, &result);
    if (status == errSecSuccess){   //Exists,Update it
        NSDictionary *attribs = @{(__NSB)kSecValueData:data};
        status = SecItemUpdate((__CFB)update, (__CFB)attribs);
    } else {    //Add
        [query removeObjectForKey:(__NSB)kSecMatchLimit];
        status = SecItemAdd((__CFB)query, NULL);
    }

    return status == errSecSuccess;
}

+ (id)readItem:(NSString *)key{
    NSMutableDictionary *query = [self createQuery:key];
    query[(__NSB)kSecReturnData] = (__NSB)kCFBooleanTrue;
    query[(__NSB)kSecMatchLimit] = (__NSB)kSecMatchLimitOne;
    
    CFTypeRef result;
    status = SecItemCopyMatching((__CFB)query, &result);
    if (status == errSecSuccess){
        NSData *d = (__NSB)result;
        return [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    } else {
        return nil;
    }
}

+ (BOOL)deleteItem:(NSString *)key{
    NSMutableDictionary *query = [self createQuery:key];
    status =  SecItemDelete((__CFB)query);
    if (status == errSecSuccess){
        return YES;
    }
    return NO;
}

+ (NSArray *)all {
    NSMutableDictionary *query = [@{
                                    (__bridge id)kSecClass:(__bridge id)kSecClassGenericPassword,
                                    } mutableCopy];
    [query setObject:@YES forKey:(__bridge id)kSecReturnAttributes];
    [query setObject:(__bridge id)kSecMatchLimitAll forKey:(__bridge id)kSecMatchLimit];
    
    CFTypeRef result = NULL;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    if (status != errSecSuccess) {
        return nil;
    }
    return (__bridge_transfer NSArray *)result;
}

+ (NSString *)errMsg:(OSStatus)errCode{
    NSString *msg = @"Unknown error";
    switch (errCode) {
        case errSecSuccess:
            msg = @"Suceess";
            break;
        case errSecParam:
            msg = @"errSecParam";
            break;
        case errSecDuplicateItem:
            msg = @"errSecDuplicateItem";
            break;
        case errSecItemNotFound:
            msg = @"errSecItemNotFound";
            break;
        case errSecDecode:
            msg = @"errSecDecode";
            break;
        case errSecUserCanceled:
            msg = @"errSecUserCanceled";
            break;
        default:
            break;
    }
    return [NSString stringWithFormat:@"Err %@: %@",@(errCode), msg];
}

+ (NSString *)errMsg{
    return [self errMsg:status];
}

@end

