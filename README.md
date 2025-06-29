# 多面体字打印 (Multi-Directional Chinese Character 3D Models)

![示例效果](images/09ac202b7404eb2260836056b2301a37.jpg)

这是一个基于OpenSCAD的3D模型生成工具，可以创建具有多个方向汉字的立体模型。当从不同角度观看时，这些模型会显示不同的汉字，是一种独特的创意设计工具，特别适合3D打印制作个性化礼品。

*This is an OpenSCAD-based 3D model generation tool that creates solid models with Chinese characters visible from multiple directions. When viewed from different angles, these models display different Chinese characters, making them a unique creative design tool, especially suitable for 3D printing personalized gifts.*

## 功能特点 (Features)

- **多角度文字显示** / **Multi-angle Text Display**: 支持从两个、三个甚至更多方向显示不同汉字 / Supports displaying different Chinese characters from two, three, or more directions
- **参数化设计** / **Parametric Design**: 完全可定制的字体、大小、壁厚等参数 / Fully customizable font, size, wall thickness, and other parameters
- **字体优化** / **Font Optimization**: 内置笔画连接增强算法，解决中文字体3D打印分离问题 / Built-in stroke connection enhancement algorithm to solve Chinese character separation issues in 3D printing
- **多种模式** / **Multiple Modes**: 支持完整模型或仅交合部分的渲染模式 / Supports rendering modes for complete models or intersection parts only
- **底座支持** / **Base Support**: 灵活的底座设计选项，便于模型展示 / Flexible base design options for better model display
- **自动优化** / **Automatic Optimization**: 提供角度自动优化功能，确保最佳显示效果 / Provides automatic angle optimization to ensure the best display effect
- **性能优化** / **Performance Optimization**: 提供不同预览质量级别，加快设计过程 / Offers different preview quality levels to speed up the design process
- **开源字体支持** / **Open Source Font Support**: 支持Google Noto Sans SC等开源中文字体，确保跨平台兼容性 / Supports open-source Chinese fonts like Google Noto Sans SC to ensure cross-platform compatibility

## 效果展示 (Display Effects)

### 多面字模型效果 (Multi-Directional Character Effect)

从不同角度可以看到不同的汉字，这是多面字模型的核心特点：

*From different angles, you can see different Chinese characters, which is the core feature of multi-directional character models:*

![多面字效果](images/{E63F5E4D-D5DC-4BA4-B0A7-F70F2A86CC4D}.png)

*从不同角度观察可以看到不同的汉字，上图展示了双面字"福禄"模型的效果*

*When observed from different angles, different Chinese characters become visible. The image above shows the effect of a dual-character "福禄" (Fortune and Prosperity) model*

### 英文字体示例 (English Font Example)

多面字打印技术同样适用于英文字母和其他语言：

*The multi-directional character printing technology also works with English letters and other languages:*

![英文示例](images/9c927d71be77c405eceb8815290f5812.jpg)

*英文"HELLO"字样的3D打印效果，展示了该技术对各种语言的适用性*

*3D printed "HELLO" text, demonstrating the applicability of this technology to various languages*

### 参照面与预览 (Reference Faces and Preview)

使用参照面可以帮助理解和调整多面字模型：

*Using reference faces helps understand and adjust multi-directional character models:*

![参照面预览](images/{5C2D4207-B33C-49C4-ABD7-3004D4102244}.png)

*带参照面的预览模式，可以清晰看到字体在各个面上的位置和方向*

*Preview mode with reference faces, clearly showing the position and direction of characters on each face*

### 实际应用 (Practical Applications)

多面字模型可以作为创意礼品、装饰品或教育工具：

*Multi-directional character models can serve as creative gifts, decorations, or educational tools:*

![应用示例](images/{4D8F8339-4042-4C60-BB64-A1B081611635}.png)

*多面字模型在实际应用中的效果，可以作为桌面摆件或个性化礼品*

*Multi-directional character models in practical applications, suitable as desktop ornaments or personalized gifts*

## 快速开始 (Quick Start)

### 安装要求 (Installation Requirements)

