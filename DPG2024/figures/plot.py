from typing import Callable

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns
from scipy import odr, stats
import math

def Linear_fun(slope : float, bias: float) -> Callable:
    return lambda x: slope * x + bias

def Trig_fun(power: float, k : float) -> Callable:
    return lambda x : (math.cos(k * x) + 1) ** power

class Random_Gen:
    def __init__(self, call_back : Callable):
        self.call_back = call_back
        self.rng = np.random.default_rng(66666)
        self.dataframe = pd.DataFrame()
        self.xerror_min = 0
        self.xerror_max = 0
        self.yerror_min = 0
        self.yerror_max = 0

    def set_xerror(self, min: float, max: float):
        self.xerror_min = min
        self.xerror_max = max

    def set_yerror(self, min: float, max: float):
        self.yerror_min = min
        self.yerror_max = max

    def __generate_random(self, means: np.ndarray, errs: np.ndarray) -> np.ndarray:
        if len(means) != len(errs):
            raise ValueError("size of mean values is not equal to the size of errors!")
        return np.array([self.rng.normal(loc = mean, scale = err) for mean, err in zip(means, errs)])

    def __generate_xerr(self, num:int) -> np.ndarray:
        errs = self.rng.random(num)
        errs = np.multiply(errs, self.xerror_max - self.xerror_min)
        errs = np.add(errs, self.xerror_min)
        return errs

    def __generate_yerr(self, num:int) -> np.ndarray:
        errs = self.rng.random(num)
        errs = np.multiply(errs, self.yerror_max - self.yerror_min)
        errs = np.add(errs, self.yerror_min)
        return errs

    def __call__(self, size : int, x_min: float, x_max: float):
        x_err = self.__generate_xerr(size)
        y_err = self.__generate_yerr(size)
        x_mean = np.linspace(start = x_min, stop = x_max, num = size, dtype = float)
        y_mean = np.array(list(map(self.call_back, x_mean)))

        if np.any(np.iscomplex(y_mean)):
            print(y_mean)
            raise ValueError("Complex error occured!")

        x = self.__generate_random(means = x_mean, errs = x_err)
        y = self.__generate_random(means = y_mean, errs = y_err)
        self.dataframe = pd.DataFrame({'x': x, 'x_err': x_err, 'y': y, 'y_err': y_err})

    def SaveToCsv(self, filename : str):
        self.dataframe.to_csv(filename, index = False, float_format = '%.3f')

class ODR_fitter:
    def __init__(self, dataframe : pd.DataFrame):
        self.dataframe = dataframe
        self.dataframe.replace(0, np.nan, inplace = True)

    def fit(self, fnt : Callable, inits : list[float]):
        self.fnt = fnt
        if self.dataframe.empty:
            raise ValueError("Cannot fit empty data!")
        model = odr.Model(self.fnt)
        data = odr.RealData(x = self.dataframe['x'], y = self.dataframe['y'], sx = self.dataframe['x_err'], sy = self.dataframe['y_err'])
        self.odr_reg = odr.ODR(data, model, beta0 = inits)
        self.res = self.odr_reg.run()
        res_var = self.odr_reg.output.__getattribute__('res_var')
        self.p_value = 1 - stats.chi2.cdf(res_var, df = 1)

    def save_plot(self, filename : str, title : str = ""):
        sns.scatterplot(data = self.dataframe, x= 'x', y = 'y', label = "Data")
        dataframe = self.dataframe.replace(np.nan, 0)
        # plt.errorbar(dataframe['x'], dataframe['y'], 
        #              xerr = dataframe['x_err'], yerr = dataframe['y_err'], 
        #              linestyle = 'None', capsize = 5.0)
        plt.errorbar(dataframe['x'], dataframe['y'], 
                      yerr = dataframe['y_err'], 
                     linestyle = 'None', capsize = 5.0)
        fitted_fun = lambda x: self.fnt(self.res.beta, x)
        x_range = dataframe['x'].iloc[[0, -1]].values
        x = np.linspace(x_range[0], x_range[1], 1000)
        plt.plot(x, fitted_fun(x), color = 'r', label = "Regression line")
        plt.plot([], [], linestyle = 'None')
        if title:
            plt.title(title)
        plt.legend(loc = "upper left")
        plt.xlabel("t", fontsize = 20)
        plt.ylabel("x", fontsize = 20)
        plt.xticks([])
        plt.yticks([])
        plt.savefig(filename, dpi = 150)
        plt.close()

    def print(self):
            print("===============fitting result:=================")
            self.res.pprint()
            print("p-value: %.2f%%" % (100 * self.p_value))
            print("===============================================")

if __name__ == "__main__":
    generator = Random_Gen(Linear_fun(2.3, 5.2))
    generator.set_xerror(min = 0.5, max = 1.2)
    generator.set_yerror(min = 4, max = 5)
    generator(size = 8, x_min = 2, x_max = 23)
    generator.SaveToCsv("data.csv")




    dataframe = pd.read_csv('data.csv')
    linear_fitter = ODR_fitter(dataframe)
    linear_fitter.fit(fnt = lambda p,x : p[0]* x + p[1], inits = [1., 0.])
    linear_fitter.print()
    linear_fitter.save_plot('fitting_plot.png')
