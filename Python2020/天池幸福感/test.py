# -*- coding: utf-8 -*-
"""
Created on Sun May 10 23:08:35 2020

@author: Mario
"""
import pandas as pd
import lightgbm as lgb

df = pd.read_csv(r'happiness_test_abbr.csv')
df['survey_time'] = df['survey_time'].apply(lambda x:int(x[:4]))
def split_age(x):
    if x < 20:
        return 1
    elif x < 40:
        return 2
    elif x < 60:
        return 3
    else:
        return 4
df['birth'] = (df['survey_time'] - df['birth']).apply(split_age)
df.rename(columns={'birth':'split_age'},inplace = True)
df.drop(['survey_time','county','work_exper','work_yr','work_type','work_manage'],axis = 1,inplace = True)
def split_income(x):
    if x < 0:
        return 0
    elif x < 5000:
        return 1
    elif x < 10000:
        return 2
    elif x < 50000:
        return 3
    elif x < 100000:
        return 4
    elif x < 500000:
        return 5
    else:
        return 6
df['income'] = df['income'].apply(split_income)

def split_floor_area(x):
    if x < 0:
        return 0
    elif x < 50:
        return 1
    elif x < 100:
        return 2
    elif x < 200:
        return 3
    elif x < 300:
        return 4
    else:
        return 5
df['floor_area'] = df['floor_area'].apply(split_floor_area)

def split_height_cm(x):
    if x < 0:
        return 0
    elif x < 150:
        return 1
    elif x < 160:
        return 2
    elif x < 170:
        return 3
    elif x < 180:
        return 4
    else:
        return 5
df['height_cm'] = df['height_cm'].apply(split_height_cm)
def split_weight_jin(x):
    if x < 0:
        return 0
    elif x < 80:
        return 1
    elif x < 100:
        return 2
    elif x < 120:
        return 3
    elif x < 150:
        return 4
    else:
        return 5
df['weight_jin'] = df['weight_jin'].apply(split_weight_jin)
df['family_income'] = df['family_income'].apply(split_income)
X_test = df.drop('id',axis = 1,inplace = False)
gbm = lgb.Booster(model_file='model.txt')
y_prob = gbm.predict(X_test.values, num_iteration=gbm.best_iteration)
y_pred = [list(x).index(max(x))+1 for x in y_prob]
df['happiness'] = y_pred
test_abbr = df[['id','happiness']]
test_abbr.to_csv('test_abbr.csv',index = False)