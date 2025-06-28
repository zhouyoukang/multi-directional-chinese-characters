// 多方向立体汉字 - 全新切割方法
$fn = 30; // 平滑度

/* [字体设置] */
// 正面汉字
char_front = "中";
// 侧面汉字
char_side = "国";
// 字体
font = "华文楷体";
// 字体大小
char_size = 18;

/* [旋转与位置] */
// 正面字X轴旋转角度
front_x_angle = 0;
// 正面字Y轴旋转角度
front_y_angle = 0;
// 正面字Z轴旋转角度
front_z_angle = 0;
// 侧面字X轴旋转角度
side_x_angle = 0;
// 侧面字Y轴旋转角度
side_y_angle = 90;
// 侧面字Z轴旋转角度
side_z_angle = 0;

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
face_id_size_ratio = 0.6;
// 面标识位置偏移 (mm)
face_id_offset = 2;
// 面标识颜色
front_face_color = "red";
side_face_color = "green";
// 面标识线宽 (mm)
face_id_line_width = 1.0;

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

// 计算底座实际尺寸
base_size = cube_size * base_size_ratio;

// 计算当前旋转角度数组
front_rotation = [front_x_angle, front_y_angle, front_z_angle];
side_rotation = [side_x_angle, side_y_angle, side_z_angle];

// 增强笔画连接的函数
module enhanced_text(char_text, size=char_size, font_name=font) {
    offset(r=stroke_offset) 
        text(char_text, size=size, font=font_name, halign="center", valign="center");
}

// 创建中空立体字
module hollow_3d_char(char_text) {
    difference() {
        linear_extrude(height=extrude_depth*0.8, center=true)
            enhanced_text(char_text);
        
        linear_extrude(height=extrude_depth*0.8+1, center=true)
            offset(delta=-wall_thickness)
                enhanced_text(char_text);
    }
}

// 基础多方向字体结构
module base_structure() {
    intersection() {
        union() {
            scale([0.9, 0.9, 0.9])
                rotate(front_rotation)
                hollow_3d_char(char_front);
            
            scale([0.9, 0.9, 0.9])
                rotate(side_rotation)
                    hollow_3d_char(char_side);
        }
        cube([cube_size*0.9, cube_size*0.9, cube_size*0.9], center=true);
    }
}

// 创建前面文字掩码
module front_text_mask() {
    translate([0, -cube_size*0.45, 0])
        rotate([90, 0, 0])
            linear_extrude(height=20)
                offset(r=5)
                    rotate([0, 0, 0])
                        enhanced_text(char_front);
}

// 创建侧面文字掩码
module side_text_mask() {
    translate([-cube_size*0.45, 0, 0])
        rotate([0, 90, 0])
            linear_extrude(height=20)
                offset(r=5)
                    rotate([0, 0, 0])
                        enhanced_text(char_side);
}

// 前面平板区域
module front_plate() {
    translate([0, -cube_size*0.45, 0])
        cube([cube_size, 20, cube_size], center=true);
}

// 侧面平板区域
module side_plate() {
    translate([-cube_size*0.45, 0, 0])
        cube([20, cube_size, cube_size], center=true);
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
}

// 只保留两个方向交合的部分
module intersection_only_model() {
    // 创建前面字的实体部分（不含边缘处理，仅用于求交）
    module front_char_solid() {
        translate([0, 0, 0])
            scale([0.9, 0.9, 0.9])
                rotate(front_rotation)
                linear_extrude(height=extrude_depth*0.8, center=true)
                    enhanced_text(char_front);
    }
    
    // 创建侧面字的实体部分（不含边缘处理，仅用于求交）
    module side_char_solid() {
        translate([0, 0, 0])
            scale([0.9, 0.9, 0.9])
                rotate(side_rotation)
                    linear_extrude(height=extrude_depth*0.8, center=true)
                        enhanced_text(char_side);
    }
    
