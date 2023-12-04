from Manure_Applied_Class import  manure_Applied
from Precipitation_class import Precipitation_class
from Data_path import Data_path
from dataa import dataa
import numpy as np
import pandas as pd
import cv2
import matplotlib.pyplot as plt

import warnings
warnings.filterwarnings('ignore')

def main_part1():
    use_default = True
    if use_default == False:
        data_Manure_Applied_path = Data_path.data_manure_Applied_path

        Run_off1 = Data_path.Runoff[0]
        Run_off2 = Data_path.Runoff[1]
        Run_off3 = Data_path.Runoff[2]
        Run_off4 = Data_path.Runoff[3]

        Precipitation_1 = Data_path.Precipitation[0]
        Precipitation_2 = Data_path.Precipitation[1]
        Precipitation_3 = Data_path.Precipitation[2]
        Precipitation_4 = Data_path.Precipitation[3]
        Precipitation_5 = Data_path.Precipitation[4]
        Precipitation_6 = Data_path.Precipitation[5]
        Precipitation_7 = Data_path.Precipitation[6]
        Precipitation_8 = Data_path.Precipitation[7]

        data_Manure_Applied = Manure_Applied.file_reader(data_manure_Applied_path)

        data_Precipitation_1 = Precipitation_class.file_reader_yearly(Precipitation_1)
        data_Precipitation_2 = Precipitation_class.file_reader_monthly(Precipitation_2)
        data_Precipitation_3 = Precipitation_class.file_reader_monthly(Precipitation_3)
        data_Precipitation_4 = Precipitation_class.file_reader_yearly(Precipitation_4)
        data_Precipitation_5 = Precipitation_class.file_reader_monthly(Precipitation_5)
        data_Precipitation_6 = Precipitation_class.file_reader_yearly(Precipitation_6)
        data_Precipitation_7 = Precipitation_class.file_reader_monthly(Precipitation_7)
        data_Precipitation_8 = Precipitation_class.file_reader_yearly(Precipitation_8)

        array_data = Make_data.prepare_main_32_data(data_manure_Applied_path,
                                                    data_Precipitation_1,
                                                    data_Precipitation_2,
                                                    data_Precipitation_3,
                                                    data_Precipitation_4,
                                                    data_Precipitation_5,
                                                    data_Precipitation_6,
                                                    data_Precipitation_7,
                                                    data_Precipitation_8)

    else:
        df = pd.read_csv('phosphor_default.csv')
        image = cv2.imread("data/empty.png")
        data_df = df.T

        (0, 0, 0),  # Black
        (255, 255, 255),  # white
        (180, 248, 240),  # light blue
        (155, 255, 135),  # light green
        (249, 255, 50),  # yellow
        (255, 150, 50),  # orange
        (246, 85, 255),  # sorati
        (0, 0, 255),  # blue
        (63, 72, 204)  # purple

        for i in range(360 * 2):
            print(i)
            for j in range(720 * 2):
                if data_df[i][j] == 0 :
                    image[i][j] = [0,0,0]
                elif data_df[i][j] < 0.1:
                    image[i][j] = [255,255,255]
                elif data_df[i][j] < 1:
                    image[i][j] = [181, 249, 246]
                elif data_df[i][j] < 2:
                    image[i][j] = [155,255,135]
                elif data_df[i][j] < 5:
                    image[i][j] = [249, 255, 50]
                elif data_df[i][j] < 10:
                    image[i][j] = [255, 150, 50]
                elif data_df[i][j] < 15:
                    image[i][j] = [246, 85, 255]
                elif data_df[i][j] < 35:
                    image[i][j] = [0, 0, 255]
                elif data_df[i][j]  < 55:
                    image[i][j] = [63, 72, 204]


        from matplotlib.colors import ListedColormap, LinearSegmentedColormap
        from matplotlib import colors

        cmap = ListedColormap(["white", "lightblue", "lightgreen", "yellow", "orange", "pink", "blue", "purple"])
        bounds = [0, 0.1,1,2,5,10,15,35,55]
        norm = colors.BoundaryNorm(bounds, cmap.N)
        plt.imshow(image, cmap=cmap, norm=norm,aspect=None)
        plt.colorbar(shrink=0.5)
        plt.savefig("main1.png", dpi=4000)
        plt.show()
        #
        # im = plt.imread('cmap.png')
        # fig, ax = plt.subplots()
        # newax = fig.add_axes([0.8, 0.8, 0.2, 0.2], anchor='NE', zorder=1)
        # newax.imshow(im)
        # newax.axis('off')
main_part1()






