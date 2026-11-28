//
// Created by 14427 on 2026/11/26.
//

#ifndef CUDA_ASCII_3D_RENDERER_HITTABLE_CUH
#define CUDA_ASCII_3D_RENDERER_HITTABLE_CUH

#include "math/Ray.cuh"
#include "HitRecord.cuh"

class Hittable {
    public:

    virtual ~Hittable() = default;
    
    virtual bool hit(
        const Ray& ray,
        float tMin,
        float tMax,
        HitRecord& record) const = 0;


};


#endif //CUDA_ASCII_3D_RENDERER_HITTABLE_CUH
