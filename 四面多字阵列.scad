// 四面多字阵列方案 - 基于三面模型扩展
// 支持任意长度文本，围绕Y轴将360度分成四个方向，每个方向间隔75度
// 作者: AIOTVR
// 日期: 2025年6月
// 许可证: MIT License
// 项目地址: https://github.com/zhouyoukang/multi-directional-chinese-characters

$fn = 20; // 降低平滑度以提高性能

/* [性能设置] */
// 预览模式：0=快速预览(低精度)，1=标准预览，2=高精度预览
preview_quality = 0; // 默认使用快速预览模式

/* [参照面设置] */
// 是否显示参照面
show_reference_faces = true;
// 面标识模式：0=无标识，1=显示面编号，2=显示面颜色
face_identification = 1;
// 面标识大小 (相对于字体大小的比例)
face_id_size_ratio = 0.6;
// 面标识位置偏移 (mm)
face_id_offset = 5;
// 面标识颜色
face1_color = "#FFB6C1"; // 浅粉色
face2_color = "#ADD8E6"; // 浅蓝色
face3_color = "#98FB98"; // 浅绿色
face4_color = "#FFFACD"; // 浅黄色
// 面标识线宽 (mm)
face_id_line_width = 1.2;
// 参照面透明度 (0-1, 0为完全透明)
face_opacity = 0.2;
// 参照面大小比例
face_size_ratio = 0.9;
// 参照面厚度
face_thickness = 0.8;

// 根据预览质量设置参数
function get_quality_param(param_name) =
    (param_name == "convexity") ? 
        (preview_quality == 0 ? 5 : 
         preview_quality == 1 ? 10 : 20) :
    (param_name == "fn") ? 
        (preview_quality == 0 ? 10 : 
         preview_quality == 1 ? 20 : 30) :
    (param_name == "render") ? 
        (preview_quality > 0) : 0;

// 设置全局质量参数
convexity_value = get_quality_param("convexity");
use_render = get_quality_param("render");
$fn = get_quality_param("fn");

/* [字体设置] */
// 第一面文字内容
text1 = "新年快乐";
// 第二面文字内容
text2 = "恭喜发财";
// 第三面文字内容
text3 = "万事如意";
// 第四面文字内容
text4 = "阖家幸福";

// 字体选择 (0=Noto Sans SC, 1=Noto Serif SC, 2=Noto Sans SC Bold, 3=Noto Sans SC:style=Light, 
// 4=Noto Sans Mono CJK SC, 5=Roboto, 6=Roboto Italic, 7=Open Sans, 8=Liberation Sans, 
// 9=DejaVu Sans, 10=DejaVu Serif, 11=Ubuntu, 12=Droid Sans)
font_selection = 0;
// 自定义字体 (如果上面选择的字体不可用，可以在这里输入自定义字体名称)
custom_font = "";

// 获取选择的字体
function get_selected_font() =
    custom_font != "" ? custom_font :
    (font_selection == 0) ? "Noto Sans SC" :
    (font_selection == 1) ? "Noto Serif SC" :
    (font_selection == 2) ? "Noto Sans SC:style=Bold" :
    (font_selection == 3) ? "Noto Sans SC:style=Light" :
    (font_selection == 4) ? "Noto Sans Mono CJK SC" :
    (font_selection == 5) ? "Roboto" :
    (font_selection == 6) ? "Roboto:style=Italic" :
    (font_selection == 7) ? "Open Sans" :
    (font_selection == 8) ? "Liberation Sans" :
    (font_selection == 9) ? "DejaVu Sans" :
    (font_selection == 10) ? "DejaVu Serif" :
    (font_selection == 11) ? "Ubuntu" :
    (font_selection == 12) ? "Droid Sans" :
    "Noto Sans SC"; // 默认值

// 实际使用的字体
font = get_selected_font();

// 字体大小
char_size = 16;
// 字间距 (字体大小的倍数)
char_spacing = 1.2;
// 长文本间距调整因子 (字符数量超过5个时自动减小间距)
long_text_spacing_factor = 0.85;

