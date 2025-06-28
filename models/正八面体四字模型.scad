// 正八面体汉字模型生成器 - 四面版本
// 在正八面体的四个面上显示不同的汉字
// 性能优化版本
$fn = 30;  // 适度降低精度以平衡性能和质量

/* [字体设置] */
// 第一个面的汉字
char_face1 = "中";
// 第二个面的汉字
char_face2 = "国";
// 第三个面的汉字
char_face3 = "人";
// 第四个面的汉字
char_face4 = "福";
// 字体
font = "华文楷体";
// 字体大小
char_size = 12;

/* [模型参数] */
// 正八面体大小（半径）
size = 20;
// 挤出深度
extrude_depth = 16;
// 壁厚
wall_thickness = 2.5;
// 笔画连接偏移量(mm)
stroke_offset = 0.6;  // 恢复原始偏移量以确保结构完整性
// 显示模式：0=交合部分，1=完整模型
show_mode = 0;
// 是否显示坐标轴辅助线（用于开发调试）
show_axes = false;
// 性能模式：0=标准质量，1=快速预览
performance_mode = 0;  // 默认使用标准质量模式
// 面标识模式：0=无标识，1=显示面编号，2=显示面颜色
face_identification = 1;
// 面选择模式：0=原始模式(上下对称)，1=下半部分四个面
face_selection_mode = 1;  // 默认使用下半部分四个面

/* [第一个字面角度] */
// 第一个字X轴旋转角度
face1_x_angle = 125; // 默认为下半部分-前方-右侧面
// 第一个字Y轴旋转角度
face1_y_angle = 0;
// 第一个字Z轴旋转角度
face1_z_angle = 45;

/* [第二个字面角度] */
// 第二个字X轴旋转角度
face2_x_angle = 125; // 默认为下半部分-左侧-前方面
// 第二个字Y轴旋转角度
face2_y_angle = 0;
// 第二个字Z轴旋转角度
face2_z_angle = -45;

/* [第三个字面角度] */
// 第三个字X轴旋转角度
face3_x_angle = 125; // 默认为下半部分-后方-左侧面
// 第三个字Y轴旋转角度
face3_y_angle = 180;
// 第三个字Z轴旋转角度
face3_z_angle = 45;

/* [第四个字面角度] */
// 第四个字X轴旋转角度
face4_x_angle = 125; // 默认为下半部分-右侧-后方面
// 第四个字Y轴旋转角度
face4_y_angle = 180;
// 第四个字Z轴旋转角度
face4_z_angle = -45;

/* [优化参数] */
// 是否启用自动优化（预留功能，当前版本不可用）
optimization_enabled = false;
// 角度搜索步长（度）
angle_step = 15;
// 角度搜索范围（度）
angle_range = 180;

/* [底座设置] */
// 是否添加底座
add_base = true;
// 底座形状：0=圆形，1=方形
base_shape = 0;
// 底座直径/边长 (相对于模型大小的比例)
base_size_ratio = 0.9;
// 底座高度
base_height = 3;
// 底座嵌入深度 (正值表示底座向上嵌入模型)
base_embed = 0;
// 底座倒角半径
base_fillet = 0.8;
// 底座Z轴位置调整
base_z_offset = 0;

/* [面标识设置] */
// 面标识大小 (相对于字体大小的比例)
face_id_size_ratio = 0.4;
// 面标识位置偏移 (mm)
face_id_offset = 2;
// 面标识颜色
face1_color = "red";
face2_color = "green";
face3_color = "blue";
face4_color = "yellow";
// 面标识线宽 (mm)
face_id_line_width = 0.8;

// 计算底座实际尺寸
base_size = size * 2 * base_size_ratio;

