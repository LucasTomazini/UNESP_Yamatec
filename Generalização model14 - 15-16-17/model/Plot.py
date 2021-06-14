#!/usr/bin/env python
# coding: utf-8

# In[1]:


from sklearn.metrics import confusion_matrix
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np

get_ipython().run_line_magic('matplotlib', 'inline')


# In[2]:


def Conf_Matrix(correct, predict, color, folder):
    col = len(correct)
    row = len(correct[0])
    correct_array = []
    predict_array = []
    for a in range(col):
        for b in range(row):
            #correct_array.append(np.array(correct[a][b]))
            #predict_array.append(np.array(predict[a][b].cpu()))
            correct_array.append(np.array(correct[a][b]).item())
            predict_array.append(np.array(predict[a][b].item()))
    
    correct_array = np.asarray(correct_array)
    predict_array = np.asarray(predict_array)
    
    data = {'y_Actual':    correct_array,
        'y_Predicted': predict_array
        }

    df = pd.DataFrame(data, columns=['y_Actual','y_Predicted'])
    confusion_matrix = pd.crosstab(df['y_Actual'], df['y_Predicted'], rownames=['Actual'], colnames=['Predicted'],  normalize='columns')
    print('>> condusion Matrix <<')
    print('Test')
    print(confusion_matrix)
    plt.figure(figsize=(16,8))
    
    cf1 = confusion_matrix.to_numpy()
    accuracy  = np.trace(cf1) / float(np.sum(cf1))
    stats = '\n\nAccuracy={:0.3f}'.format(accuracy)

    heatmap = sns.heatmap(confusion_matrix, annot=True, fmt='.2', cmap=color,annot_kws={"size":15})
    plt.xlabel(stats)



# In[3]:


def Plot(x_test, title):
    
    plt.subplots(figsize=(15, 10))
    plt.plot(x_test, color='r', label='Test')
    #plt.plot(x_train, color='b', label='Train')
    plt.grid()
    plt.title(title)# + name .format(PROPAG_STEPS, HIDDEN_LAYER, BATCH_SIZE, EPOCHS ))
    plt.xlabel('Epochs')
    plt.ylabel('Loss')
    plt.legend()

    plt.rc('font', size=20)          # controls default text sizes
    plt.rc('axes', titlesize=20)     # fontsize of the axes title
    plt.rc('axes', labelsize=20)    # fontsize of the x and y labels
    plt.rc('xtick', labelsize=20)    # fontsize of the tick labels
    plt.rc('ytick', labelsize=20)    # fontsize of the tick labels
    plt.rc('legend', fontsize=20)    # legend fontsize
    plt.rc('figure', titlesize=25)  # fontsize of the figure title


# In[ ]:




