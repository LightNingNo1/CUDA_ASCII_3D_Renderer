
#ifndef CUDA_ASCII_3D_RENDERER_HITTABLELIST_CUH
#define CUDA_ASCII_3D_RENDERER_HITTABLELIST_CUH

#include <vector>
#include <memory>
#include "Hittable.cuh"
#include "../Object/Sphere.cuh"

struct HittableList : public Hittable {
    //host端管理几何体
    std::vector<std::shared_ptr<Hittable>> objects;

    //添加
    void add(const std::shared_ptr<Hittable>& object) {
        objects.push_back(object);
    }

    //清空场景
    void clear() {
        objects.clear();
    }

    //是否击中(CPU端)
    bool hit(const Ray& ray,
            float t_min,
            float t_max,
            HitRecord& rec
            ) const override {
        HitRecord tmp_record;
        bool hitAnything = false;
        float closestSqt = t_max;

        for(const std::shared_ptr<Hittable>& object : objects) {
            if (object->hit(ray, t_min, closestSqt, tmp_record)) {
                hitAnything = true;
                closestSqt = tmp_record.t;
                rec = tmp_record;
            }
        }

        return hitAnything;
    }
};


#endif //CUDA_ASCII_3D_RENDERER_HITTABLELIST_CUH
