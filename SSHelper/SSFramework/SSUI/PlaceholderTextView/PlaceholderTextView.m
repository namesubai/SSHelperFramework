//
//  PlaceholderTextView.m
//  imssee
//
//  Created by subai on 16/1/8.
//  Copyright © 2016年 鑫易. All rights reserved.
//

#import "PlaceholderTextView.h"
#import "SSHelperDefine.h"
#import "Categorise.h"
@interface PlaceholderTextView ()<UITextViewDelegate>

@property (strong, nonatomic) NSString *currentText;
@end


@implementation PlaceholderTextView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addObserver];
        [self setView];
         self.delegate = self;
    }
    return self;
}
//-(id)initWithCoder:(NSCoder *)aDecoder{
//    self = [super initWithCoder:aDecoder];
//
//    if (self) {
//        [self addObserver];
//        [self setView];
//   self.delegate = self;
//
//    }
//    return self;
//}
//-(id)init{
//    self = [super init];
//    if (self) {
//        
//        [self addObserver];
//        [self setView];
//        self.delegate = self;
//
//    }
//    return self;
//}
-(void)setView{
    if (!self.placeholderLabel) {
        self.placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, self.frame.size.width, self.frame.size.height)];
        self.placeholderLabel.textColor = Color_Text_Detail;
        self.placeholderLabel.numberOfLines = 0;
        self.placeholderLabel.font = [self font];
        [self addSubview:self.placeholderLabel];
        

    }
    
    if (!self.wordNumLabel) {
        
        self.wordNumLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.wordNumLabel.font = [UIFont systemFontOfSize:13];
        self.wordNumLabel.textColor = Color_Text_Detail;
        self.wordNumLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.wordNumLabel];
        

    }
   
}

-(void)layoutSubviews{
    self.placeholderLabel.frame = CGRectMake(8, 6.5, self.frame.size.width-8, self.frame.size.height);
    [self.placeholderLabel sizeToFit];
    [self.wordNumLabel sizeToFit];
    [self refreshFram];
}
-(void)addObserver
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextViewTextDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextViewTextDidEndEditingNotification object:self];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(placeholderTextViewdidChange:) name:UITextViewTextDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(placeholderTextViewEndEditing) name:UITextViewTextDidEndEditingNotification object:self];
   

}

- (void)UIKeyboardWillShow:(NSNotification *)notif{
    CGSize keySize = [[notif.userInfo objectForKey:UIKeyboardBoundsUserInfoKey]CGRectValue ].size;
    if ([_adelegate respondsToSelector:@selector(keyboardWillShow:size:)]) {
        
        [_adelegate keyboardWillShow:self size:keySize];
    }
}
- (void)UIKeyboardWillHide:(NSNotification *)notif{
    if ([_adelegate respondsToSelector:@selector(keyboarWillHide:)]) {
        
        [_adelegate keyboarWillHide:self];
    }
}
-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.placeholderLabel.text = _placeholder;
    [self.placeholderLabel sizeToFit];
    [self endEditing:NO];
}
-(void)setMaxLength:(NSInteger)maxLength{
    
    _maxLength = maxLength;
    self.wordNumLabel.text = [NSString stringWithFormat:@"0/%ld",(long)_maxLength];
    
}
-(void)placeholderTextViewdidChange:(NSNotification *)notificat{
    
    PlaceholderTextView *textView = (PlaceholderTextView *)notificat.object;
    NSLog(@"%@",textView.text);

    if ([self.text length]>0) {
        [self.placeholderLabel setHidden:YES];
    }else{
        [self.placeholderLabel setHidden:NO];

    }
    
    if ([textView.text length]>self.maxLength&&self.maxLength!=0&&textView.markedTextRange == nil) {
        
       
        textView.text = [textView.text substringToIndex:self.maxLength];
     
    }
    
    if (_textcustomType == TextView_KeyBoardType_OnlyNumber_Type) {
        
        if (![NSString validateNumber:textView.text]) {
            
            textView.text = _currentText;
        }
       
       
        
    }
    
    if (_textcustomType == TextView_KeyBoardType_NumberDecimal_Type) {
        if ([textView.text isEqualToString:@"."]) {
            
            textView.text = _currentText;

        }
        if (![NSString validateNumberAndPoint:textView.text]) {
            
            textView.text = _currentText;

        }
        if ([textView.text containsString:@"."]&&[textView.text isEqualToString:@"."]) {
            textView.text = _currentText;

        }
        
        if ([textView.text containsString:@"."]) {
            NSRange aRange = [textView.text rangeOfString:@"."];
            //只能输入小数点后两位
            if (aRange.location >aRange.location+2) {
                textView.text = _currentText;

            }
        }
        
        NSArray *arr = [textView.text componentsSeparatedByString:@"."];
        
        NSString *str1,*str2;
        if (arr.count==2) {
            str1 = arr[0];
            str2 = arr[1];
        }else{
            str1 = textView.text;
        }
        
 
        
        
    }
    
    
    self.wordNumLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)[textView.text length],(long)_maxLength];
    if (self.didChangeText) {
        self.didChangeText(textView);
    }

    [self refreshFram];
    _currentText = textView.text;

}


