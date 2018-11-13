#include <algorithm>
#include <cmath>
#include <cstring>
#include <fstream>
#include <iostream>
#include <map>
#include <stdint.h>
#include <stdio.h>
#include <string>
#include "fpmath/include/fpml/fixed_point.h"
using namespace std;
using namespace fpml;

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
#define FIXED_PT_PRECISION 16

typedef fixed_point<int,FIXED_PT_PRECISION> fp;

void readFrame( string filename, unsigned char matrix[MAT_LEN][MAT_LEN][NUM_CHANNELS] );
void rgb2gray( unsigned char matrix[MAT_LEN][MAT_LEN][NUM_CHANNELS], fp result[MAT_LEN][MAT_LEN] );
void conv2D( fp matrix[MAT_LEN][MAT_LEN], fp kernel[FILT_LEN][FILT_LEN], fp result[MAT_LEN][MAT_LEN] );
void blur( fp matrix[MAT_LEN][MAT_LEN], fp result[MAT_LEN][MAT_LEN] );
void gradient( fp matrix[MAT_LEN][MAT_LEN], fp grad_x[MAT_LEN][MAT_LEN], fp grad_y[MAT_LEN][MAT_LEN] );
void findMag( fp x[MAT_LEN][MAT_LEN], fp y[MAT_LEN][MAT_LEN], fp mag[MAT_LEN][MAT_LEN] );
void findAngle( fp x[MAT_LEN][MAT_LEN], fp y[MAT_LEN][MAT_LEN], int angle[MAT_LEN][MAT_LEN] );
void applyThreshold( fp matrix[MAT_LEN][MAT_LEN], fp result[MAT_LEN][MAT_LEN], fp threshold);
void nmsGrad( fp mag[MAT_LEN][MAT_LEN], int angle[MAT_LEN][MAT_LEN], fp result[MAT_LEN][MAT_LEN] );
void houghTransform( fp matrix[MAT_LEN][MAT_LEN], int accum[RHO_LEN][THETA_LEN] );
void nmsAccum( int accum[RHO_LEN][THETA_LEN], int result[RHO_LEN][THETA_LEN] );
void houghLines( int accum[RHO_LEN][THETA_LEN], int lines[NUM_LINES][NUM_LINE_DIMS] );
int main ( int argc, char *argv[] );


void readFrame( string filename, unsigned char matrix[MAT_LEN][MAT_LEN][NUM_CHANNELS] )
{
    string line;
    ifstream infile (filename);
    if(infile.is_open())
    {
        while(getline(infile,line))
        {
            cout << line.length() << '\n';
        }
    }
    infile.close();

    map<unsigned char, unsigned char> asciiToHex = {
        {'0',0x0}, {'1',0x1}, {'2',0x2}, {'3',0x3},
        {'4',0x4}, {'5',0x5}, {'6',0x6}, {'7',0x7},
        {'8',0x8}, {'9',0x9}, {'A',0xa}, {'B',0xb},
        {'C',0xc}, {'D',0xd}, {'E',0xe}, {'F',0xf}};

    int index, row, col, channel;
    unsigned char str, str1, str2;
    for(index = 0; index < MAT_LEN*MAT_LEN*NUM_CHANNELS*2; index +=2)
    {
        row = (index/2) / (MAT_LEN*NUM_CHANNELS);
        col = ((index/2) / NUM_CHANNELS) % MAT_LEN;
        channel = (index/2) % NUM_CHANNELS;
        str = (asciiToHex[line.at(index)] << 4) | asciiToHex[line.at(index+1)];
        matrix[row][col][channel] = str;
    }
}