// 设置预设角度组合
function get_preset_angles(face_num) =
    face_selection_mode == 0 ?
        // 原始模式 - 上下对称
        face_num == 1 ? [0, 0, 0] :           // 上方面
        face_num == 2 ? [125, 0, 45] :        // 右前方面
        face_num == 3 ? [125, 0, -45] :       // 左前方面
        face_num == 4 ? [180, 0, 0] :         // 底部面
        [0, 0, 0]                             // 默认
    :
        // 下半部分四个面
        face_num == 1 ? [125, 0, 45] :        // 下半部分-前方-右侧面
        face_num == 2 ? [125, 0, -45] :       // 下半部分-左侧-前方面
        face_num == 3 ? [125, 180, 45] :      // 下半部分-后方-左侧面
        face_num == 4 ? [125, 180, -45] :     // 下半部分-右侧-后方面
        [0, 0, 0];                            // 默认

// 计算当前旋转角度数组
face1_rotation = [face1_x_angle, face1_y_angle, face1_z_angle];
face2_rotation = [face2_x_angle, face2_y_angle, face2_z_angle];
face3_rotation = [face3_x_angle, face3_y_angle, face3_z_angle];
face4_rotation = [face4_x_angle, face4_y_angle, face4_z_angle];

// 辅助函数：显示坐标轴
module show_axes() {
    // X轴 - 红色
    color("red") {
        translate([0, 0, 0]) rotate([0, 90, 0]) cylinder(h=size*2, r=0.5);
        translate([size*2, 0, 0]) rotate([0, 90, 0]) cylinder(h=2, r=1.5, center=true);
    }
    // Y轴 - 绿色
    color("green") {
        translate([0, 0, 0]) rotate([-90, 0, 0]) cylinder(h=size*2, r=0.5);
        translate([0, size*2, 0]) rotate([-90, 0, 0]) cylinder(h=2, r=1.5, center=true);
    }
    // Z轴 - 蓝色
    color("blue") {
        translate([0, 0, 0]) cylinder(h=size*2, r=0.5);
        translate([0, 0, size*2]) cylinder(h=2, r=1.5, center=true);
    }
}

// 正八面体模块
module octahedron(s = size) {
    // 正八面体顶点坐标
    vertices = [
        [0, 0, s],     // 顶部顶点 (0)
        [s, 0, 0],     // 右侧顶点 (1)
        [0, s, 0],     // 前方顶点 (2)
        [-s, 0, 0],    // 左侧顶点 (3)
        [0, -s, 0],    // 后方顶点 (4)
        [0, 0, -s]     // 底部顶点 (5)
    ];

    // 正八面体的8个面（每个面是一个三角形）
    faces = [
        [0, 1, 2],    // 顶部-右侧-前方 面
        [0, 2, 3],    // 顶部-前方-左侧 面
        [0, 3, 4],    // 顶部-左侧-后方 面
        [0, 4, 1],    // 顶部-后方-右侧 面
        [5, 2, 1],    // 底部-前方-右侧 面
        [5, 3, 2],    // 底部-左侧-前方 面
        [5, 4, 3],    // 底部-后方-左侧 面
        [5, 1, 4]     // 底部-右侧-后方 面
    ];

    // 创建多面体
    polyhedron(
        points = vertices,
        faces = faces,
        convexity = 10
    );
}

// 显示正八面体的面
module show_octahedron_faces() {
    if (face_identification > 0) {
        // 显示正八面体的下半部分四个面
        scale([0.9, 0.9, 0.9]) {
            // 底部-前方-右侧 面
            color(face1_color, 0.3)
            polyhedron(
                points = [
                    [0, 0, -size],    // 底部顶点
                    [0, size, 0],     // 前方顶点
                    [size, 0, 0]      // 右侧顶点
                ],
                faces = [[0, 1, 2]],
                convexity = 10
            );
            
            // 底部-左侧-前方 面
            color(face2_color, 0.3)
            polyhedron(
                points = [
                    [0, 0, -size],    // 底部顶点
                    [-size, 0, 0],    // 左侧顶点
                    [0, size, 0]      // 前方顶点
                ],
                faces = [[0, 1, 2]],
                convexity = 10
            );
            
            // 底部-后方-左侧 面
            color(face3_color, 0.3)
            polyhedron(
                points = [
                    [0, 0, -size],    // 底部顶点
                    [0, -size, 0],    // 后方顶点
                    [-size, 0, 0]     // 左侧顶点
                ],
                faces = [[0, 1, 2]],
                convexity = 10
            );
            
            // 底部-右侧-后方 面
            color(face4_color, 0.3)
            polyhedron(
                points = [
                    [0, 0, -size],    // 底部顶点
                    [size, 0, 0],     // 右侧顶点
                    [0, -size, 0]     // 后方顶点
                ],
                faces = [[0, 1, 2]],
                convexity = 10
            );
        }
    }
}

