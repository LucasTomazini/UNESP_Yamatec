#!/usr/bin/env python
# coding: utf-8

# In[1]:


from sklearn.preprocessing import Normalizer
import torch
from torch.utils.data import Dataset, DataLoader, TensorDataset
import numpy as np
from model import GGNN
import torch.nn as nn
import time
import sys
from tqdm import tqdm


# In[2]:


def Train(EPOCHS, TrainDataset, model, STEPS_PER_EPOCH, adj_matrices, dist_matrices, BATCH_SIZE):
    
    criterion = nn.CrossEntropyLoss()
    optimizer = torch.optim.Adam(model.parameters())
    
    trainLoader = torch.utils.data.DataLoader(TrainDataset, batch_size=BATCH_SIZE, shuffle=True)
    
    start_time = time.time()

    epoch_loss = []
    loss_ls = []
    predict = []
    correct = []
    acc = []
    lss = []
    for epoch in range(EPOCHS):
        with tqdm(total=STEPS_PER_EPOCH, file=sys.stdout) as pbar:
            model.train()
            acc_ep = []
            loss_ep = []

            for step in range(STEPS_PER_EPOCH):
                # Get batch data
                X, T, idx = next(iter(trainLoader))
                A = adj_matrices[idx]
                D = dist_matrices[idx]
                # Forward pass: Compute predicted y by passing x to the model
                Y = model(X.cuda(), A.cuda()) #<<<<<<<<<<<<<
                # Compute loss
                loss1 = criterion(Y, T.cuda())

                loss = loss1
                predictions = torch.exp(Y).argmax(-1)

                ld = []
                for x in range(len(T)):
                    a = predictions[x].item()
                    b = T[x].item()
                    dist = D[0][a][b].item()
                    ld.append(dist/100)
                ld = np.array(ld)
                norm = np.linalg.norm(ld)
                normal_ld = ld/norm
                factor = normal_ld.sum()/len(normal_ld)

                aux = 0
                for j in range(len(T)):

                    if T[j].item() == predictions[j].item():
                        aux += 1

                acc_ep.append(aux/len(T))

                optimizer.zero_grad()
                loss.backward()
                optimizer.step()

                epoch_loss.append(loss.item())
                loss_ls.append(loss.item())

                loss_ep.append(loss.item())

                predict.append(predictions)
                correct.append(T)
                tm = round(((time.time() - start_time)/60),1)

                pbar.set_description('Epoch: {} - Loss: {} - Total_Time: {} mins'.format(epoch+1, round(loss.item(),2), tm))
                pbar.update(1)
            acc.append(np.array(acc_ep).mean())
            lss.append(np.array(loss_ep).mean())
        
        statistics = {'loss_ls': lss, 'accuracy': acc, 'correct': correct, 'predict': predict}

    return model, optimizer, statistics


# In[3]:


def Test(EPOCHS, TestDataset, model, STEPS_PER_EPOCH, adj_matrices, dist_matrices, BATCH_SIZE):
    criterion = nn.CrossEntropyLoss()
    optimizer = torch.optim.Adam(model.parameters())
    
    testLoader = torch.utils.data.DataLoader(TestDataset, batch_size=BATCH_SIZE, shuffle=True)
    
    start_time = time.time()

    epoch_loss = []
    loss_ls = []
    predict = []
    correct = []
    acc = []
    lss = []
    for epoch in range(EPOCHS):
        with tqdm(total=STEPS_PER_EPOCH, file=sys.stdout) as pbar:
            model.eval()
            acc_ep = []
            loss_ep = []

            for step in range(STEPS_PER_EPOCH):
                # Get batch data
                X, T, idx = next(iter(testLoader))
                A = adj_matrices[idx]
                D = dist_matrices[idx]
                # Forward pass: Compute predicted y by passing x to the model
                Y = model(X.cuda(), A.cuda()) #<<<<<<<
                # Compute loss
                loss1 = criterion(Y, T.cuda())

                loss = loss1
                predictions = torch.exp(Y).argmax(-1)

                ld = []
                for x in range(len(T)):
                    a = predictions[x].item()
                    b = T[x].item()
                    dist = D[0][a][b].item()
                    ld.append(dist/100)
                ld = np.array(ld)
                norm = np.linalg.norm(ld)
                normal_ld = ld/norm
                factor = normal_ld.sum()/len(normal_ld)

                aux = 0
                for j in range(len(T)):

                    if T[j].item() == predictions[j].item():
                        aux += 1

                acc_ep.append(aux/len(T))

                optimizer.zero_grad()
                loss.backward()
                optimizer.step()

                epoch_loss.append(loss.item())
                loss_ls.append(loss.item())

                loss_ep.append(loss.item())

                predict.append(predictions)
                correct.append(T)
                tm = round(((time.time() - start_time)/60),1)

                pbar.set_description('Epoch: {} - Loss: {} - Total_Time: {} mins'.format(epoch+1, round(loss.item(),2), tm))
                pbar.update(1)
            acc.append(np.array(acc_ep).mean())
            lss.append(np.array(loss_ep).mean())
            statistics = {'loss_ls': lss, 'accuracy': acc, 'correct': correct, 'predict': predict}

    return model, optimizer, statistics


# In[ ]:




