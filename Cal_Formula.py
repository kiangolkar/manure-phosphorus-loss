import numpy as np
import warnings
warnings.filterwarnings('ignore')

class Cal_Formula_Class:
    def cal_result(Manure_Applied_data ,Runoff_data, Precipitation_data ):
        array_data = np.arange(0, 720 * 360 , 1, np.float32)
        array_data = np.reshape(array_data, (360, 720))

        for i in range(360):
            for j in range(720):
                array_data[i][j] = array_data[i][j]*(Runoff_data[i][j] /Precipitation_data[i][j])*pow((Runoff_data[i][j] /Precipitation_data[i][j]), 0.225)
        return array_data