// 增强笔画连接的函数
module enhanced_text(char_text, size=char_size, font_name=font) {
    // 在性能模式下减少偏移量
    if (performance_mode == 1) {
        offset(r=stroke_offset/2) 
            text(char_text, size=size, font=font_name, halign="center", valign="center");
    } else {
        offset(r=stroke_offset) 
            text(char_text, size=size, font=font_name, halign="center", valign="center");
    }
}

// 创建中空立体字
module hollow_3d_char(char_text, rotation) {
    rotate(rotation)
        difference() {
            linear_extrude(height=extrude_depth*0.8, center=true)
                enhanced_text(char_text);
            
            // 在性能模式下使用更简单的中空处理
            if (performance_mode == 0) {
                linear_extrude(height=extrude_depth*0.8+1, center=true)
                    offset(delta=-wall_thickness)
                        enhanced_text(char_text);
            } else {
                // 快速预览模式下也保持中空结构，但简化计算
                linear_extrude(height=extrude_depth*0.8+1, center=true)
                    offset(delta=-wall_thickness/1.5)
                        text(char_text, size=char_size, font=font, halign="center", valign="center");
            }
        }
}

// 创建实体立体字（用于计算交集）
module solid_3d_char(char_text, rotation) {
    rotate(rotation)
        linear_extrude(height=extrude_depth*0.8, center=true)
            enhanced_text(char_text);
}

// 搜索最佳旋转角度的模块（仅示例功能）
module find_best_rotation() {
    echo("自动优化功能在当前版本中为预留功能，尚未实现完整功能");
    echo("请手动调整角度以获得最佳效果");
}

// 创建面标识
module create_face_identifier(face_num, rotation, color_name) {
    // 面编号标识
    if (face_identification == 1) {
        color("black")
        rotate(rotation)
        translate([0, 0, extrude_depth*0.4 + face_id_offset])
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
        rotate(rotation)
        translate([0, 0, extrude_depth*0.4 + face_id_offset])
        linear_extrude(height=face_id_line_width)
            circle(r=char_size*face_id_size_ratio);
    }
}

// 创建面边框
module create_face_outline(rotation, color_name) {
    if (face_identification > 0) {
        color(color_name)
        rotate(rotation)
        translate([0, 0, extrude_depth*0.4])
        linear_extrude(height=face_id_line_width*0.5)
            difference() {
                offset(r=char_size*0.7) square(char_size*1.4, center=true);
                offset(r=char_size*0.7 - face_id_line_width) square(char_size*1.4, center=true);
            }
    }
}

// 只保留多个方向交合的部分
module intersection_only_model() {
    // 创建四个字的实体部分
    module face1_char_solid() {
        translate([0, 0, 0])
            scale([0.9, 0.9, 0.9])
                rotate(face1_rotation)
                    linear_extrude(height=extrude_depth*0.8, center=true)
                        enhanced_text(char_face1);
    }
    
    module face2_char_solid() {
        translate([0, 0, 0])
            scale([0.9, 0.9, 0.9])
                rotate(face2_rotation)
                    linear_extrude(height=extrude_depth*0.8, center=true)
                        enhanced_text(char_face2);
    }
    
