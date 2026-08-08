#import <Foundation/Foundation.h>
#import <mach-o/dyld.h>
#import <mach-o/loader.h>
#import <sys/mman.h>
#import <string.h>

// دالة البحث والاستبدال في الذاكرة (Memory Patcher)
void patchHexInMemory() {
    // كود الهكس القديم لجملة (شكرا لثقتكم...) بلغة فلاتر
    uint8_t searchHex[] = {0x34, 0x06, 0x43, 0x06, 0x31, 0x06, 0x27, 0x06, 0x20, 0x00, 0x44, 0x06, 0x2B, 0x06, 0x42, 0x06, 0x2A, 0x06, 0x43, 0x06, 0x45, 0x06, 0x20, 0x00, 0x28, 0x06, 0x46, 0x06, 0x27, 0x06, 0x2E, 0x00, 0x2E, 0x00, 0x20, 0x00, 0x48, 0x06, 0x2F, 0x06, 0x39, 0x06, 0x45, 0x06, 0x43, 0x06, 0x45, 0x06, 0x20, 0x00, 0x44, 0x06, 0x46, 0x06, 0x27, 0x06, 0x2E, 0x00, 0x2E, 0x00};
    
    // كود الهكس الجديد لجملتك (معدل بواسطة حسين الحسني + مسافات تعويضية)
    uint8_t replaceHex[] = {0x45, 0x06, 0x39, 0x06, 0x2F, 0x06, 0x44, 0x06, 0x20, 0x00, 0x28, 0x06, 0x48, 0x06, 0x27, 0x06, 0x33, 0x06, 0x37, 0x06, 0x29, 0x06, 0x20, 0x00, 0x2D, 0x06, 0x33, 0x06, 0x4A, 0x06, 0x46, 0x06, 0x20, 0x00, 0x27, 0x06, 0x44, 0x06, 0x2D, 0x06, 0x33, 0x06, 0x46, 0x06, 0x4A, 0x06, 0x20, 0x00, 0x20, 0x00, 0x20, 0x00, 0x20, 0x00, 0x20, 0x00, 0x20, 0x00, 0x20, 0x00};

    size_t patternSize = sizeof(searchHex);

    // فحص كل الملفات المحملة بالذاكرة
    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
        const char *imageName = _dyld_get_image_name(i);
        
        // نستهدف ملف App الخاص بمحرك فلاتر حصراً
        if (strstr(imageName, "App.framework/App")) {
            intptr_t slide = _dyld_get_image_vmaddr_slide(i);
            const struct mach_header_64 *header = (const struct mach_header_64 *)_dyld_get_image_header(i);
            
            struct load_command *cmd = (struct load_command *)((char *)header + sizeof(struct mach_header_64));
            for (uint32_t c = 0; c < header->ncmds; c++) {
                if (cmd->cmd == LC_SEGMENT_64) {
                    struct segment_command_64 *seg = (struct segment_command_64 *)cmd;
                    
                    // نبحث داخل قطاعات الذاكرة المقروءة فقط
                    if (seg->initprot & VM_PROT_READ) {
                        uint8_t *segmentStart = (uint8_t *)(seg->vmaddr + slide);
                        uint64_t segmentSize = seg->vmsize;
                        
                        // المسح (Scan)
                        for (uint64_t j = 0; j < segmentSize - patternSize; j++) {
                            if (memcmp(segmentStart + j, searchHex, patternSize) == 0) {
                                
                                // فك حماية الذاكرة حتى نظام iOS يسمح لنا بالتعديل
                                void *pageStart = (void *)((uintptr_t)(segmentStart + j) & ~(getpagesize() - 1));
                                mprotect(pageStart, getpagesize(), PROT_READ | PROT_WRITE | PROT_EXEC);
                                
                                // حقن الهكس الجديد مكان القديم
                                memcpy(segmentStart + j, replaceHex, patternSize);
                                
                                return; 
                            }
                        }
                    }
                }
                cmd = (struct load_command *)((char *)cmd + cmd->cmdsize);
            }
        }
    }
}

// دالة الإقلاع: تشتغل أول ما يفتح التطبيق
%ctor {
    patchHexInMemory();
}