    // 计算两个字的交集部分
    intersection() {
        front_char_solid();
        side_char_solid();
        
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
        
        // 正面参照面（红色，对应1号）- 随前面字旋转
        color(front_face_color, 0.3)
            rotate(front_rotation)
            translate([0, 0, extrude_depth*0.4])
            cube([cube_size*0.8, cube_size*0.8, 0.1], center=true);
        
        // 侧面参照面（绿色，对应2号）- 随侧面字旋转
        color(side_face_color, 0.3)
            rotate(side_rotation)
            translate([0, 0, extrude_depth*0.4])
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
        // 正面标识(1号) - 根据旋转角度调整
        color("black") 
        rotate(front_rotation)
        translate([0, 0, extrude_depth*0.4 + face_id_offset])
        linear_extrude(height=face_id_line_width*1.5)
            text("1", 
                size=char_size*face_id_size_ratio*1.2, 
                font="Arial Black", 
                halign="center", 
                valign="center");
        
        // 正面边框 - 随旋转角度变化
        rotate(front_rotation)
        create_face_outline([0, 0, extrude_depth*0.4], [0, 0, 0], front_face_color);
        
        // 侧面标识(2号) - 根据旋转角度调整
        color("black") 
        rotate(side_rotation)
        translate([0, 0, extrude_depth*0.4 + face_id_offset])
        rotate([0, 0, 0])
        scale([1, 1, 1]) // 可以根据需要调整缩放
        linear_extrude(height=face_id_line_width*1.5)
            text("2", 
                size=char_size*face_id_size_ratio*1.2, 
                font="Arial Black", 
                halign="center", 
                valign="center");
        
        // 侧面边框 - 随旋转角度变化
        rotate(side_rotation)
        create_face_outline([0, 0, extrude_depth*0.4], [0, 0, 0], side_face_color);
    }
}

// 渲染最终模型
combined_model();

// 输出模型信息
echo("多面字打印 - 两个字优化版");
echo(str("当前字体: 正面='", char_front, "', 侧面='", char_side, "'"));
echo(str("正面旋转角度: [", front_x_angle, ", ", front_y_angle, ", ", front_z_angle, "]"));
echo(str("侧面旋转角度: [", side_x_angle, ", ", side_y_angle, ", ", side_z_angle, "]"));
echo(str("字体: ", font, ", 大小: ", char_size));
echo(str("参照面显示: ", show_reference_faces ? "开启" : "关闭"));
echo(str("面标识模式: ", face_identification == 0 ? "无标识" : (face_identification == 1 ? "面编号" : "面颜色")));

/*
使用说明：

1. 参数设置：
   - 字体设置：选择显示的汉字、字体和大小
   - 旋转与位置：调整字体的旋转角度
   - 模型参数：控制模型物理特性和显示模式
   - 底座设置：自定义底座形状、大小和样式

2. 参照面功能：
   - 开启参照面(show_reference_faces=true)可以更直观地看到字体所在面
   - 面标识模式可选择显示面编号或颜色标识
   - 调整角度时使用参照面，最终打印前关闭(show_reference_faces=false)

3. 旋转角度调整：
   - 侧面字默认Y轴旋转90度，垂直于正面字
   - 尝试30-150度之间的角度组合，寻找最佳交合效果
   - 参照面会随着角度调整而变化，便于定位

4. 打印优化：
   - 华文楷体适合3D打印，笔画连接性好
   - 壁厚建议不小于2.5mm
   - 笔画分离时增大"笔画连接偏移量"
   - 显示模式0用于观察结构，1用于最终打印
   - 底座嵌入深度可调整，增加与模型的结合强度

5. 底座调整：
   - 底座大小比例控制底座与模型的相对大小
   - 嵌入深度控制底座与模型的结合程度
   - 圆形底座适合大多数模型，方形底座适合方正字体
   - 使用X/Y/Z轴位置调整参数可精确定位底座位置
   - 使用X/Y/Z轴旋转角度参数可调整底座的角度
*/ 