//
//  LuketMediaResource.m
//  Luket
//

#import "LuketMediaResource.h"

static NSString * const LuketMediaBaseURLString = @"https://xnisk.chavytogo.com/file/luket/";

@implementation LuketMediaResource

+ (nullable UIImage *)localImageWithIdentifier:(nullable NSString *)identifier {
    if (identifier.length == 0) {
        return nil;
    }

    UIImage *image = [UIImage imageNamed:identifier];
    if (image) {
        return image;
    }

    NSURL *fileURL = nil;
    NSString *trimmedIdentifier = [identifier stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    if ([trimmedIdentifier hasPrefix:@"file://"]) {
        fileURL = [NSURL URLWithString:trimmedIdentifier];
    } else if ([trimmedIdentifier hasPrefix:@"/"]) {
        fileURL = [NSURL fileURLWithPath:trimmedIdentifier];
    }
    if (fileURL.isFileURL && fileURL.path.length > 0) {
        image = [UIImage imageWithContentsOfFile:fileURL.path];
        if (image) {
            return image;
        }
    }

    NSString *imageNameWithoutExtension = identifier.stringByDeletingPathExtension;
    if (imageNameWithoutExtension.length > 0 && ![imageNameWithoutExtension isEqualToString:identifier]) {
        image = [UIImage imageNamed:imageNameWithoutExtension];
        if (image) {
            return image;
        }
    }

    NSString *bundlePath = [NSBundle.mainBundle pathForResource:identifier ofType:nil];
    if (!bundlePath && identifier.lastPathComponent.length > 0) {
        bundlePath = [NSBundle.mainBundle pathForResource:identifier.lastPathComponent ofType:nil];
    }
    return bundlePath.length > 0 ? [UIImage imageWithContentsOfFile:bundlePath] : nil;
}

+ (nullable NSURL *)resourceURLWithIdentifier:(nullable NSString *)identifier {
    NSString *trimmedIdentifier = [identifier stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    if (trimmedIdentifier.length == 0) {
        return nil;
    }

    if ([trimmedIdentifier hasPrefix:@"http://"] || [trimmedIdentifier hasPrefix:@"https://"]) {
        return [NSURL URLWithString:trimmedIdentifier];
    }

    NSString *fileName = trimmedIdentifier.lastPathComponent.length > 0 ? trimmedIdentifier.lastPathComponent : trimmedIdentifier;
    NSString *encodedFileName = [fileName stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLPathAllowedCharacterSet];
    if (encodedFileName.length == 0) {
        return nil;
    }
    return [NSURL URLWithString:[LuketMediaBaseURLString stringByAppendingString:encodedFileName]];
}

+ (nullable NSURL *)imageURLWithIdentifier:(nullable NSString *)identifier {
    return [self resourceURLWithIdentifier:identifier];
}

@end
