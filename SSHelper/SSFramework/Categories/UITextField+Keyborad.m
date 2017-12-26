//
//  UITextField+Keyborad.m
//  JHTDoctor
//
//  Created by yangsq on 16/7/19.
//  Copyright © 2016年 yangsq. All rights reserved.
//

#import "UITextField+Keyborad.h"
#import <objc/runtime.h>
#import "Categorise.h"


static const void *UITextFieldOriginalDelegateKey                           = &UITextFieldOriginalDelegateKey;

static const void *CustomKeyBoardTypeKey                                    = &CustomKeyBoardTypeKey;
static const void *MaxWordNumKey                                            = &MaxWordNumKey;
static const void *MaxNumberKey                                             = &MaxNumberKey;
static const void *MinNumberKey                                             = &MinNumberKey;
static const void *DidChangeTextFieldKey                                    = &DidChangeTextFieldKey;
static const void *WillChangeTextFieldKey                                   = &WillChangeTextFieldKey;
static const void *BeginEditTextFieldKey                                    = &BeginEditTextFieldKey;
static const void *EndEditTextFieldKey                                      = &EndEditTextFieldKey;


@implementation UITextField (Keyborad)



- (void)addNotification{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:self];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textBeginEdit:) name:UITextFieldTextDidBeginEditingNotification object:self];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textEndEdit:) name:UITextFieldTextDidEndEditingNotification object:self];
    
}



- (void)textEndEdit:(NSNotification *)notification{
    
    
    UITextField *textfield = (UITextField *)notification.object;

    if ((self.customKeyBoardType == KeyBoardType_OnlyNumber_Type||self.customKeyBoardType == KeyBoardType_NumberDecimal_Type)&&![textfield.text isEqualToString:@""]) {
        if ([textfield.text floatValue]<self.minNumber) {
            if (self.customKeyBoardType == KeyBoardType_OnlyNumber_Type) {
                textfield.text = [NSString stringWithFormat:@"%ld",(NSInteger)self.minNumber];
            }else{
                textfield.text = [NSString stringWithFormat:@"%.2f",self.minNumber];
            }
            
            if (self.didChange) {
                self.didChange(textfield);
            }
        }
        
        
    }
    
    if (self.endEdit) {
        self.endEdit(textfield);
    }
    
}

- (void)textDidChange:(NSNotification *)notification{
    
    UITextField *textfield = (UITextField *)notification.object;
    if ([textfield.text length]>self.maxWordNum&&self.maxWordNum&&!textfield.markedTextRange) {
        
        textfield.text = [textfield.text substringToIndex:self.maxWordNum];
    }
    
    if (self.didChange) {
        self.didChange(textfield);
    }
    
   
}

- (void)textBeginEdit:(NSNotification *)notification{
    
    UITextField *textfield = (UITextField *)notification.object;

    if (self.beginEdit) {
        self.beginEdit(textfield);
    }
    
    
}


- (void)didChange:(DidChangeTextField)block{
    self.didChange = block;
}

- (void)willChange:(DidChangeTextField)block{
    self.willChange = block;
}
- (void)beginEdit:(BeginEditTextField)block{
    [self addNotification];

    self.beginEdit = block;
    
}

