from PIL import Image
import numpy as np
import warnings
warnings.filterwarnings('ignore')

class Manure_Applied:
  def file_reader(path_file):
    im = Image.open(path_file)
    imarray = np.array(im)

    img_mean = imarray.mean()

    array_img = np.arange(0, 720 * 360, 1, np.float32)
    array_img = np.reshape(array_img, (360, 720))

    for lat in range(360):
      for lon in range(720):
        try:
          array_img[lat][lon] = imarray[lat][lon]
        except:
          array_img[lat][lon] = img_mean
    return array_img
