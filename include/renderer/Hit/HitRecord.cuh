
#ifndef CUDA_ASCII_3D_RENDERER_HITRECORD_CUH
#define CUDA_ASCII_3D_RENDERER_HITRECORD_CUH


struct HitRecord {
    Vector3 point;  //交点
    Vector3 normal; //法线
    float t;        //射线参数
    bool frontFace; //是否击中物体正面
};

inline std::ostream& operator<<(std::ostream& os, const HitRecord& rec) {
    os << "point: " << rec.point << std::endl;
    os << "normal: " << rec.normal << std::endl;
    os << "t: " << rec.t << std::endl;
    os << "frontFace = " << (rec.frontFace ? "true" : "false") << std::endl;
    return os;
}


#endif //CUDA_ASCII_3D_RENDERER_HITRECORD_CUH
