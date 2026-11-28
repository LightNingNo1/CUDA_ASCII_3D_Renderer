//
// Created by 14427 on 2026/11/28.
//

#ifndef CUDA_ASCII_3D_RENDERER_PIXEL_CUH
#define CUDA_ASCII_3D_RENDERER_PIXEL_CUH


#include <cstdint>
#include <type_traits>

struct Pixel {
    uint8_t r;
    uint8_t g;
    uint8_t b;

    __host__ __device__
    Pixel() : r(0), g(0), b(0) {}

    __host__ __device__
    Pixel(uint8_t r, uint8_t g, uint8_t b)
        : r(r), g(g), b(b) {}

};

static_assert(sizeof(Pixel) == 3);
static_assert(std::is_trivially_copyable<Pixel>::value);

#endif //CUDA_ASCII_3D_RENDERER_PIXEL_CUH
