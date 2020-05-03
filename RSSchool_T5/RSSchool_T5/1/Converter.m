#import "Converter.h"

// Do not change
NSString *KeyPhoneNumber = @"phoneNumber";
NSString *KeyCountry = @"country";

@implementation PNConverter
- (NSDictionary*)converToPhoneNumberNextString:(NSString*)string; {
    NSMutableString *inputNumber = [NSMutableString stringWithString: string];

    if ([inputNumber characterAtIndex: 0] == '+') {
        [inputNumber replaceCharactersInRange: NSMakeRange(0, 1) withString: @""];
    }

    if (inputNumber.length > 12) {
        [inputNumber deleteCharactersInRange: NSMakeRange(12, inputNumber.length - 12)];
    }

    NSString *countryCode = @"";
    
    NSDictionary *codesDict = @{
        @"7" : @[@"RU", @"x (xxx) xxx-xx-xx", @11],
        @"77" : @[@"KZ", @"x (xxx) xxx-xx-xx", @11],
        @"373" : @[@"MD", @"xxx (xx) xxx-xxx", @11],
        @"374" : @[@"AM", @"xxx (xx) xxx-xxx", @11],
        @"375" : @[@"BY", @"xxx (xx) xxx-xx-xx", @12],
        @"380" : @[@"UA", @"xxx (xx) xxx-xx-xx", @12],
        @"992" : @[@"TJ", @"xxx (xx) xxx-xx-xx", @12],
        @"993" : @[@"TM", @"xxx (xx) xxx-xxx", @11],
        @"994" : @[@"AZ", @"xxx (xx) xxx-xx-xx", @12],
        @"996" : @[@"KG", @"xxx (xx) xxx-xx-xx", @12],
        @"998" : @[@"UZ", @"xxx (xx) xxx-xx-xx", @12]
    };
    NSArray *codes = [codesDict allKeys];

    NSSortDescriptor *sortDescriptor= [[NSSortDescriptor alloc] initWithKey: @"length" ascending: NO];
    codes = [codes sortedArrayUsingDescriptors: @[sortDescriptor]];

    for (NSString *code in codes) {
        if (code.length <= inputNumber.length && [code isEqualToString: [inputNumber substringWithRange: NSMakeRange(0, code.length)]]) {
            countryCode = code;
            break;
        }
    }
    
    if (!countryCode.length) {
        [inputNumber insertString: @"+" atIndex:0];
        return @{KeyPhoneNumber: inputNumber, KeyCountry: @""};
    }
    
    NSArray *countryInfo = [codesDict objectForKey: countryCode];
    NSString *country = [NSString stringWithString: [countryInfo objectAtIndex: 0]];
    NSString *numberMask = [NSString stringWithString: [countryInfo objectAtIndex: 1]];
    int maxLength = [[countryInfo objectAtIndex: 2] intValue];

    NSMutableString *result = [NSMutableString stringWithString: @"+"];

    int maskCounter = 0;
    long count = inputNumber.length > maxLength ? maxLength : inputNumber.length;
    for (int i = 0; i < count; i++) {
        NSString *character = [NSString stringWithString: [inputNumber substringWithRange: NSMakeRange(i, 1)]];
        NSString *maskCharacter = [numberMask substringWithRange: NSMakeRange(maskCounter, 1)];
        maskCounter += 1;
        if (![maskCharacter isEqualToString: @"x"]) {
            character = maskCharacter;
            i -= 1;
        }
        [result insertString: character atIndex: result.length];
    }

    return @{KeyPhoneNumber: result, KeyCountry: country};
}
@end
