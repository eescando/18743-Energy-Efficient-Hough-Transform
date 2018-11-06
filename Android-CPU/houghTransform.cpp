#include <algorithm>
#include <cmath>
#include <cstring>
#include <iostream>
#include <stdint.h>
#include <stdio.h>
#include "fpmath/include/fpml/fixed_point.h"
using namespace std;
using namespace fpml;

#define NUM_CHANNELS 3
#define MAT_LEN 256
#define FILT_LEN 3
#define R_SHIFT 2
#define G_SHIFT 1
#define B_SHIFT 2
#define RHO_RES 2
#define RHO_LEN 181
#define THETA_RES 2
#define THETA_LEN 180
#define NUM_LINES 50
#define NUM_LINE_DIMS 2
#define PI 3.14159265
#define MAX_PIXEL_VALUE 255
#define FIXED_PT_PRECISION 16

typedef fixed_point<int,FIXED_PT_PRECISION> fp;

void rgb2gray( unsigned char matrix[MAT_LEN][MAT_LEN][NUM_CHANNELS], fp result[MAT_LEN][MAT_LEN] );
void conv2D( fp matrix[MAT_LEN][MAT_LEN], fp kernel[FILT_LEN][FILT_LEN], fp result[MAT_LEN][MAT_LEN] );
void blur( fp matrix[MAT_LEN][MAT_LEN], fp result[MAT_LEN][MAT_LEN] );
void gradient( fp matrix[MAT_LEN][MAT_LEN], fp grad_x[MAT_LEN][MAT_LEN], fp grad_y[MAT_LEN][MAT_LEN] );
void magnitude( fp x[MAT_LEN][MAT_LEN], fp y[MAT_LEN][MAT_LEN], fp mag[MAT_LEN][MAT_LEN] );
void angle( fp x[MAT_LEN][MAT_LEN], fp y[MAT_LEN][MAT_LEN], int angle[MAT_LEN][MAT_LEN] );
void threshold( fp matrix[MAT_LEN][MAT_LEN], fp result[MAT_LEN][MAT_LEN], fp threshold);
void nms( fp mag[MAT_LEN][MAT_LEN], int angle[MAT_LEN][MAT_LEN], fp result[MAT_LEN][MAT_LEN] );
void houghTransform( fp matrix[MAT_LEN][MAT_LEN], int accum[RHO_LEN][THETA_LEN] );
void houghLines( int accum[RHO_LEN][THETA_LEN], int lines[NUM_LINES][NUM_LINE_DIMS] );
int main ( int argc, char *argv[] );


// converts RGB matrix into normalized grayscale matrix
void rgb2gray( unsigned char matrix[MAT_LEN][MAT_LEN][NUM_CHANNELS], fp result[MAT_LEN][MAT_LEN] )
{
    int i,j,k;
    for(i = 0; i < MAT_LEN; i++)
    {
        for(j = 0; j < MAT_LEN; j++)
        {
            result[i][j] = ( (matrix[i][j][0]>>R_SHIFT) + (matrix[i][j][1]>>G_SHIFT) +
                           (matrix[i][j][2]>>B_SHIFT) ) / MAX_PIXEL_VALUE;
        }
    }
}

// performs 2D convolution with an input matrix and kernel
void conv2D( fp matrix[MAT_LEN][MAT_LEN], fp kernel[FILT_LEN][FILT_LEN], fp result[MAT_LEN][MAT_LEN] )
{
    fp cur_pixel;
    int row,col,i,j,m,n;
    for(i = 0; i < MAT_LEN; i++)
    {
        for(j = 0; j < MAT_LEN; j++)
        {
            cur_pixel = 0;
            for(m = FILT_LEN-1; m >= 0; m--)
            {
                for(n = FILT_LEN-1; n >= 0; n--)
                {
                    row = i + m - (FILT_LEN/2);
                    col = j + m - (FILT_LEN/2);
                    if((row>=0) && (row<MAT_LEN) && (col>=0) && (col<MAT_LEN))
                    {
                        cur_pixel += matrix[i][j] * kernel[m][n];
                    }
                }
            }
            result[i][j] = cur_pixel;
        }
    }
}

