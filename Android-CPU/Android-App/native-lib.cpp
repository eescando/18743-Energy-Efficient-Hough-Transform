#include <jni.h>
#include <string>
#include "HoughTransform.h"
#include <android/asset_manager.h>
#include <android/asset_manager_jni.h>
#include <chrono>

extern "C" JNIEXPORT jstring JNICALL
Java_com_example_josh_houghtransform_MainActivity_stringFromJNI(
        JNIEnv* env,
        jobject obj,
        jobject assetManager) {

    // store start time
    std::chrono::steady_clock::time_point begin = std::chrono::steady_clock::now();

    int i;
    for(i = 0; i < 5; i++) {
        // initialize matrix to read in frame - assuming just one frame for now
        AAssetManager *mgr = AAssetManager_fromJava(env, assetManager);
        AAsset *file = AAssetManager_open(mgr, "single_bar_frame.hex", AASSET_MODE_BUFFER);
        size_t fileLength = AAsset_getLength(file);
        char *fileContent = new char[fileLength + 1];
        AAsset_read(file, fileContent, fileLength);
        fileContent[fileLength] = '\0';
        std::string line(fileContent);
        unsigned char matrix[MAT_LEN][MAT_LEN][NUM_CHANNELS];
        readFrame(line, matrix);
        delete[] fileContent;

        // Step 1: RGB-to-Gray Conversion
        fp gray[MAT_LEN][MAT_LEN];
        rgb2gray(matrix, gray);

        // Step 2: Gaussian Blur
        fp blurred[MAT_LEN][MAT_LEN];
        blur(gray, blurred);

        // Step 3: Compute the Image Gradient
        fp grad_x[MAT_LEN][MAT_LEN];
        fp grad_y[MAT_LEN][MAT_LEN];
        gradX(blurred, grad_x);
        gradY(blurred, grad_y);

        // Step 4: Find the Magnitude and Angle of the Gradient
        fp mag[MAT_LEN][MAT_LEN];
        int angle[MAT_LEN][MAT_LEN];
        findMag(grad_x, grad_y, mag);
        findAngle(grad_x, grad_y, angle);

        // Step 5: Non-maximal Suppression on Gradient Magnitude
        fp grad_suppressed[MAT_LEN][MAT_LEN];
        nmsGrad(mag, angle, grad_suppressed);

        // Step 6: Threshold based on Gradient Magnitude
        fp threshold = fp(GRAD_THRESH);
        fp thresholded[MAT_LEN][MAT_LEN];
        applyThreshold(grad_suppressed, thresholded, threshold);

        // Step 7: Hough Transform
        int accum[RHO_LEN][THETA_LEN];
        houghTransform(thresholded, accum);

        // Step 8: Non-maximal Suppression on Accumulator Matrix
        int accum_suppressed[RHO_LEN][THETA_LEN];
        nmsAccum(accum, accum_suppressed);

        // Step 9: Hough Lines
        int lines[NUM_LINES][NUM_LINE_DIMS];
        houghLines(accum_suppressed, lines);
    }

    // store end time
    std::chrono::steady_clock::time_point end = std::chrono::steady_clock::now();
    /*std::string hello = "Hello from C++, rho = ";
    hello += to_string(lines[0][0]);
    hello += ", theta = ";
    hello += to_string(lines[0][1]);*/
    std::string hello = "Hough complete for ";
    hello += to_string(i);
    hello += " frames, duration = ";
    hello += to_string((std::chrono::duration_cast<std::chrono::microseconds>(end - begin).count()) /1000000.0);
    hello += " s";
    return env->NewStringUTF(hello.c_str());
}
