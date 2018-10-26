# include <cstdlib>
# include <iostream>
# include <stdint.h>
# include <stdio.h>
# include <cmath>
# include "jpeglib.h"
using namespace std;

#define NUM_CHANNELS 3
#define MAT_LEN 256
#define FILT_LEN 3
#define R_SHIFT 2
#define G_SHIFT 1
#define B_SHIFT 2
#define PI 3.14159265
#define MAX_PIXEL_VALUE 255

void rgb2gray( unsigned char ***matrix, double **result );
void conv2D( double **matrix, double kernel[FILT_LEN][FILT_LEN], double **result );
void blur( double **matrix, double **result );
void gradient( double **matrix, double **grad_x, double **grad_y );
void magnitude( double **x, double **y, double **mag );
void angle( double **x, double **y, int ** angle );
void threshold( double **matrix, double **result, double threshold);
int main ( int argc, char *argv[] );


// converts RGB matrix into normalized grayscale matrix
void rgb2gray( unsigned char ***matrix, double **result )
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
void conv2D( double **matrix, double kernel[FILT_LEN][FILT_LEN], double **result )
{
    double cur_pixel;
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
void blur( double **matrix, double **result )
{
    double gaussian_kernel[FILT_LEN][FILT_LEN] =
    {
        {1.0/16.0, 2.0/16.0, 1.0/16.0},
        {2.0/16.0, 4.0/16.0, 2.0/16.0},
        {1.0/16.0, 2.0/16.0, 1.0/16.0}
    };

    conv2D(matrix, gaussian_kernel, result);
}

// computes the gradients in the x and y directions
void gradient( double **matrix, double **grad_x, double **grad_y )
{
    double sobel_x[FILT_LEN][FILT_LEN] =
    {
        {-1, 0, 1},
        {-2, 0, 2},
        {-1, 0, 1}
    };

    double sobel_y[FILT_LEN][FILT_LEN] =
    {
        {1,  2,  1},
        {0,  0,  0},
        {-1, -2, -1}
    };

    conv2D(matrix, sobel_x, grad_x);
    conv2D(matrix, sobel_y, grad_y);
}

// computes the magnitude of the gradient at every pixel
void magnitude( double **x, double **y, double **mag )
{
    int i,j;
    for(i = 0; i < MAT_LEN; i++)
    {
        for(j = 0; j < MAT_LEN; j++)
        {
            mag[i][j] = sqrt(pow(x[i][j],2) + pow(y[i][j],2));
        }
    }
}

// computes the angle of the gradient at every pixel, rounds to nearest 45 degrees
void angle( double **x, double **y, int **angle )
{
    int i,j;
    for(i = 0; i < MAT_LEN; i++)
    {
        for(j = 0; j < MAT_LEN; j++)
        {
            double cur_angle = atan2(y[i][j], x[i][j]) * 180 / PI;
            angle[i][j] = (int)round(cur_angle / 45);
        }
    }
}

// thresholds all pixel values to 0 or 1
void threshold( double **matrix, double **result, double threshold )
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

int main ( int argc, char *argv[] )
{
    cout.precision(8);

    unsigned char ***matrix;
    matrix = new unsigned char **[MAT_LEN];
    for(int i = 0; i < MAT_LEN; i++)
    {
        matrix[i] = new unsigned char *[MAT_LEN];
        for(int j = 0; j < NUM_CHANNELS; j++)
        {
            matrix[i][j] = new unsigned char [NUM_CHANNELS];
        }
    }

    double **gray = {0};
    double **blurred = {0};
    double **grad_x = {0};
    double **grad_y = {0};


    rgb2gray(matrix, gray);
    blur(gray, blurred);
    gradient(blurred, grad_x, grad_y);


  return 0;
}