/* [阵列设置] */
// 第一面字排列方向：0=竖排，1=横排
text1_direction = 0;
// 第二面字排列方向：0=竖排，1=横排
text2_direction = 0;
// 第三面字排列方向：0=竖排，1=横排
text3_direction = 0;
// 第四面字排列方向：0=竖排，1=横排
text4_direction = 0;

/* [字符旋转设置] */
// 第一面字符在平面上的旋转角度
text1_char_rotation = 270;
// 第二面字符在平面上的旋转角度
text2_char_rotation = 270;
// 第三面字符在平面上的旋转角度
text3_char_rotation = 270;
// 第四面字符在平面上的旋转角度
text4_char_rotation = 270;

/* [旋转与位置] */
// 第一面X轴旋转角度
face1_x_angle = 0;
// 第一面Y轴旋转角度 - 默认0度
face1_y_angle = 0;
// 第一面Z轴旋转角度
face1_z_angle = 0;

// 第二面X轴旋转角度
face2_x_angle = 0;
// 第二面Y轴旋转角度 - 默认75度
face2_y_angle = 75;
// 第二面Z轴旋转角度
face2_z_angle = 0;

// 第三面X轴旋转角度
face3_x_angle = 0;
// 第三面Y轴旋转角度 - 默认150度
face3_y_angle = 150;
// 第三面Z轴旋转角度
face3_z_angle = 0;

// 第四面X轴旋转角度
face4_x_angle = 0;
// 第四面Y轴旋转角度 - 默认225度
face4_y_angle = 225;
// 第四面Z轴旋转角度
face4_z_angle = 0;

/* [模型参数] */
// 挤出深度
extrude_depth = 12; // 减小深度到12mm
// 壁厚
wall_thickness = 1.8; // 减小壁厚以适应更薄的模型
// 基础立方体大小（将根据字符数量自动调整）
base_cube_size = 40;
// 笔画连接偏移量(mm)
stroke_offset = 0.5; // 增加笔画连接偏移量以增强交合部分
// 显示模式：0=交合部分，1=完整模型
show_mode = 0; // 默认只显示交合部分
// 模型缩放比例
model_scale = 0.9; // 模型缩放比例
// 模型尺寸缓冲区 (防止字符被截断)
model_buffer = 1.5; // 增加模型尺寸缓冲区

// 计算字符数量
function get_char_count(text) = len(text);
text1_char_count = get_char_count(text1);
text2_char_count = get_char_count(text2);
text3_char_count = get_char_count(text3);
text4_char_count = get_char_count(text4);

// 计算动态字符间距
function get_dynamic_spacing(count) = 
    (count > 5) ? char_spacing * long_text_spacing_factor : char_spacing;

text1_dynamic_spacing = get_dynamic_spacing(text1_char_count);
text2_dynamic_spacing = get_dynamic_spacing(text2_char_count);
text3_dynamic_spacing = get_dynamic_spacing(text3_char_count);
text4_dynamic_spacing = get_dynamic_spacing(text4_char_count);

// 根据字体方向设置布局
// 竖排：垂直排列(1)，横排：水平排列(0)
text1_layout = (text1_direction == 0) ? 1 : 0;
text2_layout = (text2_direction == 0) ? 1 : 0;
text3_layout = (text3_direction == 0) ? 1 : 0;
text4_layout = (text4_direction == 0) ? 1 : 0;

// 检查是否需要交换宽高 (当字符旋转90或270度时)
function should_swap_dimensions(char_rotation) =
    (char_rotation == 90 || char_rotation == 270);

