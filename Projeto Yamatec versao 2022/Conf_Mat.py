import pandas as pd
import numpy as np
import torch
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

data = torch.load('work_dir/data_to_Mconf.pt')

train_pred = np.asanyarray(data['train_pred'])
train_corr = np.asanyarray(data['train_corr'])

val_pred = np.asanyarray(data['val_pred'])
val_corr = np.asanyarray(data['val_corr'])

assert np.shape(train_pred) == np.shape(train_corr) == np.shape(val_pred) == np.shape(val_corr)

t_c, t_p, v_c, v_p = [], [], [], []
for item in range(np.shape(val_pred)[0]):
    t_c.extend(train_corr[item])
    t_p.extend(train_pred[item])
    v_c.extend(val_corr[item])
    v_p.extend(val_pred[item])


def conf_matrix(correct, predict, color, phase):
    
    '''
    for item in range(len(predict)):
        predict[item] = predict[item].cpu() 
        correct[item] = correct[item].cpu()
    
    '''
    
    correct = np.asanyarray(correct)
    predict = np.asanyarray(predict)
    
    data = {'y_Actual':    correct,
        'y_Predicted': predict
        }
    
    df = pd.DataFrame(data, columns=['y_Actual','y_Predicted'])
    
    
    confusion_matrix = pd.crosstab(df['y_Actual'], df['y_Predicted'], rownames=['Actual'], colnames=['Predicted'],  normalize='columns')
    print('>> condusion Matrix <<')
    print('Test')
    print(confusion_matrix)
    plt.figure(figsize=(10,8))  
    cf1 = confusion_matrix.to_numpy()
    heatmap = sns.heatmap(confusion_matrix, annot=True, fmt='.2', cmap=color,annot_kws={"size":15})
    plt.title('{} Confusion Matrix'.format(phase))
    plt.show()
    

conf_matrix(t_c, t_p, 'Blues', 'Train')
conf_matrix(v_c, v_p, 'Greens', 'Validation')