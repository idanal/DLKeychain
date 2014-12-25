DLKeychain
==========

DLKeychain is an easy way to access the keychain on iOS

Usage example:

    NSString *key = @"dlkey123";
    NSString *val = @"dlval123";
    NSString *key2 = @"dlkey456";
    NSString *val2 = @"dlval456";
    NSString *key3 = @"dlkey789";
    NSString *val3 = @"dlval789";

    [DLKeychain deleteItem:key];
    [DLKeychain deleteItem:key2];
    [DLKeychain deleteItem:key3];
    
    [DLKeychain updateItem:val forKey:key];
    [DLKeychain updateItem:val2 forKey:key2];
    [DLKeychain updateItem:val3 forKey:key3];
    
    NSLog(@"val=%@,%@,%@",
          [DLKeychain readItem:key],
          [DLKeychain readItem:key2],
          [DLKeychain readItem:key3]
          );
    NSLog(@"%@",[self all]);
    
