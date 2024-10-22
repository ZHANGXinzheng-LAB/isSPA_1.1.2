# GisSPA_v2.0
In this version, the primary improvement is the correction of the GPU memory leak issue！





******Improvements******

  1.We previously observed that GisSPA might produce inconsistent results on different servers with varying GPU cards and CUDA versions. This issue has now been resolved.
  
  Experimental tests show that this version identifies more correct particles and achieves higher resolution under the same data processing methods (including Class3D, Refine3D, Postprocess, and other subsequent processing).

  2.In this version, when ‘norm_type=1’ is in the config, the computation is performed on the entire image. Experimental tests indicate that the results with ‘norm_type=1’ are better than those with ‘norm_type=0’, with more particles identified.
  
  When ‘norm_type=0’ is used, the large image is divided into smaller (e.g.720x720) sections for computation, and the normalization algorithm is not applied. This setting is suitable for servers with less powerful GPUs, as processing large images can be demanding on the GPU, and omitting normalization can speed up the computation.





******Installation******
  1.The installation method for GisSPA_v2.0 is the same as the original GisSPA version, but pay attention to the paths in the Makefile.
  
  Correct example:
![image](https://github.com/user-attachments/assets/4b328a62-9a84-4eec-91c3-333274e3beb1)


  Note when modifying the path: The first slash in the path is mandatory; it should be followed by the relative path to the HDF5 package from the current directory.
  
  Input “Make” and Press Enter to compile.
  
  After successful compilation, the main executable file will appear in the “build” directory.

  2.Please refer to the bellow websites for installing the HDF5 package and the code compilation method:
https://github.com/Autumn1998/GisSPA

  3.When using GisSPA, you should follow it with a config file and then press Enter. It is normal to see the following warning after pressing Enter when calling the main program:
  ![image](https://github.com/user-attachments/assets/469aa5cb-4b8f-4bc7-ad1a-705ab42c4a22)






******Answers to some frequently asked questions******
  1.Which version should be used to generate HDF projection files?
  
  Use the project3d function from EMAN1. It is preferable not to use EMAN2.

  2.What version was all the Python code written in?
  
  The code was written in Python 2.7. Additionally, all of our Python code that involves STAR files is designed for RELION 3.08 STAR files. If you wish to use RELION 3.1 or RELION 4, you will need to handle the conversion between different versions of RELION STAR files yourself.

  3.How does GisSPA use multiple GPUs?
  
  You can split the entire dataset into multiple parts using the 'first' and 'last' parameters in the config file. Each part can then be processed on a separate GPU.





******Contributor******
Li Rui & Chen Yuanbo & Zhao Mingjie
