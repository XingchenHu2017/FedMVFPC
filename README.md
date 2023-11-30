# FedMVFPC
code for IEEE TFS 2023 FedMVFPC

This repo is a MATLAB implementaion of An Efficient Federated Multi-view Fuzzy C-Means Clustering Method in IEEE TFS 2023

# Introduction
Abstract
Multi-view clustering has been received considerable attention due to the widespread collection of multi-view data from diverse domains and sources. However, storing multi-view data across multiple devices in many real scenarios poses significant challenges for efficient data analysis. Federated Learning framework enables collaborative machine learning on distributed devices while preserving privacy constraints. Even though there have been intensive algorithms on multi-view fuzzy clustering, federated multi-view fuzzy clustering has not been adequately investigated so far. In this study, we first develop the federated learning mode into multi-view fuzzy clustering and realize the federated optimization procedure, called Federated Multiview Fuzzy C-Means clustering (FedMVFCM). Then, we design an original strategy of consensus prototype learning during federated multi-view fuzzy clustering. It is termed as Federated Multi-view Fuzzy c-means consensus Prototypes Clustering (FedMVFPC). We also further develop the federated alternative optimization algorithm with proven convergence. This study also introduces the notion of clustering prototype communication within the federated learning framework, and integrates the clustering prototypes of different views into a unified optimization formulation. The experimental studies on various benchmark datasets demonstrate that the proposed FedMVFPC method improves the federated clustering performance and efficiency. It achieves comparable or better clustering performance against the existing state-of-the-art multi-view clustering algorithms.

This repo consists of four algorithms: 
1. Multi-View Fuzzy C-Means Clustering (MVFCM),
2. Federated Multi-View Fuzzy C-Means Clustering (Fed-MVFCM),
3. Multi-View Fuzzy c-means consensus Prototypes Clustering (MVFPC),
4. Federated Multi-View Fuzzy c-means consensus Prototypes Clustering (Fed-MVFPC).

# Citation
If you find our code useful, please cite:

X. Hu, J. Qin, Y. Shen, W. Pedrycz, X. Liu and J. Liu, "An Efficient Federated Multi-view Fuzzy C-Means Clustering Method," in IEEE Transactions on Fuzzy Systems, doi: 10.1109/TFUZZ.2023.3335361.
  
Thanks. Any problem can contact Xingchen Hu (xhu4@ualberta.ca).
