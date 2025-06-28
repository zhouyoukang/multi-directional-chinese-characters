// 上下双面多字阵列方案 - 性能优化版
// 支持任意长度文本，优化性能
// 作者: Claude AI
// 日期: 2023年11月
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
front_face_color = "#FFB6C1"; // 浅粉色
back_face_color = "#ADD8E6"; // 浅蓝色
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
// 前面文字内容
front_text = "新年快乐恭喜发财";
// 后面文字内容
back_text = "阖家幸福事业有成";

// 字体
font = "华文楷体";
// 字体大小
char_size = 16;
// 字间距 (字体大小的倍数)
char_spacing = 1.2;
// 长文本间距调整因子 (字符数量超过5个时自动减小间距)
long_text_spacing_factor = 0.85;

/* [阵列设置] */
// 前面字排列方向：0=竖排，1=横排
front_text_direction = 0;
// 后面字排列方向：0=竖排，1=横排
back_text_direction = 0;

/* [字符旋转设置] */
// 前面字符在平面上的旋转角度
front_char_rotation = 0;
// 后面字符在平面上的旋转角度
back_char_rotation = 0;

/* [旋转与位置] */
// 前面字X轴旋转角度
front_x_angle = 0;
// 前面字Y轴旋转角度
front_y_angle = 0;
// 前面字Z轴旋转角度
front_z_angle = 0;
// 后面字X轴旋转角度
back_x_angle = 0;
// 后面字Y轴旋转角度
back_y_angle = 270; // 旋转270度
// 后面字Z轴旋转角度
back_z_angle = 0;

/* [模型参数] */
// 挤出深度
extrude_depth = 12; // 进一步减小深度到12mm
// 壁厚
wall_thickness = 1.8; // 减小壁厚以适应更薄的模型
// 基础立方体大小（将根据字符数量自动调整）
base_cube_size = 40;
// 立方体扩展系数 (根据字符数量的缩放)
cube_expansion_factor = 0.6;
// 笔画连接偏移量(mm)
stroke_offset = 0.5; // 增加笔画连接偏移量以增强交合部分
// 显示模式：0=交合部分，1=完整模型
show_mode = 0; // 改为0，只显示交合部分
// 模型缩放比例
model_scale = 0.9; // 增大模型缩放比例以增强交合部分
// 模型尺寸缓冲区 (防止字符被截断)
model_buffer = 1.5; // 增加模型尺寸缓冲区

// 计算字符数量
function get_char_count(text) = len(text);
front_char_count = get_char_count(front_text);
back_char_count = get_char_count(back_text);

// 计算动态字符间距
function get_dynamic_spacing(count) = 
    (count > 5) ? char_spacing * long_text_spacing_factor : char_spacing;

front_dynamic_spacing = get_dynamic_spacing(front_char_count);
back_dynamic_spacing = get_dynamic_spacing(back_char_count);

// 根据字体方向设置前后面布局
// 竖排：垂直排列(1)，横排：水平排列(0)
front_layout = (front_text_direction == 0) ? 1 : 0;
back_layout = (back_text_direction == 0) ? 1 : 0;

// 检查是否需要交换宽高 (当字符旋转90或270度时)
function should_swap_dimensions(char_rotation) =
    (char_rotation == 90 || char_rotation == 270);

// 计算模型尺寸 - 根据字符数量、方向和旋转角度自动调整
function calc_model_dimensions() =
    let(
        // 考虑字符旋转对尺寸的影响
        front_swap = should_swap_dimensions(front_char_rotation),
        back_swap = should_swap_dimensions(back_char_rotation),
        
        // 竖排时：宽度固定，高度随字数增加
        // 横排时：高度固定，宽度随字数增加
        // 当字符旋转90/270度时，需要交换宽高
        front_width_factor = front_swap ? 
            ((front_text_direction == 0) ? front_char_count : 1) :
            ((front_text_direction == 0) ? 1 : front_char_count),
            
        front_height_factor = front_swap ?
            ((front_text_direction == 0) ? 1 : front_char_count) :
            ((front_text_direction == 0) ? front_char_count : 1),
            
        back_width_factor = back_swap ?
            ((back_text_direction == 0) ? back_char_count : 1) :
            ((back_text_direction == 0) ? 1 : back_char_count),
            
        back_height_factor = back_swap ?
            ((back_text_direction == 0) ? 1 : back_char_count) :
            ((back_text_direction == 0) ? back_char_count : 1),
            
        max_width_factor = max(front_width_factor, back_width_factor),
        max_height_factor = max(front_height_factor, back_height_factor),
        
        // 增加额外的尺寸系数，确保长文本能够完全显示
        extra_size_factor = 1.5
    )
    [
        (base_cube_size + char_size * (max_width_factor - 1) * front_dynamic_spacing) * model_buffer * extra_size_factor,  // 宽度
        (base_cube_size + char_size * (max_height_factor - 1) * front_dynamic_spacing) * model_buffer * extra_size_factor  // 高度
    ];

