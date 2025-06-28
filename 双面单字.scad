// 双面单字模型 - 在立方体相邻面显示单个字符
// 基于双面横列模型简化
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
front_text = "福";
// 后面文字内容
back_text = "禄";

// 字体
font = "华文楷体";
// 字体大小
char_size = 20;

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
back_x_angle = 90; // 旋转90度，使面相邻
// 后面字Y轴旋转角度
back_y_angle = 0;
// 后面字Z轴旋转角度
back_z_angle = 0;

/* [模型参数] */
// 挤出深度
extrude_depth = 12;
// 壁厚
wall_thickness = 1.8;
// 基础立方体大小
base_cube_size = 40;
// 笔画连接偏移量(mm)
stroke_offset = 0.5;
// 显示模式：0=交合部分，1=完整模型
show_mode = 0;
// 模型缩放比例
model_scale = 0.9;
// 模型尺寸缓冲区 (防止字符被截断)
model_buffer = 1.5;

// 计算当前模型尺寸
model_width = base_cube_size * model_buffer;
model_height = base_cube_size * model_buffer;

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

// 创建中空立体字 - 性能优化版
module hollow_3d_char(char_text, char_rotation=0) {
    // 在快速预览模式下使用简化的几何体
    if (preview_quality == 0) {
        // 简化版：直接使用实心文字，不进行中空处理
        linear_extrude(height=extrude_depth, center=true, convexity=convexity_value) {
            create_char(char_text, char_rotation=char_rotation);
        }
    } else {
        // 标准版：创建中空文字
        difference() {
            linear_extrude(height=extrude_depth, center=true, convexity=convexity_value) {
                create_char(char_text, char_rotation=char_rotation);
            }
            
            linear_extrude(height=extrude_depth+1, center=true, convexity=convexity_value) {
                offset(delta=-wall_thickness) {
                    create_char(char_text, char_rotation=char_rotation);
                }
            }
        }
    }
}

// 创建实体立体字（用于求交）- 性能优化版
module solid_3d_char(char_text, char_rotation=0) {
    // 交合模式下使用更大的挤出深度以确保交合效果
    linear_extrude(height=extrude_depth * 1.5, center=true, convexity=convexity_value) {
        create_char(char_text, char_rotation=char_rotation);
    }
}

// 基础多方向字体结构
module base_structure() {
    // 移除intersection操作，不再限制模型大小
    union() {
        // 前面字
        scale([model_scale, model_scale, model_scale])
            rotate(front_rotation)
                hollow_3d_char(front_text, front_char_rotation);
        
        // 后面字
        scale([model_scale, model_scale, model_scale])
            rotate(back_rotation)
                hollow_3d_char(back_text, back_char_rotation);
    }
}

// 只保留两个方向交合的部分 - 性能优化版
module intersection_only_model() {
    // 创建前面文字的实体部分（不含边缘处理，仅用于求交）
    module front_text_solid() {
        scale([model_scale, model_scale, model_scale])
            rotate(front_rotation)
                solid_3d_char(front_text, front_char_rotation);
    }
    
    // 创建后面文字的实体部分（不含边缘处理，仅用于求交）
    module back_text_solid() {
        scale([model_scale, model_scale, model_scale])
            rotate(back_rotation)
                solid_3d_char(back_text, back_char_rotation);
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
echo(str("后面文字: ", back_text));
echo(str("前面字符平面旋转角度: ", front_char_rotation));
echo(str("后面字符平面旋转角度: ", back_char_rotation));
echo(str("前面旋转角度: [", front_x_angle, ", ", front_y_angle, ", ", front_z_angle, "]"));
echo(str("后面旋转角度: [", back_x_angle, ", ", back_y_angle, ", ", back_z_angle, "]"));
echo(str("模型宽度: ", model_width));
echo(str("模型高度: ", model_height));
echo(str("参照面显示: ", show_reference_faces ? "开启" : "关闭"));
echo(str("面标识模式: ", face_identification == 0 ? "无标识" : (face_identification == 1 ? "面编号" : "面颜色")));

// 执行显示
display_model(); 