- (void)didChangeText:(void (^)(PlaceholderTextView *))block{
    self.didChangeText = block;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    
    if ([text isEqualToString:@"\n"]) {
        
        [self resignFirstResponder];
        return NO;
    }
    NSString *aString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    
    if (_textcustomType == TextView_KeyBoardType_CMW_Type) {
        if (!([NSString validateCMWString:text]||[text isEqualToString:@""])) {
            return NO;
        }
    }
    
    if (_textcustomType == TextView_KeyBoardType_CMW_PUNCTUATION) {
        if (!([NSString validateCMW_PunctuationString:text]||[text isEqualToString:@""])) {
            return NO;
        }
    }
    
    
    if ([aString length]>self.maxLength&&self.maxLength!=0&&textView.markedTextRange == nil) {
        
        textView.text = [aString substringToIndex:self.maxLength];
        if (self.didChangeText) {
            self.didChangeText((PlaceholderTextView *)textView);
        }

        return NO;

    }else{
        
        self.wordNumLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)[aString length],(long)_maxLength];
        
       
        if (aString.length>0) {
            [self.placeholderLabel setHidden:YES];
        }else{
            [self.placeholderLabel setHidden:NO];
            
        }
        [self refreshFram];

    }
    if (self.didChangeText) {
        self.didChangeText((PlaceholderTextView *)textView);
    }
 
    return YES;

}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([_adelegate respondsToSelector:@selector(textViewBeginEdit:)]) {
        
        [_adelegate textViewBeginEdit:self];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([_adelegate respondsToSelector:@selector(textViewEndEdit:)]) {
        
        [_adelegate textViewBeginEdit:self];
    }
}


- (void)setText:(NSString *)text{
    [super setText:text];
    if (text.length>0) {
        [self.placeholderLabel setHidden:YES];
        self.wordNumLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)[text length],(long)_maxLength];
        [self.wordNumLabel sizeToFit];
        [self refreshFram];
      
    }
}


-(void)placeholderTextViewEndEditing{
    
    if ([self.text length]>0) {
        [self.placeholderLabel setHidden:YES];
    }else{
        [self.placeholderLabel setHidden:NO];
        
    }
}

- (void)refreshFram{
    [self.wordNumLabel sizeToFit];
    
//    CGSize size = [self sizeThatFits:CGSizeMake(self.frame.size.width, MAXFLOAT)];
    
    if (self.contentSize.height>self.frame.size.height-self.wordNumLabel.frame.size.height-5) {
        self.wordNumLabel.frame = CGRectMake(self.frame.size.width - self.wordNumLabel.frame.size.width-5, self.contentSize.height+self.contentInset.bottom-self.wordNumLabel.frame.size.height-5, self.wordNumLabel.frame.size.width, self.wordNumLabel.frame.size.height);
        
        self.contentInset = UIEdgeInsetsMake(0, 0, self.wordNumLabel.frame.size.height, 0);
        
    }else{
        self.wordNumLabel.frame = CGRectMake(self.frame.size.width - self.wordNumLabel.frame.size.width-5, self.frame.size.height + self.contentInset.bottom-self.wordNumLabel.frame.size.height-5, self.wordNumLabel.frame.size.width, self.wordNumLabel.frame.size.height);
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);

    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];  
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
