import numpy as np
import pandas as pd
import time
from sklearn.neighbors import BallTree

# load dataset
arc = np.load('/u/dssc/sbrusa00/scratch/mnist.npz')
x_train_normalized = np.load("/u/dssc/sbrusa00/scratch/x_train_normalized.npy")
x_test_normalized = np.load("/u/dssc/sbrusa00/scratch/x_test_normalized.npy")

x_train = arc['arr_0']
y_train = arc['arr_1']
x_test  = arc['arr_2']
y_test  = arc['arr_3']


def d_infty(a,b):
    '''
    computes the Minkowsi distance for p = \infty
    
    Parameters:
    -----------
    a : numpy array of shape (n,n)
    b : numpy array of shape (n,n)
    '''
    assert a.shape == b.shape, "arrays must have same shape"
    return np.max(abs(a-b))

def d_one(a,b):
    '''
    computes the Minkowsi distance for p = 1
    
    Parameters:
    -----------
    a : numpy array of shape (n,n)
    b : numpy array of shape (n,n)
    '''
    assert a.shape == b.shape, "arrays must have same shape"
    return np.sum(abs(a-b))

def d_two(a,b):
    '''
    computes the Minkowsi distance for p = 2
    
    Note: since x^2 = |x|^2, absolute value is not computed to make the function faster
    
    Parameters:
    -----------
    a : numpy array of shape (n,n)
    b : numpy array of shape (n,n)
    '''
    assert a.shape == b.shape, "arrays must have same shape"
    return np.sqrt(np.sum((a-b)**2))


def d_matrix(N, dist, dataset=x_train):
    '''
    Computes the distance matrix from the first N entries of a dataset: D(i,j) = ( d(x_i,x_j) )_ij
    
    Parameters:
    -----------
    N : integer
        number of entries of the dataset to consider.
        Note that there is no shuffling, so it will consider the first N entries only.
    dist : function
        a distance function compatible with the elements of the dataset.
    dataset : array-like (default: x_train)
        where to take the N examples from.
        
    Returns:
    --------
    D : array
        matrix of distances (with distande 'dist') of the first N elements of dataset
    '''
    D = np.zeros((N,N))
    for i in range(N):
        for j in range(i-1,N):
            if i==j:
                continue
            val = dist(dataset[i], dataset[j])
            D[i,j] = val
            D[j,i] = val
    return D

def loo(mat, ds_y=y_train):
    '''
    Computes the error of the algorithm based on a distance matrix with a leave one out method.
    It is possible to pass a precomupated distance matrix.
    
    Parameters:
    -----------
    mat : 2D-array
        matrix used to compute the error.
    ds_y : array-like (default: y_train)
        where to take the answers from.
        
    Returns:
    --------
    error : float
        error obtained    
    '''
    error_counter=0
    matrix = mat.copy()
    
    for i in range(N):
        matrix[i,i] = np.inf # otherwise it is not the minimum
        j = np.argmin(matrix[i,:])
        
        # debug print
        #print("(i,j) =", i,j,"[i] =", ds_y[i], "[j] =", ds_y[j])
        
        if ds_y[j] != ds_y[i]:
            error_counter += 1
            
    return error_counter/N

def loo_scratch(dist, N=100, ds_x=x_train, ds_y=y_train):
    '''
    Computes the error of the algorithm based on a distance matrix with a leave one out method.
    It is possible to pass a precomupated distance matrix.
    
    Parameters:
    -----------
    dist : function
        a distance function compatible with the elements of the dataset.
    N : integer
        number of entries of the dataset to consider.
        Note that there is no shuffling, so it will consider the first N entries only.
    ds_x : array-like (default: x_train)
        where to take the N examples from.
    ds_y : array-like (default: y_train)
        where to take the N answers from.
        
    Returns:
    --------
    error : float
        error obtained    
    '''
    error_counter=0
    matrix = d_matrix(N, dist, dataset=ds_x)
    
    for i in range(N):
        matrix[i,i] = np.inf # otherwise it is not the minimum
        j = np.argmin(matrix[i,:])
        
        # debug print
        #print("(i,j) =", i,j,"[i] =", ds_y[i], "[j] =", ds_y[j])
        
        if ds_y[j] != ds_y[i]:
            error_counter += 1
            
    return error_counter/N

