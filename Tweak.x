- (void)addGemsAction {
    @try {
        Class profileClass = NSClassFromString(@"Profile");
        if (profileClass) {
            SEL mainSelector = NSSelectorFromString(@"main");
            
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            
            id mainProfile = [profileClass performSelector:mainSelector];
            
            if (mainProfile) {
                // 1. الطريقة الأولى: استخدام valueForKey و setValue (الأكثر استقراراً)
                int currentGems = [[mainProfile valueForKey:@"gems"] intValue];
                int newGems = currentGems + 50000; // نزيد 50 ألف دفعة وحدة
                [mainProfile setValue:@(newGems) forKey:@"gems"];
                
                // 2. الطريقة الثانية: مناداة دالة التحديث الرسمية للعبة
                if ([mainProfile respondsToSelector:NSSelectorFromString(@"setGems:")]) {
                    [mainProfile performSelector:NSSelectorFromString(@"setGems:") withObject:@(newGems)];
                }

                // 3. الطريقة الثالثة: إجبار اللعبة على حفظ البيانات فوراً
                if ([mainProfile respondsToSelector:NSSelectorFromString(@"save")]) {
                    [mainProfile performSelector:NSSelectorFromString(@"save")];
                }
                
                // 4. "الضربة القاضية": تحديث الـ NSUserDefaults (ملف الحفظ الخارجي)
                [[NSUserDefaults standardUserDefaults] setInteger:newGems forKey:@"gems"];
                [[NSUserDefaults standardUserDefaults] synchronize];

                // تغيير شكل الزر للتأكيد
                [self.menuButton setTitle:@"✅" forState:UIControlStateNormal];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.menuButton setTitle:@"H" forState:UIControlStateNormal];
                });
                
                NSLog(@"[Hassany] Gems Updated to: %d", newGems);
            }
            #pragma clang diagnostic pop
        }
    } @catch (NSException *e) {
        NSLog(@"[Hassany] Error: %@", e.reason);
    }
}