    module face3_char_solid() {
        translate([0, 0, 0])
            scale([0.9, 0.9, 0.9])
                rotate(face3_rotation)
                    linear_extrude(height=extrude_depth*0.8, center=true)
                        enhanced_text(char_face3);
    }
    
    module face4_char_solid() {
        translate([0, 0, 0])
            scale([0.9, 0.9, 0.9])
                rotate(face4_rotation)
                    linear_extrude(height=extrude_depth*0.8, center=true)
                        enhanced_text(char_face4);
    }
    
    // 计算字体与正八面体的五重交集
    intersection() {
        face1_char_solid();
        face2_char_solid();
        face3_char_solid();
        face4_char_solid();
        
        // 与正八面体求交
        scale([0.9, 0.9, 0.9])
            octahedron();
    }
}

// 创建完整的模型（显示所有面部信息）
module final_model() {
    // 基础多方向字体结构
    intersection() {
        union() {
            // 四个面的字
            scale([0.9, 0.9, 0.9])
                rotate(face1_rotation)
                    hollow_3d_char(char_face1, [0,0,0]);
            
            scale([0.9, 0.9, 0.9])
                rotate(face2_rotation)
                    hollow_3d_char(char_face2, [0,0,0]);
            
            scale([0.9, 0.9, 0.9])
                rotate(face3_rotation)
                    hollow_3d_char(char_face3, [0,0,0]);
            
            scale([0.9, 0.9, 0.9])
                rotate(face4_rotation)
                    hollow_3d_char(char_face4, [0,0,0]);
        }
        
        // 与正八面体求交
        scale([0.9, 0.9, 0.9])
            octahedron();
    }
}

