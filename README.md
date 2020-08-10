In this repository, I will showcase my work using R studio to do various Machine Learning and Deep Learning Algorithms. 

Customer Churn Prediction - This is my first data science project. When I was working in a Bank, customer retention initiatives was the one of the prime objective. 

In this project, I have implemented a logistic regression model to the telecom dataset to use whether the customers will churn or not. 

The data contains 7043 rows(customers) and 21 columns (features). The “Churn” column is our target variable. 

After a few data wrangling steps, I applied the Logistic regression to this classification problem. 

The accuracy of the prediction was 79%. I feel that a decision tree, random forest, XGBoost could have improved the accuracy of the project drastically. 


============================================================================================================================================================


Music Recommendation Engine - This dataset was donated by KKBOX so that a better recommendation system is build for their recommendation engine. 
At present, they use a collaborative filtering based algorithm with matrix factorization and word embedding in their recommendation system but believe new techniques could lead to better results.

In my model, I have used XGBoost to build the recommendation system. 

Let's now see the core concepts for the collaborative filtering with matrix factorization 

Collaborative Filtering → analyzes relationships between users and inter-dependencies among products to identify new user-item associations.

When a user gives feed back to a certain music they heard , this collection of feedback can be represented in a form of a matrix. Where each row represents each users, while each column represents different music. The matrix will be sparse since not everyone is going to watch every music, (we all have different taste when it comes to music).

One strength of matrix factorization is the fact that it can incorporate implicit feedback, information that are not directly given but can be derived by analyzing user behavior. Using this strength it can be estimated if a user is going to like a music that (he/she) never saw. If that estimated rating is high, the music can be recommendded to the user.

There were a few categorical variable in this dataset and needed to be converted  into binary values(1/0) to use them in the machine learning algorithm.

In order for XGBoost to be able to use in the data, it needs to be transformed into a specific format that XGBoost can handle and that format is called DMatrix.

XGBoost is a decision-tree-based ensemble Machine Learning algorithm that uses a gradient boosting framework. 

XGBoost uses ensemble tree methods that apply the principle of boosting weak learners (CARTs generally) using the gradient descent architecture. However, XGBoost improves upon the base GBM framework through systems optimization and algorithmic enhancements.

Rather than training all of the models in isolation of one another, boosting trains models in succession, with each new model being trained to correct the errors made by the previous ones. Models are added sequentially until no further improvements can be made.


=================================================================================================================================================================


Election Outcome Prediction - Will update it shortly.
