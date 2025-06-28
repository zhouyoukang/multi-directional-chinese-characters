// 多方向立体汉字 - 三个方向自动优化角度版本
$fn = 30;

/* [基本参数] */
// 正面汉字
char_front = "中";
// 侧面汉字
char_side = "国";
// 顶部汉字
char_top = "人";
// 字体 - 连体字体效果更好
font = "华文楷体";
// 字体大小
char_size = 18;

/* [模型参数] */
// 挤出深度
extrude_depth = 30;
// 壁厚
wall_thickness = 2.5;
// 立方体大小
cube_size = 40;
// 笔画连接偏移量(mm)
stroke_offset = 0.6;
// 显示模式：0=交合部分，1=完整模型
show_mode = 0;

/* [参照面设置] */
// 是否显示参照面
show_reference_faces = true;
// 面标识模式：0=无标识，1=显示面编号，2=显示面颜色
face_identification = 1;
// 面标识大小 (相对于字体大小的比例)
face_id_size_ratio = 0.4;
// 面标识位置偏移 (mm)
face_id_offset = 2;
// 面标识颜色
front_face_color = "red";
side_face_color = "green";
top_face_color = "blue";
// 面标识线宽 (mm)
face_id_line_width = 0.8;

/* [底座设置] */
// 是否添加底座
add_base = true;
// 底座形状：0=圆形，1=方形
base_shape = 1;
// 底座直径/边长 (相对于模型大小的比例)
base_size_ratio = 0.9;
// 底座高度
base_height = 3;
// 底座嵌入深度 (正值表示底座向上嵌入模型)
base_embed = 0;
// 底座倒角半径
base_fillet = 0.8;
// 底座X轴位置调整
base_x_offset = 0;
// 底座Y轴位置调整
base_y_offset = 0;
// 底座Z轴位置调整
base_z_offset = 0;
// 底座X轴旋转角度
base_x_rotation = 0;
// 底座Y轴旋转角度
base_y_rotation = 0;
// 底座Z轴旋转角度
base_z_rotation = 0;

/* [优化参数] */
// 是否启用自动优化
optimization_enabled = true;
// 角度搜索步长（度）
angle_step = 15;
// 角度搜索范围（度）
angle_range = 180;
// 用于计算重合度的采样点数量
samples = 1000;

/* [正面旋转角度] */
// X轴旋转角度
front_x_angle = 0;
// Y轴旋转角度
front_y_angle = 0;
// Z轴旋转角度
front_z_angle = 0;

/* [侧面旋转角度] */
// X轴旋转角度
side_x_angle = 0;
// Y轴旋转角度
side_y_angle = 90;
// Z轴旋转角度
side_z_angle = 0;

/* [顶部旋转角度] */
// X轴旋转角度
top_x_angle = 90;
// Y轴旋转角度
top_y_angle = 0;
// Z轴旋转角度
top_z_angle = 0;

// 计算底座实际尺寸
base_size = cube_size * base_size_ratio;

// 计算当前旋转角度数组
current_front_rotation = [front_x_angle, front_y_angle, front_z_angle]; // 当前正面旋转角度 [x, y, z]
current_side_rotation = [side_x_angle, side_y_angle, side_z_angle]; // 当前侧面旋转角度 [x, y, z]
current_top_rotation = [top_x_angle, top_y_angle, top_z_angle];  // 当前顶部旋转角度 [x, y, z]

// 增强笔画连接的函数
module enhanced_text(char_text, size=char_size, font_name=font) {
    offset(r=stroke_offset) 
        text(char_text, size=size, font=font_name, halign="center", valign="center");
}

// 创建立体字
module solid_3d_char(char_text) {
    linear_extrude(height=extrude_depth*0.8, center=true)
        enhanced_text(char_text);
}

// 创建中空立体字
module hollow_3d_char(char_text) {
    difference() {
        solid_3d_char(char_text);
        
        linear_extrude(height=extrude_depth*0.8+1, center=true)
            offset(delta=-wall_thickness)
                enhanced_text(char_text);
    }
}

// 计算给定角度下多个字的交叉重合体积（估算值）
module calculate_intersection_volume(side_rotation, top_rotation) {
    intersection() {
        // 正面字
        scale([0.9, 0.9, 0.9])
            solid_3d_char(char_front);
        
        // 侧面字（使用给定的旋转角度）
        scale([0.9, 0.9, 0.9])
            rotate(side_rotation)
                solid_3d_char(char_side);
        
        // 顶部字（使用给定的旋转角度）
        scale([0.9, 0.9, 0.9])
            rotate(top_rotation)
                solid_3d_char(char_top);
                
        // 限制在立方体范围内
        cube([cube_size*0.9, cube_size*0.9, cube_size*0.9], center=true);
    }
}