// 创建底座
module create_base() {
    // 底座位置计算 - 将底座定位在模型底部
    translate([0, 0, -size*0.9 + base_z_offset]) {
        if (base_shape == 0) {
            // 圆形底座
            difference() {
                cylinder(h=base_height, d=base_size, center=false);
                
                // 倒角 - 在性能模式下简化
                if (base_fillet > 0 && performance_mode == 0) {
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
            // 方形底座 - 在性能模式下简化
            if (performance_mode == 1) {
                cube([base_size, base_size, base_height], center=true);
            } else {
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

// 创建面标识
module create_face_identifiers() {
    if (face_identification > 0) {
        scale([0.9, 0.9, 0.9]) {
            // 面1标识
            create_face_identifier(1, face1_rotation, face1_color);
            create_face_outline(face1_rotation, face1_color);
            
            // 面2标识
            create_face_identifier(2, face2_rotation, face2_color);
            create_face_outline(face2_rotation, face2_color);
            
            // 面3标识
            create_face_identifier(3, face3_rotation, face3_color);
            create_face_outline(face3_rotation, face3_color);
            
            // 面4标识
            create_face_identifier(4, face4_rotation, face4_color);
            create_face_outline(face4_rotation, face4_color);
        }
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

// 组合模型和底座
module combined_model() {
    // 渲染模型 - 在性能模式下不使用render
    if (performance_mode == 1) {
        get_model();
    } else {
        render(convexity=10) get_model();
    }
    
    // 添加底座
    if (add_base) {
        if (performance_mode == 1) {
            create_base();
        } else {
            render(convexity=10) create_base();
        }
    }
    
    // 添加面标识
    create_face_identifiers();
    
    // 显示正八面体的面
    show_octahedron_faces();
}

// 自动优化提示
if (optimization_enabled) {
    echo("注意：自动优化功能在当前版本中还不完善，请谨慎使用");
    echo("建议：先手动调整角度找到合适的位置");
    find_best_rotation();
}

// 渲染最终模型
combined_model();

// 显示坐标轴（如果启用）
if (show_axes) {
    show_axes();
}

// 输出模型信息
echo("正八面体四字汉字模型生成器 - 性能优化版");
echo(str("当前字体: 面1='", char_face1, "', 面2='", char_face2, "', 面3='", char_face3, "', 面4='", char_face4, "'"));
echo(str("面1旋转角度: [", face1_x_angle, ", ", face1_y_angle, ", ", face1_z_angle, "]"));
echo(str("面2旋转角度: [", face2_x_angle, ", ", face2_y_angle, ", ", face2_z_angle, "]"));
echo(str("面3旋转角度: [", face3_x_angle, ", ", face3_y_angle, ", ", face3_z_angle, "]"));
echo(str("面4旋转角度: [", face4_x_angle, ", ", face4_y_angle, ", ", face4_z_angle, "]"));
echo(str("字体: ", font, ", 大小: ", char_size));
echo(str("性能模式: ", performance_mode == 1 ? "快速预览" : "标准质量"));
echo(str("面标识模式: ", face_identification == 0 ? "无标识" : (face_identification == 1 ? "面编号" : "面颜色")));
echo(str("面选择模式: ", face_selection_mode == 0 ? "原始模式(上下对称)" : "下半部分四个面"));

// 成功提示
echo("模型生成完成，请调整角度以获得最佳效果");

/*
使用说明：

1. 面选择模式：
   - 新增face_selection_mode参数：
     * 0=原始模式(上下对称)
     * 1=下半部分四个面(默认)
   - 下半部分四个面模式可以避免面1和面4对称导致的混淆
   - 使用了正八面体底部的四个三角形面，更容易区分

2. 面标识功能：
   - 新增face_identification参数：
     * 0=无标识（默认）
     * 1=显示面编号（1-4）
     * 2=显示面颜色标识
   - 面标识可以帮助您在预览时识别不同的面
   - 面标识不会包含在最终的3D打印模型中
   - 可以调整面标识大小、颜色和位置

3. 性能优化说明：
   - 新增performance_mode参数：
     * 0=标准质量（完整细节，渲染较慢）
     * 1=快速预览（简化细节，提高速度）
   - 在调整参数时可以使用快速预览模式
   - 如果模型出现散碎情况，请切换到标准质量模式
   - 最终导出STL前一定要切换到标准质量模式

4. 参数设置：
   - 字体设置：选择显示的四个汉字、字体和大小
   - 模型参数：控制正八面体大小和显示模式
   - 旋转角度：分别调整四个字面的旋转角度，以对应到正八面体的不同面

5. 角度调整技巧：
   - 下半部分四个面的默认角度设置为：
     * 面1: [125, 0, 45]（底部-前方-右侧面）
     * 面2: [125, 0, -45]（底部-左侧-前方面）
     * 面3: [125, 180, 45]（底部-后方-左侧面）
     * 面4: [125, 180, -45]（底部-右侧-后方面）
   - 要获得最佳效果，建议启用坐标轴（show_axes=true）进行角度调试

6. 显示模式：
   - 模式0（交合部分）：只显示四个字和正八面体的五重交集部分，适合观察结构
   - 模式1（完整模型）：显示带有四个字的完整正八面体模型，适合最终打印

7. 提高打印效果的建议：
   - 字体大小需要适当调小以避免字体过度扩展超出面的范围
   - 当使用四个字面时，推荐增加stroke_offset至0.8-1.0以增强连接性
   - 增加wall_thickness壁厚(3.0mm左右)可以提高模型的结构强度
   - 复杂汉字建议选择较小的字号和较粗的笔画

8. 性能与质量平衡：
   - 降低$fn值可以提高渲染速度，但会降低圆形边缘质量
   - 使用简单字体和简单汉字可减轻计算负担
   - 在调试阶段可以先用简单字符替代复杂汉字
   - 最终导出前再替换为目标汉字
   - 如果模型出现散碎现象，请增加stroke_offset值

9. 面标识使用技巧：
   - 在调整角度时启用面标识，以便清楚识别每个面
   - 导出最终模型前关闭面标识（设置face_identification=0）
   - 面标识颜色可以在参数中自定义
   - 面标识大小可以通过face_id_size_ratio参数调整
*/ 