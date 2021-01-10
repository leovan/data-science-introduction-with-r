# -*- coding: utf-8 -*-

import numpy as np
import matplotlib.style
import matplotlib as mpl
import matplotlib.pyplot as plt

from sklearn.datasets import load_wine
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression

X, y = load_wine(return_X_y=True)
X_train, X_test, y_train, y_test = \
    train_test_split(X, y, test_size=0.3, random_state=0, stratify=y)

stdsc = StandardScaler()
X_train_std = stdsc.fit_transform(X_train)
X_test_std = stdsc.transform(X_test)

colors = ['blue', 'green', 'red', 'cyan',
          'magenta', 'yellow', 'black',
          'pink', 'lightgreen', 'lightblue',
          'gray', 'indigo', 'orange']

columns = ['Class label', 'Alcohol', 'Malic acid', 'Ash',
           'Alcalinity of ash', 'Magnesium', 'Total phenols',
           'Flavanoids', 'Nonflavanoid phenols', 'Proanthocyanins',
           'Color intensity', 'Hue', 'OD280/OD315 of diluted wines',
           'Proline']

weights, params = [], []
for c in np.arange(-4., 6.):
    lr = LogisticRegression(
        solver='liblinear',
        penalty='l1',
        C=10.**c,
        random_state=0)
    lr.fit(X_train_std, y_train)
    weights.append(lr.coef_[1])
    params.append(10**c)

weights = np.array(weights)

plt.style.use('ggplot')

mpl.rcParams['image.cmap'] = 'viridis'
mpl.rcParams['font.serif'] = 'Source Han Serif'
mpl.rcParams['font.sans-serif'] = 'Source Han Sans'

fig = plt.figure(figsize=(6, 3.2))
ax = plt.subplot(111)

for column, color in zip(range(weights.shape[1]), colors):
    plt.plot(params, weights[:, column],
             label=columns[column + 1],
             color=color)
plt.axhline(0, color='black', linestyle='--', linewidth=3)
plt.xlim([10**(-5), 10**5])
plt.ylabel('weight coefficient')
plt.xlabel('C')
plt.xscale('log')
plt.legend(loc='upper left')
ax.legend(loc='upper center',
          bbox_to_anchor=(1.4, 1),
          ncol=1, fancybox=True)

plt.savefig('wine-lr-regularization.png', dpi=300,
            bbox_inches='tight', pad_inches=0.2)