// 计算模型尺寸 - 根据字符数量、方向和旋转角度自动调整
function calc_model_dimensions() =
    let(
        // 考虑字符旋转对尺寸的影响
        text1_swap = should_swap_dimensions(text1_char_rotation),
        text2_swap = should_swap_dimensions(text2_char_rotation),
        text3_swap = should_swap_dimensions(text3_char_rotation),
        text4_swap = should_swap_dimensions(text4_char_rotation),
        
        // 竖排时：宽度固定，高度随字数增加
        // 横排时：高度固定，宽度随字数增加
        // 当字符旋转90/270度时，需要交换宽高
        text1_width_factor = text1_swap ? 
            ((text1_direction == 0) ? text1_char_count : 1) :
            ((text1_direction == 0) ? 1 : text1_char_count),
            
        text1_height_factor = text1_swap ?
            ((text1_direction == 0) ? 1 : text1_char_count) :
            ((text1_direction == 0) ? text1_char_count : 1),
            
        text2_width_factor = text2_swap ?
            ((text2_direction == 0) ? text2_char_count : 1) :
            ((text2_direction == 0) ? 1 : text2_char_count),
            
        text2_height_factor = text2_swap ?
            ((text2_direction == 0) ? 1 : text2_char_count) :
            ((text2_direction == 0) ? text2_char_count : 1),
            
        text3_width_factor = text3_swap ?
            ((text3_direction == 0) ? text3_char_count : 1) :
            ((text3_direction == 0) ? 1 : text3_char_count),
            
        text3_height_factor = text3_swap ?
            ((text3_direction == 0) ? 1 : text3_char_count) :
            ((text3_direction == 0) ? text3_char_count : 1),
            
        text4_width_factor = text4_swap ?
            ((text4_direction == 0) ? text4_char_count : 1) :
            ((text4_direction == 0) ? 1 : text4_char_count),
            
        text4_height_factor = text4_swap ?
            ((text4_direction == 0) ? 1 : text4_char_count) :
            ((text4_direction == 0) ? text4_char_count : 1),
            
        max_width_factor = max(text1_width_factor, max(text2_width_factor, max(text3_width_factor, text4_width_factor))),
        max_height_factor = max(text1_height_factor, max(text2_height_factor, max(text3_height_factor, text4_height_factor))),
        
        // 增加额外的尺寸系数，确保长文本能够完全显示
        extra_size_factor = 1.5
    )
    [
        (base_cube_size + char_size * (max_width_factor - 1) * text1_dynamic_spacing) * model_buffer * extra_size_factor,  // 宽度
        (base_cube_size + char_size * (max_height_factor - 1) * text1_dynamic_spacing) * model_buffer * extra_size_factor  // 高度
    ];

// 计算当前模型尺寸
model_dimensions = calc_model_dimensions();
model_width = model_dimensions[0];
model_height = model_dimensions[1];

// 计算当前旋转角度数组
face1_rotation = [face1_x_angle, face1_y_angle, face1_z_angle];
face2_rotation = [face2_x_angle, face2_y_angle, face2_z_angle];
face3_rotation = [face3_x_angle, face3_y_angle, face3_z_angle];
face4_rotation = [face4_x_angle, face4_y_angle, face4_z_angle];

// 创建单个字符 - 性能优化版
module create_char(char_text, size=char_size, font_name=font, char_rotation=0) {
    // 在字符自身平面上旋转
    rotate([0, 0, char_rotation]) {
        // 在快速预览模式下减少偏移量
        if (preview_quality == 0) {
            text(char_text, size=size, font=font_name, halign="center", valign="center");
        } else {
            offset(r=stroke_offset) 
                text(char_text, size=size, font=font_name, halign="center", valign="center");
        }
    }
}

// 获取指定位置的字符
function get_char_at(text, index) = 
    (index < len(text)) ? text[index] : "";

// 水平排列字符 - 性能优化版
module horizontal_chars(text, count, char_rotation=0) {
    // 根据字符数量动态计算间距
    dynamic_spacing = get_dynamic_spacing(count);
    
    // 计算总宽度，确保所有字符都能显示
    total_width = char_size * dynamic_spacing * (count - 1);
    
    // 在快速预览模式下减少字符数量
    max_preview_chars = (preview_quality == 0 && count > 8) ? 8 : count;
    