// 搜索最佳旋转角度的模块
// 由于OpenSCAD限制，实际体积计算需要通过控制台输出完成
module find_best_rotation() {
    for (side_x = [0:angle_step:angle_range]) {
        for (side_y = [0:angle_step:angle_range]) {
            for (top_x = [0:angle_step:angle_range]) {
                for (top_y = [0:angle_step:angle_range]) {
                    test_side_rotation = [side_x, side_y, 0];
                    test_top_rotation = [top_x, top_y, 0];
                    // 这里会进行体积估算，但实际需要在控制台中运行多次迭代
                    echo(str("Testing rotations: Side=", test_side_rotation, 
                             ", Top=", test_top_rotation));
                }
            }
        }
    }
}

// 基础多方向字体结构
module base_structure() {
    intersection() {
        union() {
            // 正面字 (添加旋转)
            scale([0.9, 0.9, 0.9])
                rotate([front_x_angle, front_y_angle, front_z_angle])
                    hollow_3d_char(char_front);
            
            // 侧面字（使用设置的旋转角度）
            scale([0.9, 0.9, 0.9])
                rotate([side_x_angle, side_y_angle, side_z_angle])
                    hollow_3d_char(char_side);
            
            // 顶部字（使用设置的旋转角度）
            scale([0.9, 0.9, 0.9])
                rotate([top_x_angle, top_y_angle, top_z_angle])
                    hollow_3d_char(char_top);
        }
        cube([cube_size*0.9, cube_size*0.9, cube_size*0.9], center=true);
    }
}

// 创建前面文字掩码
module front_text_mask() {
    translate([0, -cube_size*0.45, 0])
        rotate([90, 0, 0])
            rotate([front_x_angle, front_y_angle, front_z_angle]) // 添加正面旋转
                linear_extrude(height=20)
                    offset(r=5)
                        enhanced_text(char_front);
}

// 创建侧面文字掩码
module side_text_mask() {
    translate([-cube_size*0.45, 0, 0])
        rotate([side_x_angle, side_y_angle, side_z_angle])
            linear_extrude(height=20)
                offset(r=5)
                    enhanced_text(char_side);
}

// 创建顶部文字掩码
module top_text_mask() {
    translate([0, 0, cube_size*0.45])
        rotate([top_x_angle, top_y_angle, top_z_angle])
            linear_extrude(height=20)
                offset(r=5)
                    enhanced_text(char_top);
}

// 前面平板区域
module front_plate() {
    translate([0, -cube_size*0.45, 0])
        cube([cube_size, 20, cube_size], center=true);
}

// 侧面平板区域 - 根据实际旋转角度调整
module side_plate() {
    // 根据设置的旋转角度调整侧面平板位置
    // 这是简化版本，实际需要根据旋转角度计算正确的位置
    translate([-cube_size*0.45, 0, 0])
        cube([20, cube_size, cube_size], center=true);
}

// 顶部平板区域 - 根据实际旋转角度调整
module top_plate() {
    // 根据设置的旋转角度调整顶部平板位置
    // 这是简化版本，实际需要根据旋转角度计算正确的位置
    translate([0, 0, cube_size*0.45])
        cube([cube_size, cube_size, 20], center=true);
}

// 创建切割后的最终模型
module final_model() {
    // 前面区域的处理
    intersection() {
        base_structure();
        
        // 只保留前面的文字部分
        union() {
            // 不是前面区域的部分保持原样
            difference() {
                cube([cube_size*2, cube_size*2, cube_size*2], center=true);
                front_plate();
            }
            
            // 前面的文字保留
            front_text_mask();
        }
    }
    
    // 侧面区域的处理
    intersection() {
        base_structure();
        
        // 只保留侧面的文字部分
        union() {
            // 不是侧面区域的部分保持原样
            difference() {
                cube([cube_size*2, cube_size*2, cube_size*2], center=true);
                side_plate();
            }
            
            // 侧面的文字保留
            side_text_mask();
        }
    }
    
    // 顶部区域的处理
    intersection() {
        base_structure();
        
        // 只保留顶部的文字部分
        union() {
            // 不是顶部区域的部分保持原样
            difference() {
                cube([cube_size*2, cube_size*2, cube_size*2], center=true);
                top_plate();
            }
            
            // 顶部的文字保留
            top_text_mask();
        }
    }
}

