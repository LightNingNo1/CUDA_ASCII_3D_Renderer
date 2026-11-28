
# CUDA ASCII 3D 渲染引擎

<p align="center">
  <strong>基于 NVIDIA CUDA 的 ASCII 三维图形渲染引擎</strong>
</p>

<p align="center">
  C++ · CUDA · CMake · Ray Tracing
</p>

---

## 项目简介

本项目旨在使用 C++ 和 NVIDIA CUDA 从零构建一个三维图形渲染引擎。

项目采用 ASCII 字符作为最终图像的显示载体，通过 CUDA GPU 并行计算完成三维场景的渲染，再将计算结果转换为不同亮度的 ASCII 字符，最终在控制台中实时显示三维图形。

项目以光线追踪（Ray Tracing）为主要渲染算法，逐步实现三维数学基础、光线生成、物体求交、光照计算、摄像机系统以及场景管理等功能。

本项目不仅关注最终的渲染效果，也注重 CUDA 并行计算原理与三维图形学基础知识的学习和实践。

## 项目目标

- 使用 CUDA 实现 GPU 并行渲染。
- 从零实现基础三维数学运算。
- 构建完整的光线追踪渲染流程。
- 实现球体、三角形等基础几何体的光线求交。
- 实现光照、阴影和物体遮挡效果。
- 将渲染结果转换为 ASCII 字符。
- 实现摄像机控制和动态场景渲染。
- 探索 GPU 并行计算在图形渲染中的应用。

## 技术栈

| 技术 | 用途 |
|---|---|
| C++ | 引擎主体开发 |
| NVIDIA CUDA | GPU 并行计算 |
| CMake | 项目构建与管理 |
| CLion | 集成开发环境 |
| Git | 版本控制 |
| ASCII Art | 控制台图形显示 |

## 核心技术

### 1. CUDA 并行计算

利用 CUDA Kernel 将图像像素计算任务分配给 GPU 中的多个线程，实现并行渲染。

### 2. 光线追踪（Ray Tracing）

从摄像机出发，为每个像素生成一条射线，通过射线与场景物体的相交检测确定像素颜色。

### 3. 三维数学运算

自行实现三维向量、矩阵、坐标变换、向量归一化、点乘和叉乘等基础数学模块。

### 4. ASCII 图像转换

根据像素亮度，将图像映射为不同密度的 ASCII 字符，实现控制台三维图形显示。

## 项目开发进度

| 模块         | 功能 | 状态           |
|--------------|---|----------------|
| 项目框架     | CMake + CUDA 工程配置 | 进行中         |
| CUDA 初始化  | GPU 设备识别与初始化 | 待完善         |
| GPU 像素计算 | CUDA 并行计算像素亮度 | 已实现基础版本 |
| ASCII 转换   | 像素亮度映射为字符 | 已实现基础版本 |
| Vector3      | 三维向量运算 | 已实现         |
| Matrix3      | 三维矩阵运算 | 已实现         |
| Matrix4      | 四维变换矩阵 | 待开发         |
| Ray          | 光线数据结构 | 已实现         |
| Ray-Sphere   | 光线与球体求交 | 已实现         |
| Ray-Triangle | 光线与三角形求交 | 已实现         |
| Lighting     | 光照与着色 | 待开发         |
| Camera       | 摄像机系统 | 待完善         |
| Scene        | 场景管理 | 待完善         |
| Shadow       | 阴影计算 | 待开发         |

## 项目目录

```text
CUDA_ASCII_3D_Renderer/
│
├── CMakeLists.txt
│
├── src/
│   ├── main.cu
│   │
│   ├── renderer/
│   ├── math/
│   └── output/
│
├── include/
│   ├── renderer/
│   ├── math/
│   └── output/
│
├── assets/
│   └── models/
│
├── .gitignore
│
└── README.md
```

## 开发环境

- 操作系统：Windows
- 开发语言：C++17 / CUDA C++17
- IDE：CLion
- 构建工具：CMake
- GPU：NVIDIA GeForce RTX 5060 Laptop GPU
- CUDA 架构：SM 120

## 编译与运行

### 环境要求

1. 安装支持目标 GPU 架构的 NVIDIA CUDA Toolkit。
2. 安装支持 CUDA 的 CMake。
3. 安装 NVIDIA 显卡驱动。
4. 配置 CUDA Toolkit 和 CMake 环境变量。

### 使用 CMake 构建

在项目根目录执行：

```bash
cmake -S . -B build

cmake --build build --config Release
```

运行生成的可执行文件：

```bash
build/Release/CUDA_ASCII_3D_Renderer.exe
```

具体生成路径可能因构建配置和生成器而有所不同。

## 开发计划

项目按照循序渐进的方式进行开发：

**第一阶段：基础环境与 ASCII 输出**

- 搭建 CUDA + CMake 工程。
- 验证 GPU 并行计算。
- 实现基础 ASCII 图像输出。

**第二阶段：三维数学基础**

- 实现 Vector3。
- 实现 Matrix4。
- 实现 Ray。
- 实现坐标变换。

**第三阶段：基础光线追踪**

- 实现摄像机射线生成。
- 实现光线与球体求交。
- 实现光线与三角形求交。
- 实现最近交点检测。

**第四阶段：光照与场景**

- 实现基础光照模型。
- 实现阴影计算。
- 实现多个几何体。
- 实现场景管理。

**第五阶段：引擎完善**

- 实现摄像机交互。
- 支持 OBJ 模型加载。
- 优化 CUDA 并行计算。
- 增加帧率与性能统计。
- 探索更复杂的光线追踪效果。

## 项目说明

本项目是一个持续开发中的学习与实践项目，主要用于学习 CUDA GPU 并行编程、C++ 工程开发和计算机图形学。

项目将采用模块化设计，逐步完善渲染功能，并持续记录开发过程。

欢迎对 CUDA、光线追踪和 ASCII 图形渲染感兴趣的开发者交流与学习。