// performs Gaussian blurring on the image
void blur( fp matrix[MAT_LEN][MAT_LEN], fp result[MAT_LEN][MAT_LEN] )
{
    fp gaussian_kernel[FILT_LEN][FILT_LEN] =
    {
        {1.0/16.0, 2.0/16.0, 1.0/16.0},
        {2.0/16.0, 4.0/16.0, 2.0/16.0},
        {1.0/16.0, 2.0/16.0, 1.0/16.0}
    };

    conv2D(matrix, gaussian_kernel, result);
}

// computes the gradients in the x and y directions
void gradient( fp matrix[MAT_LEN][MAT_LEN], fp grad_x[MAT_LEN][MAT_LEN], fp grad_y[MAT_LEN][MAT_LEN] )
{
    fp sobel_x[FILT_LEN][FILT_LEN] =
    {
        {-1, 0, 1},
        {-2, 0, 2},
        {-1, 0, 1}
    };

    fp sobel_y[FILT_LEN][FILT_LEN] =
    {
        {1,  2,  1},
        {0,  0,  0},
        {-1, -2, -1}
    };

    conv2D(matrix, sobel_x, grad_x);
    conv2D(matrix, sobel_y, grad_y);
}

// computes the magnitude of the gradient at every pixel
void magnitude( fp x[MAT_LEN][MAT_LEN], fp y[MAT_LEN][MAT_LEN], fp mag[MAT_LEN][MAT_LEN] )
{
    int i,j;
    for(i = 0; i < MAT_LEN; i++)
    {
        for(j = 0; j < MAT_LEN; j++)
        {
            mag[i][j] = sqrt((x[i][j]*x[i][j]) + (y[i][j]*y[i][j]));
        }
    }
}

// computes the angle of the gradient at every pixel, rounds to nearest 45 degrees
void angle( fp x[MAT_LEN][MAT_LEN], fp y[MAT_LEN][MAT_LEN], int angle[MAT_LEN][MAT_LEN] )
{
    int i,j;
    for(i = 0; i < MAT_LEN; i++)
    {
        for(j = 0; j < MAT_LEN; j++)
        {
            fp cur_angle = fp(atan2(((int)y[i][j])<<16, ((int)x[i][j])<<16)) * fp(180 / PI);
            angle[i][j] = (int)round(cur_angle / fp(45));
        }
    }
}

// thresholds all pixel values to 0 or 1
void threshold( fp matrix[MAT_LEN][MAT_LEN], fp result[MAT_LEN][MAT_LEN], fp threshold )
{
    int i,j;
    for(i = 0; i < MAT_LEN; i++)
    {
        for(j = 0; j < MAT_LEN; j++)
        {
            result[i][j] = (matrix[i][j] >= threshold);
        }
    }
}

// Non-maximal suppression - compare current pixel of mag to two neighbors along
// the gradient direction, zero out the pixel if it is not larger than both
// neighbors to isolate the maxima
void nms( fp mag[MAT_LEN][MAT_LEN], int angle[MAT_LEN][MAT_LEN], fp result[MAT_LEN][MAT_LEN] )
{
    memcpy(&result, &mag, MAT_LEN*MAT_LEN*sizeof(fp));

    int i,j;
    for(i = 0; i < MAT_LEN; i++)
    {
        for(j = 0; j < MAT_LEN; j++)
        {
            switch(angle[i][j])
            {
                case 0:
                    {
                        if( (i>0 && mag[i][j]<=mag[i-1][j]) || (i<(MAT_LEN-1) && mag[i][j]<=mag[i+1][j]) )
                        {
                            result[i][j] = 0;
                        }
                        break;
                    }
                case 45:
                    {
                        if( (i>0 && j>0 && mag[i][j]<=mag[i-1][j-1]) || (i<(MAT_LEN-1) && j<(MAT_LEN-1) && mag[i][j]<=mag[i+1][j+1]) )
                        {
                            result[i][j] = 0;
                        }
                    }
                case 90:
                    {
                        if( (j>0 && mag[i][j]<=mag[i][j-1]) || (j<(MAT_LEN-1) && mag[i][j]<=mag[i][j+1]) )
                        {
                            result[i][j] = 0;
                        }
                    }
                case 135:
                    {
                        if( (i>0 && j<(MAT_LEN-1) && mag[i][j]<=mag[i-1][j+1]) || (i<(MAT_LEN-1) && j>0 && mag[i][j]<=mag[i+1][j-1]) )
                        {
                            result[i][j] = 0;
                        }
                    }
                default: break;
            }
        }
    }
}