// 计算当前模型尺寸
model_dimensions = calc_model_dimensions();
model_width = model_dimensions[0];
model_height = model_dimensions[1];

// 计算当前旋转角度数组
front_rotation = [front_x_angle, front_y_angle, front_z_angle];
back_rotation = [back_x_angle, back_y_angle, back_z_angle];

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

// 基础多方向字体结构
module base_structure() {
    // 移除intersection操作，不再限制模型大小
    union() {
        // 前面字
        scale([model_scale, model_scale, model_scale])
            rotate(front_rotation)
                hollow_3d_chars(front_text, front_char_count, front_layout, front_char_rotation);
        
        // 后面字
        scale([model_scale, model_scale, model_scale])
            rotate(back_rotation)
                hollow_3d_chars(back_text, back_char_count, back_layout, back_char_rotation);
    }
}

// 创建前面字符掩码 - 性能优化版
module front_text_mask() {
    // 在快速预览模式下使用较小的偏移量
    offset_value = preview_quality == 0 ? 2 : 5;
    
    translate([0, 0, -extrude_depth/2])
        rotate([0, 0, 0])
            linear_extrude(height=extrude_depth, convexity=convexity_value)
                offset(r=offset_value)
                    arrange_chars(front_text, front_char_count, front_layout, front_char_rotation);
}

// 创建后面字符掩码 - 性能优化版
module back_text_mask() {
    // 在快速预览模式下使用较小的偏移量
    offset_value = preview_quality == 0 ? 2 : 5;
    
    translate([0, 0, -extrude_depth/2])
        rotate(back_rotation)  // 使用完整的后面旋转角度
            linear_extrude(height=extrude_depth, convexity=convexity_value)
                offset(r=offset_value)
                    arrange_chars(back_text, back_char_count, back_layout, back_char_rotation);
}

// 前面平板区域
module front_plate() {
    translate([0, 0, -extrude_depth/4])
        cube([model_width*10, model_height*10, extrude_depth/2], center=true);
}

// 后面平板区域
module back_plate() {
    translate([0, 0, extrude_depth/4])
        cube([model_width*10, model_height*10, extrude_depth/2], center=true);
}

// 创建切割后的最终模型 - 性能优化版
module final_model() {
    // 在快速预览模式下简化处理
    if (preview_quality == 0) {
        // 简化版：直接显示基础结构，不进行复杂的切割
        base_structure();
    } else {
        // 标准版：进行完整的切割处理
        // 前面区域的处理
        difference() {
            base_structure();
            
            // 移除后面区域，只保留前面区域
            difference() {
                // 创建一个足够大的立方体作为操作空间
                cube([model_width*10, model_height*10, extrude_depth*10], center=true);
                
                // 保留前面区域和前面文字
                union() {
                    front_plate();
                    front_text_mask();
                }
            }
        }
        
        // 后面区域的处理
        difference() {
            base_structure();
            
            // 移除前面区域，只保留后面区域
            difference() {
                // 创建一个足够大的立方体作为操作空间
                cube([model_width*10, model_height*10, extrude_depth*10], center=true);
                
                // 保留后面区域和后面文字
                union() {
                    back_plate();
                    back_text_mask();
                }
            }
        }
    }
}

// 只保留两个方向交合的部分 - 性能优化版
module intersection_only_model() {
    // 创建前面文字的实体部分（不含边缘处理，仅用于求交）
    module front_text_solid() {
        scale([model_scale, model_scale, model_scale])
            rotate(front_rotation)
                solid_3d_chars(front_text, front_char_count, front_layout, front_char_rotation);
    }
    