// converts RGB matrix into normalized grayscale matrix
void rgb2gray( unsigned char matrix[MAT_LEN][MAT_LEN][NUM_CHANNELS], fp result[MAT_LEN][MAT_LEN] )
{
    int i,j,k;
    for(i = 0; i < MAT_LEN; i++)
    {
        for(j = 0; j < MAT_LEN; j++)
        {
            result[i][j] = ( fp(matrix[i][j][0]*R_RATIO) + fp(matrix[i][j][1]*G_RATIO) +
                           fp(matrix[i][j][2]*B_RATIO) ) / fp(MAX_PIXEL_VALUE);
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
void findMag( fp x[MAT_LEN][MAT_LEN], fp y[MAT_LEN][MAT_LEN], fp mag[MAT_LEN][MAT_LEN] )
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
void findAngle( fp x[MAT_LEN][MAT_LEN], fp y[MAT_LEN][MAT_LEN], int angle[MAT_LEN][MAT_LEN] )
{
    int i,j;
    for(i = 0; i < MAT_LEN; i++)
    {
        for(j = 0; j < MAT_LEN; j++)
        {
            fp cur_angle = fp(atan2(((int)y[i][j])<<16, ((int)x[i][j])<<16)) * fp(180 / PI);
            angle[i][j] = (int)abs(45 * round(double(cur_angle / fp(45))));
        }
    }
}

// thresholds all pixel values to 0 or 1
void applyThreshold( fp matrix[MAT_LEN][MAT_LEN], fp result[MAT_LEN][MAT_LEN], fp threshold )
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
void nmsGrad( fp mag[MAT_LEN][MAT_LEN], int angle[MAT_LEN][MAT_LEN], fp result[MAT_LEN][MAT_LEN] )
{
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
                default: result[i][j] = mag[i][j];
                    break;
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
                    int rho_bin = RHO_RES * abs(int(rho_val/fp(RHO_RES)));
                    int theta_bin = min(THETA_RES * int(theta/THETA_RES), theta_max);
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

// Non-maximal suppression - compare current pixel of accum to its neighbors,
// zero out the pixel if it is not greater than all of its neighbors
void nmsAccum( int accum[RHO_LEN][THETA_LEN], int result[RHO_LEN][THETA_LEN] )
{
    int i,j;
    for(i = 0; i < RHO_LEN; i++)
    {
        for(j = 0; j < THETA_LEN; j++)
        {
            if((i>0) && (j>0) && (accum[i][j]<=accum[i-1][j-1])) result[i][j] = 0; // NW neighbor
            else if((i>0) && (accum[i][j]<=accum[i-1][j])) result[i][j] = 0; // N neighbor
            else if((i>0) && (j<(THETA_LEN-1)) && (accum[i][j]<=accum[i-1][j+1])) result[i][j] = 0; // NE neighbor
            else if((j>0) && (accum[i][j]<=accum[i][j-1])) result[i][j] = 0; // W neighbor
            else if((j<(THETA_LEN-1)) && (accum[i][j]<=accum[i][j+1])) result[i][j] = 0; // E neighbor
            else if((i<(RHO_LEN-1)) && (j>0) && (accum[i][j]<=accum[i+1][j-1])) result[i][j] = 0; // SW neighbor
            else if((i<(RHO_LEN-1)) && (accum[i][j]<=accum[i+1][j])) result[i][j] = 0; // S neighbor
            else if((i<(RHO_LEN-1)) && (j<(THETA_LEN-1)) && (accum[i][j]<=accum[i+1][j+1])) result[i][j] = 0; // SE neighbor
            else result[i][j] = accum[i][j];
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
        int index = distance(accum_vector,find(accum_vector,accum_vector+vect_size,accum_sorted[vect_size-i-1]));
        // convert this position to (row,col) format and store in lines matrix
        int rho = index / RHO_LEN;
        int theta = index % THETA_LEN;
        lines[i][0] = rho;
        lines[i][1] = theta;
    }
}

int main ( int argc, char *argv[] )
{
    // initialize matrix to read in frame - assuming just one frame for now
    unsigned char matrix[MAT_LEN][MAT_LEN][NUM_CHANNELS];
    readFrame(argv[1], matrix);

    // Step 1: RGB-to-Gray Conversion
    fp gray[MAT_LEN][MAT_LEN];
    rgb2gray(matrix, gray);
    /*ofstream grayfile("gray.txt");
    if(grayfile.is_open())
    {
        for(int i = 0; i < MAT_LEN; i++)
        {
            for(int j = 0; j < MAT_LEN; j++)
            {
                grayfile << double(gray[i][j]) << '\n';
            }
        }
        grayfile.close();
    }*/

    // Step 2: Gaussian Blur
    fp blurred[MAT_LEN][MAT_LEN];
    blur(gray, blurred);
    /*ofstream blurfile("blurred.txt");
    if(blurfile.is_open())
    {
        for(int i = 0; i < MAT_LEN; i++)
        {
            for(int j = 0; j < MAT_LEN; j++)
            {
                blurfile << double(blurred[i][j]) << '\n';
            }
        }
        blurfile.close();
    }*/

    // Step 3: Compute the Image Gradient
    fp grad_x[MAT_LEN][MAT_LEN];
    fp grad_y[MAT_LEN][MAT_LEN];
    gradient(blurred, grad_x, grad_y);
    /*ofstream gradxfile("grad_x.txt");
    if(gradxfile.is_open())
    {
        for(int i = 0; i < MAT_LEN; i++)
        {
            for(int j = 0; j < MAT_LEN; j++)
            {
                gradxfile << double(grad_x[i][j]) << '\n';
            }
        }
        gradxfile.close();
    }
    ofstream gradyfile("grad_y.txt");
    if(gradyfile.is_open())
    {
        for(int i = 0; i < MAT_LEN; i++)
        {
            for(int j = 0; j < MAT_LEN; j++)
            {
                gradyfile << double(grad_y[i][j]) << '\n';
            }
        }
        gradyfile.close();
    }*/

    // Step 4: Find the Magnitude and Angle of the Gradient
    fp mag[MAT_LEN][MAT_LEN];
    int angle[MAT_LEN][MAT_LEN];
    findMag(grad_x, grad_y, mag);
    findAngle(grad_x, grad_y, angle);
    /*ofstream magfile("mag.txt");
    if(magfile.is_open())
    {
        for(int i = 0; i < MAT_LEN; i++)
        {
            for(int j = 0; j < MAT_LEN; j++)
            {
                magfile << double(mag[i][j]) << '\n';
            }
        }
        magfile.close();
    }
    ofstream anglefile("angle.txt");
    if(anglefile.is_open())
    {
        for(int i = 0; i < MAT_LEN; i++)
        {
            for(int j = 0; j < MAT_LEN; j++)
            {
                anglefile << angle[i][j] << '\n';
            }
        }
        anglefile.close();
    }*/

    // Step 5: Threshold based on Gradient Magnitude
    fp threshold = fp(GRAD_THRESH);
    fp thresholded[MAT_LEN][MAT_LEN];
    applyThreshold(mag, thresholded, threshold);
    /*ofstream threshfile("thresh.txt");
    if(threshfile.is_open())
    {
        for(int i = 0; i < MAT_LEN; i++)
        {
            for(int j = 0; j < MAT_LEN; j++)
            {
                threshfile << double(thresholded[i][j]) << '\n';
            }
        }
        threshfile.close();
    }*/

    // Step 6: Non-maximal Suppression on Gradient Magnitude
    fp grad_suppressed[MAT_LEN][MAT_LEN];
    nmsGrad(thresholded, angle, grad_suppressed);
    /*ofstream nmsgradfile("nms_grad.txt");
    if(nmsgradfile.is_open())
    {
        for(int i = 0; i < MAT_LEN; i++)
        {
            for(int j = 0; j < MAT_LEN; j++)
            {
                nmsgradfile << double(grad_suppressed[i][j]) << '\n';
            }
        }
        nmsgradfile.close();
    }*/

    // Step 7: Hough Transform
    int accum[RHO_LEN][THETA_LEN];
    houghTransform(grad_suppressed, accum);
    /*ofstream accumfile("accum.txt");
    if(accumfile.is_open())
    {
        for(int i = 0; i < RHO_LEN; i++)
        {
            for(int j = 0; j < THETA_LEN; j++)
            {
                accumfile << accum[i][j] << '\n';
            }
        }
        accumfile.close();
    }*/

    // Step 8: Non-maximal Suppression on Accumulator Matrix
    int accum_suppressed[RHO_LEN][THETA_LEN];
    nmsAccum(accum, accum_suppressed);
    /*ofstream nmsaccumfile("nms_accum.txt");
    if(nmsaccumfile.is_open())
    {
        for(int i = 0; i < RHO_LEN; i++)
        {
            for(int j = 0; j < THETA_LEN; j++)
            {
                nmsaccumfile << accum_suppressed[i][j] << '\n';
            }
        }
        nmsaccumfile.close();
    }*/

    // Step 9: Hough Lines
    int lines[NUM_LINES][NUM_LINE_DIMS];
    houghLines(accum_suppressed, lines);
    /*ofstream houghfile("hough_lines.txt");
    if(houghfile.is_open())
    {
        for(int i = 0; i < NUM_LINES; i++)
        {
            for(int j = 0; j < NUM_LINE_DIMS; j++)
            {
                houghfile << lines[i][j] << '\n';
            }
        }
        houghfile.close();
    }*/

    // Step 10: Draw Lines


  return 0;
}
