# Signature-Verification
A MATLAB program to cross verify signatures offline. The program employs Radon transform and Fractal Dimension to classify signatures using KNN to cross verify them. The program used 20 images with 10 belonging to 1 person and remaining to another. The program only cross verifies the signature but does not flag a new signature as 'UNKNOWN'.

To execute the program:
Open 'Feature_Extraction.m' and execute it. 
After this, exectue the file 'Verification.m'. 
There are no images included in this repository. So before executing the program, capture some signatures, copy them to the folder where the program is present and rename them to 1.jpg, 2.jpg, 3.jpg, ...
Also make appropriate changes in the variable 'group' in 'Feature_Extraction.m'.
