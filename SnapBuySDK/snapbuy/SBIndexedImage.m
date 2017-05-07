//
//  SBIndexedImage.m
//  snapBuyTest
//
//  Created by mohamed ahmed on 5/3/17.
//  Copyright © 2017 mohamed.elzokla. All rights reserved.
//

#import "SBIndexedImage.h"
#import "SBIndexedImage+private.h"
@implementation SBIndexedImage

-(NSDictionary *)convertToDict{
    NSMutableDictionary * dict = [NSMutableDictionary new];
    if (_imageURL) {
        [dict setObject:_imageURL forKey:@"imageURL"];
    }
    if (_image) {
        [dict setObject:_image forKey:@"image"];
    }
    if (_c1) {
        [dict setObject:_c1 forKey:@"c1"];
    }
    if (_c2) {
        [dict setObject:_c2 forKey:@"c2"];
    }
    if (_c3) {
        [dict setObject:_c3 forKey:@"c3"];
    }
    if (_c4) {
        [dict setObject:_c4 forKey:@"c4"];
    }
    if (_c5) {
        [dict setObject:_c5 forKey:@"c5"];
    }
    if (_metadata) {
        [dict setObject:_metadata forKey:@"metadata"];
    }
    if (_title) {
        [dict setObject:_title forKey:@"title"];
    }
    if (_title) {
        [dict setObject:_title forKey:@"title"];
    }
    if (_imageDescription) {
        [dict setObject:_imageDescription forKey:@"description"];
    }
    if (_price) {
        [dict setObject:_price forKey:@"price"];
    } if (_itemUrl) {
        [dict setObject:_itemUrl forKey:@"url"];
    } if (_currency) {
        [dict setObject:_currency forKey:@"currency"];
    } if (_passive) {
        [dict setObject:[NSNumber numberWithBool:_passive] forKey:@"passive"];
    }
    

    return dict;
}
@end