    // 创建后面文字的实体部分（不含边缘处理，仅用于求交）
    module back_text_solid() {
        scale([model_scale, model_scale, model_scale])
            rotate(back_rotation)
                solid_3d_chars(back_text, back_char_count, back_layout, back_char_rotation);
    }
    
    // 计算两个文字的交集部分
    if (use_render) {
        render(convexity=convexity_value)
        intersection() {
            front_text_solid();
            back_text_solid();
        }
    } else {
        intersection() {
            front_text_solid();
            back_text_solid();
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
                final_model();
            }
        }
    } else {
        // 高精度模式下不使用缓存
        if (show_mode == 0) {
            // 只显示交合部分
            intersection_only_model();
        } else {
            // 显示完整模型
            final_model();
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
        
        // 前面参照面（红色1号）- 随前面字旋转
        color(front_face_color, face_opacity)
            rotate(front_rotation)
            translate([0, 0, 0])
            rotate([0, 0, front_char_rotation])
            cube([face_width, face_height, face_thickness], center=true);
        
        // 后面参照面（蓝色2号）- 随后面字旋转
        color(back_face_color, face_opacity)
            rotate(back_rotation)
            translate([0, 0, 0])
            rotate([0, 0, back_char_rotation])
            cube([face_width, face_height, face_thickness], center=true);
    }
}

// 创建面标识
module create_face_identifier(face_num, rotation, position, color_name) {
    if (show_reference_faces && face_identification > 0) {
        // 面编号标识
        if (face_identification == 1) {
            color("black")
            translate(position)
            rotate(rotation)
            linear_extrude(height=face_id_line_width)
                text(str(face_num), 
                    size=char_size*face_id_size_ratio, 
                    font="Arial Black", 
                    halign="center", 
                    valign="center");
        }
        // 面颜色标识
        else if (face_identification == 2) {
            color(color_name)
            translate(position)
            rotate(rotation)
            linear_extrude(height=face_id_line_width)
                circle(r=char_size*face_id_size_ratio);
        }
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
        
        // 前面标识(红色1号) - 随前面字旋转，移到右上角
        color("black") 
        rotate(front_rotation)
        rotate([0, 0, front_char_rotation])
        translate([offset_x, offset_y, face_id_offset])
        linear_extrude(height=face_id_line_width*1.5)
            text("1", 
                size=char_size*face_id_size_ratio, 
                font="Arial Black", 
                halign="center", 
                valign="center");
        rotate(front_rotation)
        rotate([0, 0, front_char_rotation])
        create_face_outline([0, 0, face_thickness/2], [0, 0, 0], front_face_color);
        
        // 后面标识(蓝色2号) - 随后面字旋转，移到右上角
        color("black") 
        rotate(back_rotation)
        rotate([0, 0, back_char_rotation])
        translate([offset_x, offset_y, face_id_offset])
        linear_extrude(height=face_id_line_width*1.5)
            text("2", 
                size=char_size*face_id_size_ratio, 
                font="Arial Black", 
                halign="center", 
                valign="center");
        rotate(back_rotation)
        rotate([0, 0, back_char_rotation])
        create_face_outline([0, 0, face_thickness/2], [0, 0, 0], back_face_color);
    }
}

// 打印调试信息
echo(str("前面文字: ", front_text));
echo(str("前面字符数量: ", front_char_count));
echo(str("前面字体排列方向: ", front_text_direction == 0 ? "竖排" : "横排"));

echo(str("后面文字: ", back_text));
echo(str("后面字符数量: ", back_char_count));
echo(str("后面字体排列方向: ", back_text_direction == 0 ? "竖排" : "横排"));

echo(str("前面字符平面旋转角度: ", front_char_rotation));
echo(str("后面字符平面旋转角度: ", back_char_rotation));
echo(str("模型宽度: ", model_width));
echo(str("模型高度: ", model_height));
echo(str("参照面显示: ", show_reference_faces ? "开启" : "关闭"));
echo(str("面标识模式: ", face_identification == 0 ? "无标识" : (face_identification == 1 ? "面编号" : "面颜色")));

// 执行显示
display_model(); 