// 只保留多个方向交合的部分
module intersection_only_model() {
    // 创建前面字的实体部分
    module front_char_solid() {
        translate([0, 0, 0])
            scale([0.9, 0.9, 0.9])
                rotate([front_x_angle, front_y_angle, front_z_angle]) // 添加正面旋转
                    linear_extrude(height=extrude_depth*0.8, center=true)
                        enhanced_text(char_front);
    }
    
    // 创建侧面字的实体部分（使用设置的旋转角度）
    module side_char_solid() {
        translate([0, 0, 0])
            scale([0.9, 0.9, 0.9])
                rotate([side_x_angle, side_y_angle, side_z_angle])
                    linear_extrude(height=extrude_depth*0.8, center=true)
                        enhanced_text(char_side);
    }
    
    // 创建顶部字的实体部分（使用设置的旋转角度）
    module top_char_solid() {
        translate([0, 0, 0])
            scale([0.9, 0.9, 0.9])
                rotate([top_x_angle, top_y_angle, top_z_angle])
                    linear_extrude(height=extrude_depth*0.8, center=true)
                        enhanced_text(char_top);
    }
    
    // 计算三个字的交集部分
    intersection() {
        front_char_solid();
        side_char_solid();
        top_char_solid();
        
        // 限制在立方体范围内
        cube([cube_size*0.9, cube_size*0.9, cube_size*0.9], center=true);
    }
}

// 获取模型对象
module get_model() {
    if (show_mode == 0) {
        // 只显示交合部分
        intersection_only_model();
    } else {
        // 显示完整模型
        final_model();
    }
}

// 创建底座
module create_base() {
    // 底座位置计算 - 将底座定位在模型底部，并应用位置和旋转调整
    translate([base_x_offset, base_y_offset, -cube_size*0.45 + base_z_offset]) {
        rotate([base_x_rotation, base_y_rotation, base_z_rotation]) {
            if (base_shape == 0) {
                // 圆形底座
                difference() {
                    cylinder(h=base_height, d=base_size, center=false);
                    
                    // 倒角
                    if (base_fillet > 0) {
                        // 上边缘倒角
                        translate([0, 0, base_height - base_fillet]) {
                            rotate_extrude() {
                                translate([base_size/2 - base_fillet, 0, 0])
                                    circle(r=base_fillet);
                            }
                        }
                        
                        // 下边缘倒角
                        translate([0, 0, base_fillet]) {
                            rotate_extrude() {
                                translate([base_size/2 - base_fillet, 0, 0])
                                    circle(r=base_fillet);
                            }
                        }
                    }
                }
            } else {
                // 方形底座
                translate([0, 0, base_height/2]) {
                    minkowski() {
                        cube([base_size - 2*base_fillet, base_size - 2*base_fillet, base_height - 2*base_fillet], center=true);
                        sphere(r=base_fillet);
                    }
                }
            }
        }
    }
}

// 显示立方体参照面
module show_cube_faces() {
    if (show_reference_faces && face_identification > 0) {
        // 参照面根据字体旋转角度调整
        
        // 正面参照面（蓝色3号）- 随正面字旋转
        color(top_face_color, 0.3)
            translate([0, -cube_size*0.45, 0])
            rotate([90, 0, 0])
            rotate(current_front_rotation) // 添加正面旋转
            cube([cube_size*0.8, cube_size*0.8, 0.1], center=true);
        
        // 侧面参照面（绿色2号）- 随侧面字旋转
        color(side_face_color, 0.3)
            rotate(current_side_rotation)
            translate([0, 0, extrude_depth*0.4])
            cube([cube_size*0.8, cube_size*0.8, 0.1], center=true);
            
        // 顶部参照面（红色1号）- 固定在顶部
        color(front_face_color, 0.3)
            translate([0, 0, cube_size*0.45])
            cube([cube_size*0.8, cube_size*0.8, 0.1], center=true);
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
                    font="Arial", 
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
        color(color_name)
        translate(position)
        rotate(rotation)
        linear_extrude(height=face_id_line_width*0.5)
            difference() {
                square([cube_size*0.8, cube_size*0.8], center=true);
                square([cube_size*0.8-face_id_line_width*2, cube_size*0.8-face_id_line_width*2], center=true);
            }
    }
}

// 组合模型和底座
module combined_model() {
    // 渲染模型
    render(convexity=10)
        get_model();
    
    // 添加底座
    if (add_base) {
        render(convexity=10)
            create_base();
    }
    
    // 显示参照面
    show_cube_faces();
    
