//
//  DLKeychain.h
//  DLKeychain
//
//  Created by danal.Luo on 12/16/14.
//  Copyright (c) 2014 danal. All rights reserved.
//
//  QQ:290994669
//
//  DLKeychain is an easy way to access the keychain on iOS
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>


@interface DLKeychain : NSObject

/** 
 * Add or Update an item
 * @param value A string object
 * @param key A string identifier
 * @return Yes on success
 */
+ (BOOL)updateItem:(NSString *)value forKey:(NSString *)key;

/** Read an item */
+ (id)readItem:(NSString *)key;

/** Delete an item */
+ (BOOL)deleteItem:(NSString *)key;

/** Translate a error code */
+ (NSString *)errMsg:(OSStatus)errCode;

/** Last error msg */
+ (NSString *)errMsg;

/** All keychain items */
+ (NSArray *)all;

@end
