import numpy as np
import warnings
warnings.filterwarnings('ignore')
import netCDF4

class Precipitation_class:

    def file_reader_monthly(path_file):
        file2read_rn = netCDF4.Dataset(path_file, 'r')

        min_val = np.array(file2read_rn['precip'][0:12]).min()
        max_val = np.array(file2read_rn['precip'][0:12]).max()
        mean_val = np.array(file2read_rn['precip'][0:12]).mean()

        array_rn = np.arange(0, 720 * 360, 1, np.uint8)
        array_rn = np.reshape(array_rn, (360, 720))

        for time in range(12):
            print(time)
            for lat in range(360):
                for lon in range(720):
                    try:
                        array_rn[lat][lon] = array_rn[lat][lon] + float(file2read_rn['pr'][time][lat][lon].T)
                    except:
                        array_rn[lat][lon] = array_rn[lat][lon] + mean_val


    def file_reader_yearly(path_file):
        file2read_rn = netCDF4.Dataset(path_file, 'r')

        min_val = np.array(file2read_rn.variables['pr']).min()
        max_val = np.array(file2read_rn.variables['pr']).max()
        mean_val = np.array(file2read_rn.variables['pr']).mean()

        array_rn = np.arange(0, 720 * 360, 1, np.uint8)
        array_rn = np.reshape(array_rn, (360, 720))

        for time in range(364):
            print(time)
            for lat in range(360):
                for lon in range(720):
                    try:
                        array_rn[lat][lon] = array_rn[lat][lon] + float(file2read_rn.variables['pr'][time][lat][lon].T)
                    except:
                        array_rn[lat][lon] = array_rn[lat][lon] + mean_val