    // 遍历所有字符
    for (i = [0:max_preview_chars-1]) {
        char_text = get_char_at(text, i);
        
        // 调整字符位置，确保长文本能够正确显示
        translate([
            -total_width/2 + i * char_size * dynamic_spacing, 
            0, 
            0
        ]) 
            create_char(char_text, char_rotation=char_rotation);
    }
}

// 垂直排列字符 - 性能优化版
module vertical_chars(text, count, char_rotation=0) {
    // 根据字符数量动态计算间距
    dynamic_spacing = get_dynamic_spacing(count);
    
    // 计算总高度，确保所有字符都能显示
    total_height = char_size * dynamic_spacing * (count - 1);
    
    // 在快速预览模式下减少字符数量
    max_preview_chars = (preview_quality == 0 && count > 8) ? 8 : count;
    
    // 遍历所有字符
    for (i = [0:max_preview_chars-1]) {
        char_text = get_char_at(text, i);
        
        // 调整字符位置，确保长文本能够正确显示
        translate([
            0,
            total_height/2 - i * char_size * dynamic_spacing,
            0
        ]) 
            create_char(char_text, char_rotation=char_rotation);
    }
}

// 根据布局排列字符
module arrange_chars(text, count, layout, char_rotation=0) {
    if (layout == 0) {
        horizontal_chars(text, count, char_rotation);
    } else {
        vertical_chars(text, count, char_rotation);
    }
}

// 创建中空立体字阵列 - 性能优化版
module hollow_3d_chars(text, count, layout, char_rotation=0) {
    // 在快速预览模式下使用简化的几何体
    if (preview_quality == 0) {
        // 简化版：直接使用实心文字，不进行中空处理
        linear_extrude(height=extrude_depth, center=true, convexity=convexity_value) {
            arrange_chars(text, count, layout, char_rotation);
        }
    } else {
        // 标准版：创建中空文字
        difference() {
            linear_extrude(height=extrude_depth, center=true, convexity=convexity_value) {
                arrange_chars(text, count, layout, char_rotation);
            }
            
            linear_extrude(height=extrude_depth+1, center=true, convexity=convexity_value) {
                offset(delta=-wall_thickness) {
                    arrange_chars(text, count, layout, char_rotation);
                }
            }
        }
    }
}

// 创建实体立体字阵列（用于求交）- 性能优化版
module solid_3d_chars(text, count, layout, char_rotation=0) {
    // 交合模式下使用更大的挤出深度以确保交合效果
    linear_extrude(height=extrude_depth * 1.5, center=true, convexity=convexity_value) {
        arrange_chars(text, count, layout, char_rotation);
    }
}

// 基础多方向字体结构 - 四面版
module base_structure() {
    // 移除intersection操作，不再限制模型大小
    union() {
        // 第一面字
        scale([model_scale, model_scale, model_scale])
            rotate(face1_rotation)
                hollow_3d_chars(text1, text1_char_count, text1_layout, text1_char_rotation);
        
        // 第二面字
        scale([model_scale, model_scale, model_scale])
            rotate(face2_rotation)
                hollow_3d_chars(text2, text2_char_count, text2_layout, text2_char_rotation);
        
        // 第三面字
        scale([model_scale, model_scale, model_scale])
            rotate(face3_rotation)
                hollow_3d_chars(text3, text3_char_count, text3_layout, text3_char_rotation);
                
        // 第四面字
        scale([model_scale, model_scale, model_scale])
            rotate(face4_rotation)
                hollow_3d_chars(text4, text4_char_count, text4_layout, text4_char_rotation);
    }
}

// 只保留四个方向交合的部分 - 性能优化版
module intersection_only_model() {
    // 创建第一面文字的实体部分
    module text1_solid() {
        scale([model_scale, model_scale, model_scale])
            rotate(face1_rotation)
                solid_3d_chars(text1, text1_char_count, text1_layout, text1_char_rotation);
    }
    
    // 创建第二面文字的实体部分
    module text2_solid() {
        scale([model_scale, model_scale, model_scale])
            rotate(face2_rotation)
                solid_3d_chars(text2, text2_char_count, text2_layout, text2_char_rotation);
    }
    
