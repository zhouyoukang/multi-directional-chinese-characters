#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
简化且可靠的系统字体查找工具
支持Windows, macOS和Linux
专门识别中文字体
"""

import os
import sys
import platform
import re

# 定义用于识别中文字体的正则表达式
CHINESE_FONT_PATTERN = re.compile(r'[\u4e00-\u9fff]|宋|黑|楷|仿|华文|方正|幼圆|隶书|微软|雅黑|宋体|黑体|楷体|仿宋|圆体|细体')

def write_header(file):
    """写入文件头部信息"""
    file.write("系统中已安装的字体列表 (Python方法获取)\n")
    file.write("====================================\n\n")

def write_footer(file):
    """写入推荐字体信息"""
    file.write("\n推荐用于3D打印的中文字体:\n")
    file.write("-------------------------\n")
    file.write("1. 华文楷体 - 笔画连接自然，连体效果好\n")
    file.write("2. 华文中宋 - 结构紧凑，笔画粗细适中\n")
    file.write("3. 方正舒体 - 连笔风格，几乎所有笔画都相连\n")
    file.write("4. 仿宋 - 笔画终端有衬线加强\n")
    file.write("5. 楷体 - 传统风格但连接性较好\n")
    file.write("6. 幼圆 - 圆润字体，笔画粗细均匀\n")

def is_chinese_font(font_name):
    """判断是否为中文字体"""
    return bool(CHINESE_FONT_PATTERN.search(font_name))

def scan_font_files(font_dirs):
    """通过扫描目录来获取字体文件"""
    fonts = []
    chinese_fonts = []
    
    for font_dir in font_dirs:
        if os.path.exists(font_dir):
            print(f"扫描目录: {font_dir}")
            try:
                for root, dirs, files in os.walk(font_dir):
                    for file in files:
                        if file.endswith(('.ttf', '.ttc', '.otf')):
                            # 移除扩展名
                            name = os.path.splitext(file)[0]
                            fonts.append(name)
                            if is_chinese_font(name):
                                chinese_fonts.append(name)
            except Exception as e:
                print(f"扫描{font_dir}时出错: {e}")
    
    return sorted(set(fonts)), sorted(set(chinese_fonts))  # 去重并排序

def get_fonts_with_tkinter():
    """使用tkinter获取字体列表"""
    all_fonts = []
    chinese_fonts = []
    try:
        import tkinter
        from tkinter import font
        print("使用tkinter获取字体...")
        root = tkinter.Tk()
        font_list = font.families()
        root.destroy()
        
        for font_name in font_list:
            all_fonts.append(font_name)
            if is_chinese_font(font_name):
                chinese_fonts.append(font_name)
        
        return sorted(set(all_fonts)), sorted(set(chinese_fonts))
    except Exception as e:
        print(f"使用tkinter获取字体时出错: {e}")
        return [], []

def main():
    """主函数"""
    # 获取脚本所在目录的父目录
    script_dir = os.path.dirname(os.path.abspath(__file__))
    parent_dir = os.path.dirname(script_dir)
    output_file = os.path.join(parent_dir, 'system_fonts_py.txt')
    
    print(f"正在检索系统字体...")
    
    # 确保使用UTF-8编码
    if hasattr(sys.stdout, 'reconfigure'):
        sys.stdout.reconfigure(encoding='utf-8')
    
    # 字体列表
    all_fonts = []
    chinese_fonts = []
    
    # 根据操作系统选择不同的字体目录
    system = platform.system()
    print(f"检测到操作系统: {system}")
    
    # 使用tkinter获取字体列表
    tkinter_all_fonts, tkinter_chinese_fonts = get_fonts_with_tkinter()
    if tkinter_all_fonts:
        print(f"成功使用tkinter找到 {len(tkinter_all_fonts)} 个字体，其中 {len(tkinter_chinese_fonts)} 个中文字体")
        all_fonts.extend(tkinter_all_fonts)
        chinese_fonts.extend(tkinter_chinese_fonts)
    
    # 扫描系统字体目录
    if system == 'Windows':
        font_dirs = [os.path.join(os.environ.get('WINDIR', r'C:\Windows'), 'Fonts')]
    elif system == 'Darwin':  # macOS
        font_dirs = ['/System/Library/Fonts', '/Library/Fonts', os.path.expanduser('~/Library/Fonts')]
    elif system == 'Linux':
        font_dirs = ['/usr/share/fonts', '/usr/local/share/fonts', os.path.expanduser('~/.fonts')]
    else:
        font_dirs = []
    
    # 扫描字体文件
    file_all_fonts, file_chinese_fonts = scan_font_files(font_dirs)
    if file_all_fonts:
        print(f"在系统目录中找到 {len(file_all_fonts)} 个字体文件，其中 {len(file_chinese_fonts)} 个中文字体")
        all_fonts.extend(file_all_fonts)
        chinese_fonts.extend(file_chinese_fonts)
    
    # 去重并排序
    all_fonts = sorted(set(all_fonts))
    chinese_fonts = sorted(set(chinese_fonts))
    
    # 写入文件
    try:
        with open(output_file, 'w', encoding='utf-8') as f:
            write_header(f)
            
            f.write(f"检测到的操作系统: {system}\n\n")
            
            # 写入中文字体列表
            f.write("检测到的中文字体列表:\n")
            f.write("---------------------\n")
            if chinese_fonts:
                for i, font in enumerate(chinese_fonts, 1):
                    f.write(f"★ {i}. {font}\n")
                f.write(f"\n共找到 {len(chinese_fonts)} 个中文字体\n")
            else:
                f.write("未检测到任何中文字体\n")
            
            # 写入所有字体列表
            f.write("\n\n所有系统字体列表:\n")
            f.write("----------------\n")
            if all_fonts:
                for i, font in enumerate(all_fonts, 1):
                    if font in chinese_fonts:
                        f.write(f"★ {i}. {font} (中文字体)\n")
                    else:
                        f.write(f"{i}. {font}\n")
                f.write(f"\n共找到 {len(all_fonts)} 个字体\n")
            else:
                f.write("未找到任何字体，请手动检查系统字体设置。\n")
            
            write_footer(f)
        
        print(f"字体列表已生成到 {output_file}")
        
        # 尝试自动打开文件
        try:
            if system == 'Windows':
                os.system(f'notepad "{output_file}"')
            elif system == 'Darwin':
                os.system(f'open "{output_file}"')
            elif system == 'Linux':
                os.system(f'xdg-open "{output_file}"')
        except:
            pass
            
    except Exception as e:
        print(f"生成字体列表时出错: {e}")
        return 1
    
    return 0

if __name__ == "__main__":
    sys.exit(main()) 