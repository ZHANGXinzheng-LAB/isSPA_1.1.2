#pragma once

#include <musa_runtime.h>
#include <mufft.h>

#include "constants.h"
#include "DataReader2.h"

__global__ void UpdateSigma(mufftComplex* d_templates, float* d_buf);
__global__ void generate_mask(int l, mufftComplex* mask, float r, float* d_buf, float up, float low);
__global__ void multiCount_dot(int l, mufftComplex* mask, mufftComplex* d_templates, float* constants,
                               float* res);
__global__ void scale_each(int l, mufftComplex* d_templates, float* ems, double* d_sigmas);
__global__ void SQRSum_by_circle(mufftComplex* data, float* ra, float* rb, int nx, int ny, int mode = 0);
__global__ void whiten_Tmp(mufftComplex* data, float* ra, float* rb, int l);
__global__ void whiten_filter_weight_Img(mufftComplex* data, float* ra, float* rb, int nx, int ny, Parameters para);
__global__ void set_0Hz_to_0_at_RI(mufftComplex* data, int nx, int ny);
__global__ void apply_mask(mufftComplex* data, float d_m, float edge_half_width, int l);
__global__ void apply_weighting_function(mufftComplex* data, size_t padding_size, Parameters para);
__global__ void compute_area_sum_ofSQR(mufftComplex* data, float* res, int nx, int ny);
__global__ void compute_sum_sqr(mufftComplex* data, float* res, int nx, int ny);
__global__ void normalize(mufftComplex* d_templates, int nx, int ny, float* means);
__global__ void divided_by_var(mufftComplex* d_templates, int nx, int ny, float* var);
__global__ void substract_by_mean(mufftComplex* d_templates, int nx, int ny, float* means);
__global__ void rotate_IMG(float* d_image, float* d_rotated_image, float e, int nx, int ny);
__global__ void rotate_subIMG(mufftComplex* d_image, mufftComplex* d_rotated_image, float e, int l);
__global__ void split_IMG(float* Ori, mufftComplex* IMG, int nx, int ny, int l, int bx, int overlap);
__global__ void split_IMG(float* Ori, mufftComplex* IMG, int* block_off_x, int* block_off_y, int nx, int ny, int l,
                          int bx, int overlap);
__global__ void compute_corner_CCG(mufftComplex* CCG, mufftComplex* Tl, mufftComplex* IMG, int l,
                                   int block_id);
__global__ void add_CCG_to_sum(mufftComplex* CCG_sum, mufftComplex* CCG, int l, int N_tmp, int block_id);
__global__ void set_CCG_mean(mufftComplex* CCG_sum, int l, int N_tmp, int N_euler);
__global__ void update_CCG(mufftComplex* CCG_sum, mufftComplex* CCG, int l, int block_id);
__global__ void get_peak_and_SUM(mufftComplex* odata, float* res, int l, float d_m);
__global__ void get_peak_pos(mufftComplex* odata, float* res, int l);
__global__ void scale(mufftComplex* data, size_t size, int l2);
__global__ void ri2ap(mufftComplex* data, size_t size);
__global__ void ap2ri(mufftComplex* data);
__global__ void Complex2float(float* f, mufftComplex* c, int nx, int ny);
__global__ void float2Complex(mufftComplex* c, float* f, int nx, int ny);
__global__ void do_phase_flip(mufftComplex* filter, Parameters para, int nx, int ny);
__device__ float CTF_AST(int x1, int y1, int nx, int ny, float apix, float dfu, float dfv, float dfdiff, float dfang,
                         float lambda, float cs, float ampconst, int mode);
