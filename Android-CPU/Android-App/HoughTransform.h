//
// Created by Josh on 11/25/2018.
//

#ifndef HOUGHTRANSFORM_HOUGHTRANSFORM_H
#define HOUGHTRANSFORM_HOUGHTRANSFORM_H

#include <algorithm>
#include <cmath>
#include <cstring>
#include <fstream>
#include <iostream>
#include <map>
#include <stdint.h>
#include <stdio.h>
#include <string>
#include <vector>
//#include "fixed_point.h"
using namespace std;
//using namespace fpml;

#define NUM_CHANNELS 3
#define MAT_LEN 256
#define FILT_LEN 3
#define R_RATIO 0.25
#define G_RATIO 0.5
#define B_RATIO 0.25
#define GRAD_THRESH 0.06
#define RHO_RES 2
#define RHO_LEN 181
#define THETA_RES 2
#define THETA_LEN 180
#define NUM_LINES 50
#define NUM_LINE_DIMS 2
#define PI 3.14159265
#define MAX_PIXEL_VALUE 255
//#define FIXED_PT_PRECISION 16

typedef double fp;

void readFrame( string line, unsigned char matrix[MAT_LEN][MAT_LEN][NUM_CHANNELS] );
void rgb2gray( unsigned char matrix[MAT_LEN][MAT_LEN][NUM_CHANNELS], fp result[MAT_LEN][MAT_LEN] );
void conv2D( fp matrix[MAT_LEN][MAT_LEN], fp kernel[FILT_LEN][FILT_LEN], fp result[MAT_LEN][MAT_LEN] );
void blur( fp matrix[MAT_LEN][MAT_LEN], fp result[MAT_LEN][MAT_LEN] );
void gradX( fp matrix[MAT_LEN][MAT_LEN], fp grad_x[MAT_LEN][MAT_LEN] );
void gradY( fp matrix[MAT_LEN][MAT_LEN], fp grad_y[MAT_LEN][MAT_LEN] );
void findMag( fp x[MAT_LEN][MAT_LEN], fp y[MAT_LEN][MAT_LEN], fp mag[MAT_LEN][MAT_LEN] );
void findAngle( fp x[MAT_LEN][MAT_LEN], fp y[MAT_LEN][MAT_LEN], int angle[MAT_LEN][MAT_LEN] );
void applyThreshold( fp matrix[MAT_LEN][MAT_LEN], fp result[MAT_LEN][MAT_LEN], fp threshold);
void nmsGrad( fp mag[MAT_LEN][MAT_LEN], int angle[MAT_LEN][MAT_LEN], fp result[MAT_LEN][MAT_LEN] );
void houghTransform( fp matrix[MAT_LEN][MAT_LEN], int accum[RHO_LEN][THETA_LEN] );
void nmsAccum( int accum[RHO_LEN][THETA_LEN], int result[RHO_LEN][THETA_LEN] );
void houghLines( int accum[RHO_LEN][THETA_LEN], int lines[NUM_LINES][NUM_LINE_DIMS] );
int main ( int argc, char *argv[] );

#endif //HOUGHTRANSFORM_HOUGHTRANSFORM_H