    // 创建第三面文字的实体部分
    module text3_solid() {
        scale([model_scale, model_scale, model_scale])
            rotate(face3_rotation)
                solid_3d_chars(text3, text3_char_count, text3_layout, text3_char_rotation);
    }
    
    // 创建第四面文字的实体部分
    module text4_solid() {
        scale([model_scale, model_scale, model_scale])
            rotate(face4_rotation)
                solid_3d_chars(text4, text4_char_count, text4_layout, text4_char_rotation);
    }
    
    // 计算四个文字的交集部分
    if (use_render) {
        render(convexity=convexity_value)
        intersection() {
            intersection() {
                intersection() {
                    text1_solid();
                    text2_solid();
                }
                text3_solid();
            }
            text4_solid();
        }
    } else {
        intersection() {
            intersection() {
                intersection() {
                    text1_solid();
                    text2_solid();
                }
                text3_solid();
            }
            text4_solid();
        }
    }
}

// 获取模型对象 - 性能优化版
module get_model() {
    // 添加缓存提示以提高性能
    if (preview_quality < 2) {
        // 低精度和标准精度模式下使用缓存
        union() {
            if (show_mode == 0) {
                // 只显示交合部分
                intersection_only_model();
            } else {
                // 显示完整模型
                base_structure();
            }
        }
    } else {
        // 高精度模式下不使用缓存
        if (show_mode == 0) {
            // 只显示交合部分
            intersection_only_model();
        } else {
            // 显示完整模型
            base_structure();
        }
    }
}

// 显示立方体参照面
module show_cube_faces() {
    if (show_reference_faces) {
        // 参照面根据字体旋转角度调整
        
        // 计算参照面大小
        face_width = model_width * face_size_ratio;
        face_height = model_height * face_size_ratio;
        
        // 第一面参照面（浅粉色1号）- 随第一面字旋转
        color(face1_color, face_opacity)
            rotate(face1_rotation)
            translate([0, 0, 0])
            rotate([0, 0, text1_char_rotation])
            cube([face_width, face_height, face_thickness], center=true);
        
        // 第二面参照面（浅蓝色2号）- 随第二面字旋转
        color(face2_color, face_opacity)
            rotate(face2_rotation)
            translate([0, 0, 0])
            rotate([0, 0, text2_char_rotation])
            cube([face_width, face_height, face_thickness], center=true);
            
        // 第三面参照面（浅绿色3号）- 随第三面字旋转
        color(face3_color, face_opacity)
            rotate(face3_rotation)
            translate([0, 0, 0])
            rotate([0, 0, text3_char_rotation])
            cube([face_width, face_height, face_thickness], center=true);
            
        // 第四面参照面（浅黄色4号）- 随第四面字旋转
        color(face4_color, face_opacity)
            rotate(face4_rotation)
            translate([0, 0, 0])
            rotate([0, 0, text4_char_rotation])
            cube([face_width, face_height, face_thickness], center=true);
    }
}

// 创建面边框
module create_face_outline(position, rotation, color_name) {
    if (show_reference_faces && face_identification > 0) {
        color(color_name, face_opacity+0.15)
        translate(position)
        rotate(rotation)
        linear_extrude(height=face_id_line_width*0.4)
            difference() {
                square([model_width*0.75, model_height*0.75], center=true);
                square([model_width*0.75-face_id_line_width*1.8, model_height*0.75-face_id_line_width*1.8], center=true);
            }
    }
}

// 显示模型 - 添加参照面和标识
module display_model() {
    // 添加提示信息
    echo(str("性能模式: ", preview_quality == 0 ? "快速预览" : preview_quality == 1 ? "标准预览" : "高精度预览"));
    
    // 显示模型
    get_model();
    
    // 显示参照面 - 在所有预览模式下都显示
    show_cube_faces();
    