- (void)endEdit:(EndEditTextField)block{
    self.endEdit = block;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    
    
    
    if ([aString isEqualToString:@" "]||[aString isEqualToString:@"\n"]) {
        
        return NO;
    }
    
    
    CustomKeyboradType cutomtype = [objc_getAssociatedObject(self, CustomKeyBoardTypeKey)integerValue];
    
    if (cutomtype == KeyBoardType_CMW_Type) {
        if (!([NSString validateCMWString:string]||[string isEqualToString:@""])) {
            return NO;
        }
    }
    
    if (cutomtype == KeyBoardType_NumberDecimal_Type) {
        
        
        if ([aString isEqualToString:@"."]) {
            
            return NO;
        }
        if (![NSString validateNumberAndPoint:aString]) {
            
            return NO;
        }
        
        if ([textField.text containsString:@"."]&&[string isEqualToString:@"."]) {
            return NO;
        }
        
    
        if ([textField.text containsString:@"."]) {
            NSRange aRange = [aString rangeOfString:@"."];
            //只能输入小数点后两位
            if (range.location >aRange.location+2) {
                return NO;
            }
        }
        
        
        if (![aString isEqualToString:@""]&&(([aString floatValue]>self.maxNumber&&self.maxNumber!=0))) {
            if (self.willChange) {
                self.willChange(textField);
            }
            return NO;
        }

    }
    
    if (cutomtype == KeyBoardType_OnlyNumber_Type) {
        
        if (![NSString validateNumber:aString]) {
            
            return NO;
        }
        if (![aString isEqualToString:@""]&&(([aString integerValue]>self.maxNumber&&self.maxNumber!=0))) {
            if (self.willChange) {
                self.willChange(textField);
            }
            return NO;
        }
        
    }
    
    
    if ([aString length]>self.maxWordNum&&self.maxWordNum) {
        
        return NO;
        
    }
    
    
    //
    id OriginalDelegate = objc_getAssociatedObject(self, UITextFieldOriginalDelegateKey);
    if (OriginalDelegate && [OriginalDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        [OriginalDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    
    return YES;
}


- (NSInteger)returnLengthFromIntegerNum:(NSInteger)number{
    
    return [NSString stringWithFormat:@"%ld",number].length;
}

- (NSInteger)returnLengthFromFlodNum:(float)number{
    
    return [NSString stringWithFormat:@"%.2f",number].length;
}

- (void)_checkUITextFieldDelegate {
    if (self.delegate != (id<UITextFieldDelegate>)self) {
        objc_setAssociatedObject(self, UITextFieldOriginalDelegateKey, self.delegate, OBJC_ASSOCIATION_ASSIGN);
        self.delegate = (id<UITextFieldDelegate>)self;
    }
}

- (void)setCustomKeyBoardType:(CustomKeyboradType )customKeyBoardType{
    [self _checkUITextFieldDelegate];
    objc_setAssociatedObject(self, CustomKeyBoardTypeKey, @(customKeyBoardType), OBJC_ASSOCIATION_RETAIN);
}

- (CustomKeyboradType)customKeyBoardType{
    [self _checkUITextFieldDelegate];
     return [objc_getAssociatedObject(self, CustomKeyBoardTypeKey) intValue];
}

- (void)setMaxWordNum:(NSInteger)maxWordNum{
    [self addNotification];
    [self _checkUITextFieldDelegate];
    objc_setAssociatedObject(self, MaxWordNumKey, @(maxWordNum), OBJC_ASSOCIATION_RETAIN);
}

- (NSInteger)maxWordNum{
    [self addNotification];
    [self _checkUITextFieldDelegate];
    return [objc_getAssociatedObject(self, MaxWordNumKey) intValue];
}


- (void)setMaxNumber:(float)maxNumber{
    [self _checkUITextFieldDelegate];
    
    objc_setAssociatedObject(self, MaxNumberKey, @(maxNumber), OBJC_ASSOCIATION_RETAIN);

}
- (float)maxNumber{
    [self _checkUITextFieldDelegate];
    return [objc_getAssociatedObject(self, MaxNumberKey) floatValue];
}
- (void)setMinNumber:(float)minNumber{
    [self _checkUITextFieldDelegate];
    
    objc_setAssociatedObject(self, MinNumberKey, @(minNumber), OBJC_ASSOCIATION_RETAIN);
    
}
- (float)minNumber{
    [self _checkUITextFieldDelegate];
    return [objc_getAssociatedObject(self, MinNumberKey) floatValue];
}

- (void)setDidChange:(DidChangeTextField)didChange{
    [self _checkUITextFieldDelegate];
    objc_setAssociatedObject(self, DidChangeTextFieldKey,didChange, OBJC_ASSOCIATION_COPY);

}
- (DidChangeTextField)didChange{
    [self _checkUITextFieldDelegate];
    return objc_getAssociatedObject(self, DidChangeTextFieldKey);

}

- (void)setWillChange:(WillChangeTextField)willChange{
    [self _checkUITextFieldDelegate];
    objc_setAssociatedObject(self, WillChangeTextFieldKey,willChange, OBJC_ASSOCIATION_COPY);

}

- (WillChangeTextField)willChange{
    [self _checkUITextFieldDelegate];
    return objc_getAssociatedObject(self, WillChangeTextFieldKey);

}

- (void)setBeginEdit:(BeginEditTextField)beginEdit{
    [self _checkUITextFieldDelegate];
    objc_setAssociatedObject(self, BeginEditTextFieldKey,beginEdit, OBJC_ASSOCIATION_COPY);
    
}

- (BeginEditTextField)beginEdit{
    [self _checkUITextFieldDelegate];
    return objc_getAssociatedObject(self, BeginEditTextFieldKey);
    
}



- (EndEditTextField)endEdit{
    [self _checkUITextFieldDelegate];
    return objc_getAssociatedObject(self, EndEditTextFieldKey);
}

- (void)setEndEdit:(EndEditTextField)endEdit{
    objc_setAssociatedObject(self, EndEditTextFieldKey,endEdit, OBJC_ASSOCIATION_COPY);

}

@end
