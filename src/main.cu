#include <iostream>
#include <vector>
#include <cuda_runtime.h>

#include "utils/CudaCheck.cuh"

#include "renderer/Camera/Camera.cuh"
#include "renderer/Camera/GPUCameraManager.cuh"

#include "renderer/GPUScene/GPUSceneManager.cuh"

#include "renderer/RayTracingKernel.cuh"
#include "renderer/Hit/HittableList.cuh"
#include "renderer/Object/Sphere.cuh"
#include "renderer/Object/Triangle.cuh"
#include <windows.h>

constexpr char ASCII_GRADIENT[] =
    " .'`^\",:;Il!i~+_-?][}{1)(|\\/tfjrxnuvczXYUJCLQ0OZmwqpdbkhao*#MW&8%B@$";

constexpr int ASCII_GRADIENT_SIZE =
    sizeof(ASCII_GRADIENT) - 1;

float rgbToBrightness(const Pixel& color) {
    return (0.299f * color.r
         + 0.587f * color.g
         + 0.114f * color.b)/ 255.0f;
}

char brightnessToASCII(float brightness) {

    brightness = fminf(fmaxf(brightness, 0.0f), 1.0f);

    int index = static_cast<int>(
        brightness * (ASCII_GRADIENT_SIZE - 1)
    );

    return ASCII_GRADIENT[index];
}

char rgbToASCII(const Pixel& color) {

    float brightness = rgbToBrightness(color);

    return brightnessToASCII(brightness);
}

void setConsoleFont(int width, int height) {
    HANDLE hConsole = GetStdHandle(STD_OUTPUT_HANDLE);

    CONSOLE_FONT_INFOEX fontInfo{};
    fontInfo.cbSize = sizeof(CONSOLE_FONT_INFOEX);

    GetCurrentConsoleFontEx(hConsole, FALSE, &fontInfo);

    fontInfo.dwFontSize.X = width;
    fontInfo.dwFontSize.Y = height;

    SetCurrentConsoleFontEx(hConsole, FALSE, &fontInfo);
}

int main() {

    // ==========================================
    // 1. 初始化相机
    // ==========================================

    CameraData camera;

    // 按照你当前 CameraData 的实际构造接口调整
    camera.position = Vector3(0.0f, 0.0f, 0.0f);
    camera.target = Vector3(0.0f, 0.0f, -5.0f);
    camera.worldUp = Vector3(0.0f, 1.0f, 0.0f);

    camera.vfov = 60.0f;
    camera.aspectRatio = 800.0f / 600.0f;
    camera.focalLength = 1.0f;

    if (!camera.buildCoordinateSystem()) {
        std::cerr << "Failed to build camera coordinate system!\n";
        return -1;
    }

    if (!camera.buildViewport()) {
        std::cerr << "Failed to build camera viewport!\n";
        return -1;
    }


    // ==========================================
    // 2. 构建 CPU 场景
    // ==========================================

    HittableList world;

    // 示例：添加一个球体
    world.add(std::make_shared<Sphere>(
        Vector3(0.0f, 0.0f, -6.0f),
        2.0f
    ));

    // 如果你的 HittableList / Triangle 接口不同，
    // 这里暂时不添加三角形。


    // ==========================================
    // 3. 创建 GPU 管理器
    // ==========================================

    GPUCameraManager cameraManager;
    GPUSceneManager sceneManager;


    // ==========================================
    // 4. 上传相机数据
    // ==========================================

    cameraManager.upload(camera);


    // ==========================================
    // 5. 上传场景数据
    // ==========================================

    sceneManager.update(world);


    // ==========================================
    // 6. 设置图像分辨率
    // ==========================================

    const int imageWidth = 160;
    const int imageHeight = 90;

    const int pixelCount = imageWidth * imageHeight;


    // ==========================================
    // 7. 分配 GPU 命中结果数组
    // ==========================================

    Pixel* devicePixels = nullptr;

    CHECK(cudaMalloc(
        reinterpret_cast<void**>(&devicePixels),
        static_cast<size_t>(pixelCount) * sizeof(Pixel)
    ));


    // ==========================================
    // 8. 配置 Block 和 Grid
    // ==========================================

    dim3 block(16, 16);

    dim3 grid(
        (imageWidth + block.x - 1) / block.x,
        (imageHeight + block.y - 1) / block.y
    );


    // ==========================================
    // 9. 启动 GPU Kernel
    // ==========================================

    rayHitTestKernel<<<grid, block>>>(
        cameraManager.getDeviceCamera(),
        sceneManager.getDeviceScene(),
        devicePixels,
        imageWidth,
        imageHeight
    );


    // ==========================================
    // 10. 检查 Kernel 执行状态
    // ==========================================

    CHECK(cudaGetLastError());
    CHECK(cudaDeviceSynchronize());


    // ==========================================
    // 11. 将结果复制回 CPU
    // ==========================================

    std::vector<Pixel> hostPixels(pixelCount);

    CHECK(cudaMemcpy(
        hostPixels.data(),
        devicePixels,
        static_cast<size_t>(pixelCount) * sizeof(Pixel),
        cudaMemcpyDeviceToHost
    ));



    // ==========================================
    // 13. 输出测试结果
    // ==========================================

    std::cout << "========== Ray Tracing Test ==========\n";

    std::cout << "Image Width : " << imageWidth << '\n';
    std::cout << "Image Height: " << imageHeight << '\n';
    std::cout << "Pixel Count : " << pixelCount << '\n';

    for (int y = 0; y < imageHeight; y++) {

        for (int x = 0; x < imageWidth; x++) {

            int index = y * imageWidth + x;

            std::cout << rgbToASCII(hostPixels[index]);
        }

        std::cout << '\n';
    }


    // ==========================================
    // 14. 释放 GPU 显存
    // ==========================================

    CHECK(cudaFree(devicePixels));


    std::cout << "Ray tracing test completed.\n";

    std::cin >> std::ws;

    return 0;
}