def d_H1(f1,f2):
    '''
    Computes the H1 distance of two images, treating them as continuos functions.
    
    Note: the integral is approximated with the forward Euler method.
    
    Parameters:
    -----------
    f1, f2 : array-like
        An array interpreted as a continuous function defined in Omega with real values.
        
    Returns:
    --------
    dist : float
        distance between f1 and f2.
    '''
    assert f1.shape == f2.shape # images must be defined on the same set Omega
    
    a = f1 / np.sum(f1) # f1 / \int_\Omega f1
    b = f2 / np.sum(f2) # f2 / \int_\Omega f2
    
    arg = np.square(np.gradient(a-b)) + np.square(a-b)
    return np.sqrt(np.sum(arg)) # \sqrt{ \int_\Omega arg }
    
    
def d_H1_precomp(a,b):
    '''
    Computes the H1 distance of two images f1 and f2 already normalized.
    
    Parameters:
    -----------
    a, b : array-like
        An array obtained by normalizing it over the integral.
        
    Returns:
    --------
    dist : float
        distance between f1 and f2
    '''
    assert a.shape == b.shape
    
    arg = np.square(np.gradient(a-b)) + np.square(a-b)
    return np.sqrt(np.sum(arg)) # \sqrt{ \int_\Omega arg }

def error(tree, k=1, ytrain=y_train, xtest=x_test, ytest=y_test):
    '''
    Gives the classification error of the tree given examples.
    
    Parameters:
    -----------
    tree : sklearn.BallTree
        Tree used to determine the output.
    k : integer
        number of neighbours to consider.
    ytrain : array-like
        Answers for the dataset used in training.
    xtest : array-like
        Input for the tree.
    ytest : array-like
        Correct output for xtest.
        
    Returns:
    --------
    error : float
        classification error
    
    '''
    error_counter = 0
    size = xtest.shape[0]
    ans = tree.query(xtest.reshape(size, 784), k=k, return_distance=False) # returns k nearest neighbours
    for i in range(size):
        if ytest[i] != np.max(ytrain[ans[i]]): # majority vote 
            error_counter += 1
    return error_counter/size

def error_matrices(k, arange, testN = 100):
    errdinf = np.array([error(BallTree(x_train[:N].reshape(N, 784), metric=d_infty), k=k, xtest=x_test[:testN]) for N in arange])
    errd1   = np.array([error(BallTree(x_train[:N].reshape(N, 784), metric=d_one), k=k, xtest=x_test[:testN]) for N in arange])
    errd2   = np.array([error(BallTree(x_train[:N].reshape(N, 784), metric=d_two), k=k, xtest=x_test[:testN]) for N in arange])
    errdH   = np.array([error(BallTree(x_train_normalized[:N].reshape(N, 784), metric=d_H1_precomp), k=k, xtest=x_test_normalized[:testN]) for N in arange])
    
    return errdinf, errd1, errd2, errdH

xrange = np.arange(3200,6401, 400)


k = 1 # change it as desired
errdinf, errd1, errd2, errdH = error_matrices(k, xrange, testN = 2000)

    
np.save("/u/dssc/sbrusa00/scratch/errdinf_k{}.npy".format(k), errdinf)
np.save("/u/dssc/sbrusa00/scratch/errdH_k{}.npy".format(k), errdH)
np.save("/u/dssc/sbrusa00/scratch/errd1_k{}.npy".format(k), errd1)
np.save("/u/dssc/sbrusa00/scratch/errd2_k{}.npy".format(k), errd2)