    // 添加面标识和边框
    if (show_reference_faces && face_identification > 0) {
        // 正面标识(蓝色3号) - 随正面字旋转
        color("black") 
        translate([0, -cube_size*0.45-face_id_offset, 0])
        rotate([90, 180, 180])
        rotate([front_x_angle, front_y_angle, front_z_angle]) // 添加正面旋转
        linear_extrude(height=face_id_line_width*1.5)
            text("3", 
                size=char_size*face_id_size_ratio*1.2, 
                font="Arial Black", 
                halign="center", 
                valign="center");
        translate([0, -cube_size*0.45, 0])
        rotate([90, 0, 0])
        rotate([front_x_angle, front_y_angle, front_z_angle]) // 添加正面旋转
        create_face_outline([0, 0, 0], [0, 0, 0], top_face_color);
        
        // 侧面标识(绿色2号) - 随旋转角度调整
        color("black") 
        rotate(current_side_rotation)
        translate([0, 0, extrude_depth*0.4 + face_id_offset])
        rotate([0, 0, 0])
        scale([1, 1, 1])
        linear_extrude(height=face_id_line_width*1.5)
            text("2", 
                size=char_size*face_id_size_ratio*1.2, 
                font="Arial Black", 
                halign="center", 
                valign="center");
        rotate(current_side_rotation)
        create_face_outline([0, 0, extrude_depth*0.4], [0, 0, 0], side_face_color);
        
        // 顶部标识(红色1号) - 固定在顶部
        color("black") 
        translate([0, 0, cube_size*0.45+face_id_offset])
        linear_extrude(height=face_id_line_width*1.5)
            text("1", 
                size=char_size*face_id_size_ratio*1.2, 
                font="Arial Black", 
                halign="center", 
                valign="center");
        create_face_outline([0, 0, cube_size*0.45], [0, 0, 0], front_face_color);
    }
}

// 显示优化信息
echo("多方向汉字自动优化版 - 三方向");
echo(str("当前字体: 正面='", char_front, "', 侧面='", char_side, "', 顶部='", char_top, "'"));
echo(str("当前正面旋转角度: [", front_x_angle, ", ", front_y_angle, ", ", front_z_angle, "]")); // 添加正面旋转角度显示
echo(str("当前侧面旋转角度: [", side_x_angle, ", ", side_y_angle, ", ", side_z_angle, "]"));
echo(str("当前顶部旋转角度: [", top_x_angle, ", ", top_y_angle, ", ", top_z_angle, "]"));
echo(str("参照面显示: ", show_reference_faces ? "开启" : "关闭"));
echo(str("面标识模式: ", face_identification == 0 ? "无标识" : (face_identification == 1 ? "面编号" : "面颜色")));

// 渲染最终模型
combined_model();

// 如果您想同时查看原始模型和交合部分，取消下面这行的注释
// final_model();

/*
使用说明：

1. 角度调整说明:
   - 正面X/Y/Z轴旋转：调整正面字符的3D旋转角度
   - 侧面X/Y/Z轴旋转：调整侧面字符的3D旋转角度
   - 顶部X/Y/Z轴旋转：调整顶部字符的3D旋转角度
   - 默认值：正面[0,0,0], 侧面[0,90,0], 顶部[90,0,0]
   - 可以直接通过界面滑块调整各个方向的角度

2. 参照面功能：
   - 开启参照面(show_reference_faces=true)可以更直观地看到字体所在面
   - 面标识模式可选择显示面编号或颜色标识
   - 调整角度时使用参照面，最终打印前关闭(show_reference_faces=false)
   - 三个面使用不同颜色区分：正面(红)、侧面(绿)、顶部(蓝)

3. 优化提示：
   - 尝试不同字体组合，有些字体对会比其他的更容易形成连接
   - 调整 wall_thickness 和 char_size 参数可以进一步优化连接效果
   - 探索不同的角度组合，特别是在 30-150 度之间
   - 参照面会随着角度调整而变化，便于定位
   - 考虑字形的特点，如横向笔画多的字适合垂直旋转，竖向笔画多的字适合水平旋转

4. 特殊字体组合推荐：
   - 同一类型的字体(如都是楷体或都是宋体)通常效果更好
   - 笔画粗细相似的字体组合最佳
   - 推荐字体：华文楷体、方正系列、华文宋体等

5. 底座调整：
   - 底座大小比例控制底座与模型的相对大小
   - 嵌入深度控制底座与模型的结合程度
   - 圆形底座适合大多数模型，方形底座适合方正字体
   - 使用X/Y/Z轴位置调整参数可精确定位底座位置
   - 使用X/Y/Z轴旋转角度参数可调整底座的角度
*/ 