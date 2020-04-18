/* leptbox.c
 Build:
  gcc -Wall -std=c99 -I/usr/include/leptonica leptbox.c -o leptbox -llept
 Usage:
  ./leptbox image.name > box.name.txt
 or
  ./leptbox image.name [minarea] [maxarea] > box.name.txt

 Public Domain Mark 1.0
 No Copyright
*/

#include <stdlib.h>
#include <allheaders.h>

unsigned CharacterSegmentation(char* filename, unsigned smin, unsigned smax)
{
    unsigned sbox, snum = 0, snumout = 0;
    PIX * image = pixRead(filename);
    fprintf(stdout, "%08d,%d,%d,%d,%d\n", 0, 0, 0, image->w, image->h);
    PIX * binaryImage = pixConvertTo1(image , 250);
    BOXA* connectedBox = pixConnCompBB(binaryImage, 4);
    snum = connectedBox->n;
    for (int i = 0; i < snum; i++)
    {
        BOX* box = boxaGetBox(connectedBox , i, L_CLONE);
        sbox = (box->w) * (box->h);
        if ((sbox >= smin) && ((smax <= smin) || (sbox < smax)))
        {
            fprintf(stdout, "%08d,%d,%d,%d,%d\n", (i + 1), box->x, box->y, box->w, box->h);
            snumout++;
        }
        boxDestroy(&box);
    }
    pixDestroy(&image);
    pixDestroy(&binaryImage);

    return snumout;
}

int main(int argc, char **argv)
{
    unsigned smin = 0, smax = 0;

    if (argc < 2)
    {
        return ERROR_INT(" Bad args: not <imagein> [minarea=0] [maxarea=0]!", argv[0], 1);
    }
    if (argc > 2) smin = atoi(argv[2]);
    if (argc > 3) smax = atoi(argv[3]);
    smin = CharacterSegmentation(argv[1], smin, smax);
    fprintf(stderr,"Box count = %d\n", smin);
    return 0;
}
