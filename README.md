# LeptBox

## Introduction

Select boxes (characters) in the image using leptonica.

## Dependencies

- liblept3

## How to use

- Download this repository

  ```sh
  git https://github.com/ImageProcessing-ElectronicPublications/leptbox.git
  ```

- Compile

  ```sh
  cd leptbox
  make
  ```

- Run  

  Type:
  ```sh
    ./leptbox test.tif > test.tif.box
    Box count = 4780

    cat test.tif.box
  ```
  ```sh
    00000000,1256,40,30,37
    00000001,1327,40,31,40
    00000002,1287,41,35,36
    00000003,1365,41,32,39
    ...
    00004775,288,3337,3,17
    00004776,363,3337,18,20
    00004777,2224,3342,15,36
    00004778,2243,3343,15,36
    00004779,2262,3343,15,36
  ```

  Or:
  ```sh
    ./leptbox test.tif 50 100
    ...
    Box count = 129
  ```

## References

* https://github.com/DanBloomberg/leptonica
* https://github.com/ImageProcessing-ElectronicPublications/leptbox

----

2020
