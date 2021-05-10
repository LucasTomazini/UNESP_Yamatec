import sys
from tqdm import tqdm
import numpy as np
import networkx as nx

import torch
import torch.nn as nn
from torch.utils.data import Dataset, DataLoader, TensorDataset

#from utils import errors  


def train_model(model, batch_size, epochs, steps_per_epoch,
                TrainDataset, TestDataset, UnrelatedDataset,
                adj_matrices, dist_matrices):
    
    
    EPOCHS = epochs  
    BATCH_SIZE = batch_size
    VAL_BATCH_SIZE = min(len(TestDataset),50)
    UNR_BATCH_SIZE = min(len(UnrelatedDataset),50)

    STEPS_PER_EPOCH = steps_per_epoch

    # Split train dataset in batches
    train_data = DataLoader(TrainDataset, batch_size=BATCH_SIZE, shuffle=True)
    val_data = DataLoader(TestDataset, batch_size=VAL_BATCH_SIZE, shuffle=False)
    unr_data = DataLoader(UnrelatedDataset, batch_size=UNR_BATCH_SIZE, shuffle=False)
    
    criterion = nn.NLLLoss()
    optimizer = torch.optim.Adam(model.parameters())
    
    
    # Initial evaluations
    # =========================================================================
    
    loss_ls = []
    akk = []


    # Test dataset
    # -------------------------------------------------------------------------
    model.eval()

    for batch in val_data:
        X, T, idx = batch
        A = adj_matrices[idx]
        D = dist_matrices[idx]
        Y = model(X.cuda(), A.cuda())                       

    # Unrelated dataset
    # -------------------------------------------------------------------------
    model.eval()

    for batch in unr_data:
        X, T, idx = batch
        A = adj_matrices[idx]
        D = dist_matrices[idx]
        Y = model(X.cuda(), A.cuda())
            
    
    # Print results
    # -------------------------------------------------------------------------



    # =========================================================================
    
    
    # Training 
    # =========================================================================
    
    for epoch in range(EPOCHS):

        # Break condition
        #if (uWBE_mean_ls[-1] < 0.2):
        #    break
        
        predict = []
        Output = []
        running_corrects = []
        correct = 0
        acc = []
        epoch_target = []
        epoch_Y = []
        
        epoch_loss = []
        with tqdm(total=STEPS_PER_EPOCH, file=sys.stdout) as pbar:
            model.train()
            for step in range(STEPS_PER_EPOCH):
                # Get batch data
                X, T, idx = next(iter(train_data))
                A = adj_matrices[idx]
                # Forward pass: Compute predicted y by passing x to the model
                Y = model(X.cuda(), A.cuda())
                # Compute loss
                loss = criterion(Y, T.cuda())
                # Zero gradients, perform a backward pass, and update the weights.
                #print('Predict {}, Output {}'.format(Y, T))
                
                running_corrects.append(T.cuda())
                
                #pred = np.exp(Y.detach().numpy())[0]
                target = T.cuda()
                epoch_target.append(target)
                epoch_Y.append(torch.exp(Y).argmax(-1))
                #correct += (T.cuda() == torch.exp(Y).argmax(-1)).sum().item()                              
                
                accuracy = 100 * correct / len(train_data)
                
                predict.append(torch.exp(Y).argmax(-1))
                Output.append(T.cuda())                
                
                #correct += (running_corrects == Y).float().sum()
                
                acc.append(accuracy)
                
                
                optimizer.zero_grad()
                loss.backward()
                optimizer.step()

                pbar.set_description('...step %d/%d - loss: %.4f' % ((step+1), STEPS_PER_EPOCH, loss.item()))
                pbar.update(1)

                epoch_loss.append(loss.item())
                loss_ls.append(loss.item())
                
                
        # =====================================================================
        
        # New evaluations
        # =====================================================================        

        # Test dataset
        # ---------------------------------------------------------------------

        for batch in val_data:
            X, T, idx = batch
            A = adj_matrices[idx]
            D = dist_matrices[idx]
            Y = model(X.cuda(), A.cuda())


        # Unrelated dataset
        # ---------------------------------------------------------------------
        model.eval()

        for batch in unr_data:
            X, T, idx = batch
            A = adj_matrices[idx]
            D = dist_matrices[idx]
            Y = model(X.cuda(), A.cuda())
                     
        accu2 = []
        for a in range(len(epoch_target)):
            count = 0
            accu1 = []
            for b in range(len(epoch_target[0])):
                aux1 = epoch_target[a][b].item()
                aux2 = epoch_Y[a][b].item()
                if aux2 == aux1:
                    count +=1
            accu1.append(count/30)
            accu2.append(count/30)
        epoch_accu = np.array(accu1).mean()
        
        akk.append(epoch_accu)
        
        # Print results
        # ---------------------------------------------------------------------
        print('Epoch %d/%d - train_loss: %.4f / %.4f / %.4f (Min/Avg/Max)'  # - val_loss: %.4f'
            % (epoch+1, EPOCHS, min(epoch_loss), sum(epoch_loss)/len(epoch_loss), max(epoch_loss), val_loss))   
       
        print('-----------------------------------------------------------------------------------') 
        


    # =========================================================================


    statistics = {'loss_ls': loss_ls}

    return model, optimizer, statistics