// compute the Hough Transform of the input image and store the Hough result
// for each value of rho and theta in the output accumulator matrix
void houghTransform( fp matrix[MAT_LEN][MAT_LEN], int accum[RHO_LEN][THETA_LEN] )
{
    int rho_max = RHO_RES * RHO_LEN;
    int theta_max = THETA_RES * THETA_LEN; // theta is in degrees

    int i,j,theta;
    for(i = 0; i < MAT_LEN; i++)
    {
        for(j = 0; j < MAT_LEN; j++)
        {
            for(theta = 0; theta < theta_max; theta+=THETA_RES)
            {
                fp theta_rad = fp(theta) * fp(PI / 180);
                if(matrix[i][j] > fp(0))
                {
                    fp rho_val = (fp(j) * cos(theta_rad)) + (fp(i) * sin(theta_rad));
                    int rho_bin = RHO_RES * int(rho_val/fp(RHO_RES));
                    int theta_bin = THETA_RES * int(theta/THETA_RES);
                    accum[rho_bin][theta_bin]++;
                    if(accum[rho_bin][theta_bin] > MAX_PIXEL_VALUE)
                    {
                        accum[rho_bin][theta_bin] = MAX_PIXEL_VALUE;
                    }
                }
            }
        }
    }
}

// sort the lines in the accumulator matrix and extract the NUM_LINES strongest
// lines; store the row and column of each these lines in the output matrix
void houghLines( int accum[RHO_LEN][THETA_LEN], int lines[NUM_LINES][NUM_LINE_DIMS] )
{
    int vect_size = RHO_LEN * THETA_LEN;
    int (&accum_vector)[vect_size] = *reinterpret_cast<int(*)[vect_size]>(accum);
    int accum_sorted[vect_size];
    memcpy(&accum_sorted, accum_vector, vect_size*sizeof(int));

    sort(accum_sorted, accum_sorted + vect_size);

    int i;
    for(i = 0; i < NUM_LINES; i++)
    {
        // find the position of the point in the accum_vector
        int index = distance(accum_vector,find(accum_vector,accum_vector+vect_size,accum_sorted[i]));
        // convert this position to (row,col) format and store in lines matrix
        int rho = index / RHO_LEN;
        int theta = index % THETA_LEN;
        lines[i][0] = rho;
        lines[i][1] = theta;
    }
}

int main ( int argc, char *argv[] )
{
    unsigned char matrix[MAT_LEN][MAT_LEN][NUM_CHANNELS];
    for(int i = 0; i < MAT_LEN; i++)
    {
        for(int j = 0; j < MAT_LEN; j++)
        {
            for(int k = 0; k < NUM_CHANNELS; k++)
            {
                matrix[i][j][k] = 0;
            }
        }
    }

    fp gray[MAT_LEN][MAT_LEN] = {0};
    fp blurred[MAT_LEN][MAT_LEN] = {0};
    fp grad_x[MAT_LEN][MAT_LEN] = {0};
    fp grad_y[MAT_LEN][MAT_LEN] = {0};


    rgb2gray(matrix, gray);
    blur(gray, blurred);
    gradient(blurred, grad_x, grad_y);

    // Step 1: RGB-to-Gray Conversion
    // Step 2: Gaussian Blur
    // Step 3: Compute the Image Gradient
    // Step 4: Find the Magnitude and Angle of the Gradient
    // Step 5: Threshold based on Gradient Magnitude
    // Step 6: Non-maximal Suppression on Gradient Magnitude
    // Step 7: Hough Transform
    // Step 8: Non-maximal Suppression on Accumulator Matrix
    // Step 9: Hough Lines
    // Step 10: Draw Lines


  return 0;
}