- [OpenSCAD](https://www.openscad.org/) (最新版本 / latest version)
- 系统安装有适合3D打印的中文字体（推荐：思源黑体/Noto Sans SC、华文楷体、华文中宋）
- *System with Chinese fonts suitable for 3D printing installed (recommended: Noto Sans SC, HuaWen Kaiti, HuaWen Zhongsong)*
- 3D打印机（或3D打印服务）用于打印最终模型
- *3D printer (or 3D printing service) for printing the final model*

### 使用步骤 (Usage Steps)

1. 克隆或下载本仓库 / *Clone or download this repository*
2. 运行 `一键启动示例.bat` 选择示例模型，或直接打开任意模型文件（如 `双面多字阵列.scad`）
   *Run `一键启动示例.bat` to select example models, or directly open any model file (e.g., `双面多字阵列.scad`)*
3. 修改参数设置您想要的文字和属性：/ *Modify parameters to set your desired text and attributes:*
   ```openscad
   front_text = "福";    // 正面汉字 / Front character
   back_text = "禄";     // 侧面汉字 / Side character
   font_selection = 0;   // 字体选择 (0=Noto Sans SC) / Font selection
   char_size = 20;       // 字体大小 / Character size
   ```
4. 按F5预览，F6完整渲染 / *Press F5 to preview, F6 for complete rendering*
5. 导出STL文件（`File > Export > Export as STL`）/ *Export STL file*
6. 使用切片软件准备3D打印 / *Use slicing software to prepare for 3D printing*

### 参数调整界面 (Parameter Adjustment Interface)

在OpenSCAD中，您可以使用图形界面轻松调整模型参数：

*In OpenSCAD, you can easily adjust model parameters using the graphical interface:*

![参数调整界面](images/{E542F79C-6377-46C2-9EE8-D854E4FF1C62}.png)

*参数界面说明：/ Parameter interface description:*

- **性能设置 / Performance Settings**: 调整预览质量以平衡渲染速度和精度 / Adjust preview quality to balance rendering speed and precision
- **参照面设置 / Reference Face Settings**: 控制辅助面的显示方式，帮助定位和调整 / Control how auxiliary faces are displayed to help with positioning and adjustment
- **字体设置 / Font Settings**: 设置各个面的文字内容、字体样式和大小 / Set text content, font style, and size for each face
- **字符旋转设置 / Character Rotation Settings**: 调整字符在平面上的旋转角度 / Adjust the rotation angle of characters on the plane
- **模型参数 / Model Parameters**: 调整大小、壁厚、笔画连接等物理属性 / Adjust size, wall thickness, stroke connection, and other physical properties

您可以实时拖动滑块或输入具体数值，按F5查看效果。设置完成后，按F6进行完整渲染，然后导出STL文件。

*You can drag sliders or input specific values in real-time, then press F5 to see the effect. After settings are complete, press F6 for full rendering, then export the STL file.*

## 模型类型 (Model Types)

### 1. 多字阵列系列 (Multi-Character Array Series)

- **双面多字阵列.scad / Dual-Face Multi-Character Array**: 在立方体的两个相邻面显示不同的文字内容，支持横排和竖排 / Displays different text content on two adjacent faces of a cube, supports horizontal and vertical arrangement
- **三面多字阵列.scad / Three-Face Multi-Character Array**: 在立方体的三个相邻面显示不同的文字内容，支持横排和竖排 / Displays different text content on three adjacent faces of a cube, supports horizontal and vertical arrangement
- **四面多字阵列.scad / Four-Face Multi-Character Array**: 在立方体的四个面显示不同的文字内容，支持横排和竖排 / Displays different text content on four faces of a cube, supports horizontal and vertical arrangement

## 项目结构 (Project Structure)

```
多面体字快速设计/
├── README.md                 # 项目说明文档 / Project documentation
├── LICENSE                   # 许可证文件 / License file
├── 一键启动示例.bat           # 快速启动示例的批处理脚本 / Batch script for quick start examples
├── 双面多字阵列.scad          # 双面多字模型 / Dual-face multi-character model
├── 三面多字阵列.scad          # 三面多字模型 / Three-face multi-character model
├── 四面多字阵列.scad          # 四面多字模型 / Four-face multi-character model
├── docs/                     # 文档目录 / Documentation directory
│   ├── 字体指南.md           # 字体选择指南 / Font selection guide
│   ├── 使用说明.md           # 详细使用教程 / Detailed usage tutorial
│   └── 快速入门.md           # 快速入门指南 / Quick start guide
├── examples/                 # 示例模型目录 / Example models directory
│   ├── 福禄双全.scad         # 双面字示例 / Dual-character example
│   ├── 福禄寿三面字.scad      # 三面字示例 / Three-character example
│   ├── 四季平安.scad         # 四面字示例 / Four-character example
│   └── 新年快乐恭喜发财.scad  # 多字横排示例 / Multi-character horizontal example
├── tools/                    # 工具脚本 / Tool scripts
│   ├── font_finder.py       # 字体查找Python脚本 / Font finder Python script
│   └── 查找中文字体.bat      # 字体查找批处理脚本 / Font finder batch script
├── models/                   # 预生成的模型文件 / Pre-generated model files
└── images/                   # 示例图像目录 / Example images directory
```

## 示例参数 (Example Parameters)

以下是一些预设参数组合的建议，可以直接在模型文件中使用：

*Here are some suggested preset parameter combinations that can be used directly in model files:*

- **福禄双全 / Fortune and Prosperity**（新年礼品 / New Year gift）：

  ```openscad
  // 双面字模型 / Dual-character model
  front_text = "福"; 
  back_text = "禄"; 
  font_selection = 0; // Noto Sans SC
  ```
- **福禄寿 / Fortune, Prosperity, and Longevity**（传统祝福 / Traditional blessing）：

  ```openscad
  // 三面字模型 / Three-character model
  text1 = "福"; 
  text2 = "禄"; 
  text3 = "寿";
  font_selection = 0; // Noto Sans SC
  ```
- **新年快乐恭喜发财 / Happy New Year and Prosperity**（春节祝福 / Spring Festival greeting）：

  ```openscad
  // 双面横列模型 / Dual-face horizontal array model
  front_text = "新年快乐";
  back_text = "恭喜发财";
  front_text_direction = 1; // 横排 / Horizontal
  back_text_direction = 1;  // 横排 / Horizontal
  font_selection = 0; // Noto Sans SC
  ```
- **春夏秋冬 / Spring, Summer, Autumn, Winter**（四季主题 / Four seasons theme）：

  ```openscad
  // 四面字模型 / Four-character model
  text1 = "春"; 
  text2 = "夏"; 
  text3 = "秋";
  text4 = "冬";
  font_selection = 0; // Noto Sans SC
  ```

## 使用说明 (Instructions)

### 参数详解 (Parameter Details)

1. **性能设置 / Performance Settings**

   - `preview_quality`：预览质量（0=快速预览，1=标准预览，2=高精度预览）/ Preview quality (0=fast, 1=standard, 2=high precision)
2. **参照面设置 / Reference Face Settings**

   - `show_reference_faces`：是否显示参照面 / Whether to show reference faces
   - `face_identification`：面标识模式（0=无标识，1=显示面编号，2=显示面颜色）/ Face identification mode (0=none, 1=show face numbers, 2=show face colors)
   - `face_opacity`：参照面透明度（0-1）/ Reference face opacity (0-1)
3. **字体设置 / Font Settings**

   - `front_text`/`text1`/`text2`等：各面显示的文字内容 / Text content displayed on each face
   - `font_selection`：字体选择（0=Noto Sans SC, 1=Noto Serif SC, 2=Noto Sans SC Bold等）/ Font selection
   - `char_size`：字体大小 / Character size
   - `char_spacing`：字间距 / Character spacing
4. **阵列设置 / Array Settings**

   - `front_text_direction`/`text1_direction`等：排列方向（0=竖排，1=横排）/ Arrangement direction (0=vertical, 1=horizontal)
   - `front_char_rotation`/`text1_char_rotation`等：字符在平面上的旋转角度 / Character rotation angle on the plane
5. **模型参数 / Model Parameters**

   - `extrude_depth`：挤出深度 / Extrusion depth
   - `wall_thickness`：壁厚 / Wall thickness
   - `stroke_offset`：笔画连接偏移量 / Stroke connection offset
   - `show_mode`：显示模式（0=交合部分，1=完整模型）/ Display mode (0=intersection part, 1=complete model)
   - `model_scale`：模型缩放比例 / Model scaling ratio

## 高级技巧 (Advanced Techniques)

1. **笔画连接优化 / Stroke Connection Optimization**：调整 `stroke_offset` 参数（0.6-0.8）增强字体连接性，防止打印时笔画分离 / Adjust the `stroke_offset` parameter (0.6-0.8) to enhance font connectivity and prevent stroke separation during printing
2. **调整字符旋转 / Character Rotation Adjustment**：使用 `front_char_rotation` 等参数调整字符在平面上的旋转角度，获得最佳视觉效果 / Use parameters like `front_char_rotation` to adjust the rotation angle of characters on the plane for optimal visual effect
3. **面角度调整 / Face Angle Adjustment**：通过调整X、Y、Z轴旋转角度，可以精确控制各个字面的方向和位置 / By adjusting the X, Y, Z axis rotation angles, you can precisely control the direction and position of each character face
4. **预览性能优化 / Preview Performance Optimization**：设计过程中使用 `preview_quality=0` 加快预览速度，最终渲染前设为更高值 / Use `preview_quality=0` during the design process to speed up preview, and set to a higher value before final rendering
5. **使用Minkowski操作 / Using Minkowski Operation**：高级模型中使用Minkowski操作扩展交合区域，确保字体完整性 / Use Minkowski operation in advanced models to expand intersection areas and ensure font integrity

## 问题排查 (Troubleshooting)

1. **问题 / Problem**: 字体笔画分离，打印后脱落 / Font strokes separate and fall off after printing
   **解决 / Solution**: 增加 `stroke_offset` 参数或选择更适合3D打印的连体字体 / Increase the `stroke_offset` parameter or choose a more suitable connected font for 3D printing
2. **问题 / Problem**: 模型渲染很慢 / Model rendering is slow
   **解决 / Solution**: 降低 `preview_quality` 值以加速预览，最终渲染前再调高 / Lower the `preview_quality` value to speed up preview, and increase it before final rendering
3. **问题 / Problem**: 字符被截断或显示不完整 / Characters are truncated or displayed incompletely
   **解决 / Solution**: 增加 `model_buffer` 参数或调整模型缩放比例 / Increase the `model_buffer` parameter or adjust the model scaling ratio
4. **问题 / Problem**: 找不到合适的字体 / Cannot find suitable fonts
   **解决 / Solution**: 使用项目提供的字体查找工具（tools/查找中文字体.bat），或参考字体指南 / Use the font finder tool provided by the project (tools/查找中文字体.bat), or refer to the font guide
5. **问题 / Problem**: 在某些环境中无法显示中文 / Cannot display Chinese characters in some environments
   **解决 / Solution**: 使用预设的Google Noto Sans SC等开源字体，确保跨平台兼容性 / Use preset open-source fonts like Google Noto Sans SC to ensure cross-platform compatibility

## 贡献指南 (Contribution Guidelines)

欢迎提交Issue或Pull Request来完善项目。特别欢迎以下贡献：

*Issues or Pull Requests are welcome to improve the project. The following contributions are especially welcome:*

1. 新的模型设计（如六面体、十二面体等更多几何形状）/ New model designs (such as hexahedron, dodecahedron, and other geometric shapes)
2. 字体连接算法的改进 / Improvements to the font connection algorithm
3. 更多创意应用案例和示例参数 / More creative application cases and example parameters
4. 文档翻译或完善 / Document translation or improvement

## 许可证 (License)

本项目采用MIT许可证开源。详情请查看LICENSE文件。

*This project is open-sourced under the MIT License. Please see the LICENSE file for details.*

## 作者 (Author)

AIOTVR © 2025年6月

## 致谢 (Acknowledgements)

感谢所有对本项目作出贡献的开发者和用户。特别感谢OpenSCAD社区提供的强大工具支持。

*Thanks to all developers and users who have contributed to this project. Special thanks to the OpenSCAD community for providing powerful tool support.*