    // 添加面标识和边框 - 在所有预览模式下都显示
    if (show_reference_faces && face_identification > 0) {
        // 计算偏移位置 - 移到边缘位置
        offset_x = model_width * face_size_ratio * 0.35;
        offset_y = model_height * face_size_ratio * 0.35;
        
        // 第一面标识(浅粉色1号) - 随第一面字旋转，移到右上角
        color("black") 
        rotate(face1_rotation)
        rotate([0, 0, text1_char_rotation])
        translate([offset_x, offset_y, face_id_offset])
        linear_extrude(height=face_id_line_width*1.5)
            text("1", 
                size=char_size*face_id_size_ratio, 
                font="Arial Black", 
                halign="center", 
                valign="center");
        rotate(face1_rotation)
        rotate([0, 0, text1_char_rotation])
        create_face_outline([0, 0, face_thickness/2], [0, 0, 0], face1_color);
        
        // 第二面标识(浅蓝色2号) - 随第二面字旋转，移到右上角
        color("black") 
        rotate(face2_rotation)
        rotate([0, 0, text2_char_rotation])
        translate([offset_x, offset_y, face_id_offset])
        linear_extrude(height=face_id_line_width*1.5)
            text("2", 
                size=char_size*face_id_size_ratio, 
                font="Arial Black", 
                halign="center", 
                valign="center");
        rotate(face2_rotation)
        rotate([0, 0, text2_char_rotation])
        create_face_outline([0, 0, face_thickness/2], [0, 0, 0], face2_color);
        
        // 第三面标识(浅绿色3号) - 随第三面字旋转，移到右上角
        color("black") 
        rotate(face3_rotation)
        rotate([0, 0, text3_char_rotation])
        translate([offset_x, offset_y, face_id_offset])
        linear_extrude(height=face_id_line_width*1.5)
            text("3", 
                size=char_size*face_id_size_ratio, 
                font="Arial Black", 
                halign="center", 
                valign="center");
        rotate(face3_rotation)
        rotate([0, 0, text3_char_rotation])
        create_face_outline([0, 0, face_thickness/2], [0, 0, 0], face3_color);
        
        // 第四面标识(浅黄色4号) - 随第四面字旋转，移到右上角
        color("black") 
        rotate(face4_rotation)
        rotate([0, 0, text4_char_rotation])
        translate([offset_x, offset_y, face_id_offset])
        linear_extrude(height=face_id_line_width*1.5)
            text("4", 
                size=char_size*face_id_size_ratio, 
                font="Arial Black", 
                halign="center", 
                valign="center");
        rotate(face4_rotation)
        rotate([0, 0, text4_char_rotation])
        create_face_outline([0, 0, face_thickness/2], [0, 0, 0], face4_color);
    }
}

// 打印调试信息
echo(str("第一面文字: ", text1));
echo(str("第一面字符数量: ", text1_char_count));
echo(str("第一面字体排列方向: ", text1_direction == 0 ? "竖排" : "横排"));
echo(str("第一面Y轴旋转角度: ", face1_y_angle));

echo(str("第二面文字: ", text2));
echo(str("第二面字符数量: ", text2_char_count));
echo(str("第二面字体排列方向: ", text2_direction == 0 ? "竖排" : "横排"));
echo(str("第二面Y轴旋转角度: ", face2_y_angle));

echo(str("第三面文字: ", text3));
echo(str("第三面字符数量: ", text3_char_count));
echo(str("第三面字体排列方向: ", text3_direction == 0 ? "竖排" : "横排"));
echo(str("第三面Y轴旋转角度: ", face3_y_angle));

echo(str("第四面文字: ", text4));
echo(str("第四面字符数量: ", text4_char_count));
echo(str("第四面字体排列方向: ", text4_direction == 0 ? "竖排" : "横排"));
echo(str("第四面Y轴旋转角度: ", face4_y_angle));

echo(str("模型宽度: ", model_width));
echo(str("模型高度: ", model_height));
echo(str("参照面显示: ", show_reference_faces ? "开启" : "关闭"));
echo(str("面标识模式: ", face_identification == 0 ? "无标识" : (face_identification == 1 ? "面编号" : "面颜色")));

// 执行显示
display_model();
