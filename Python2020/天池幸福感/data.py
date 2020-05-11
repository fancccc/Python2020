# -*- coding: utf-8 -*-
"""
Created on Fri May  8 17:24:43 2020

@author: Mario
"""
from pyecharts.globals import CurrentConfig
CurrentConfig.ONLINE_HOST = "https://assets.pyecharts.org/assets/"

import pandas as pd
from pyecharts.charts import Sankey
from pyecharts import options as opts
import lightgbm as lgb
from sklearn.model_selection import train_test_split
from sklearn import metrics

df = pd.read_csv(r'happiness_train_abbr.csv')
print(set(df['happiness']))
drop_axis = df[df['happiness'].isin([-8])].index
df.drop(drop_axis,axis=0,inplace = True)
df1 = df[['happiness','survey_type','id']]
groups = df1.groupby(['happiness','survey_type']).count().reset_index()
groups.drop([0,1],axis=0,inplace = True)
groups.rename(columns={'id':'num'},inplace = True)
groups['survey_type'] = groups['survey_type'].apply(lambda x:'city' if x == 1 else 'country')
groups['happiness'] = groups['happiness'].apply(str)
nodes = []
for i in range(2):
    values = groups.iloc[:,i].unique()
    for value in values:
        dic = {}
        dic['name'] = value
        nodes.append(dic)

links = []
for i in groups.values:
    dic = {}
    dic['source'] = i[0]
    dic['target'] = i[1]
    dic['value'] = i[2]
    links.append(dic)
    
pic = Sankey().add(
               '',#图例名
               nodes,#节点数据
               links,#边和流量数据
               #透明度、弯曲度、颜色
               linestyle_opt = opts.LineStyleOpts(opacity = 0.3,curve = 0.5,color = 'source'),
               #标签显示位置
               label_opts = opts.LabelOpts(position = 'right'),
               #节点之间距离
               node_gap = 30,
               ).set_global_opts(title_opts = opts.TitleOpts(title = '幸福感指数相关性桑基图'))       

pic.render('test.html')

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
df.drop(['survey_time','county','work_exper','work_yr','work_type','work_manage','id'],axis = 1,inplace = True)
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
df['happiness'] = df['happiness'].apply(lambda x:x-1)
df_3 = df[~df['happiness'].isin([3])]
for i in range(3):
    df = pd.concat([df,df_3])
    print(len(df))
x = df.drop('happiness',axis = 1,inplace = False)
y = df['happiness']
X_train, X_test, y_train, y_test = train_test_split(x, y, test_size=0.2)

# 创建成lgb特征的数据集格式
lgb_train = lgb.Dataset(X_train, y_train)
lgb_eval = lgb.Dataset(X_test, y_test, reference=lgb_train)
# 将参数写成字典下形式
params = {  
    #'boosting_type': 'gbdt',   # 设置提升类型
    'objective': 'multiclass',  # 目标函数 处理多分类问题
    'num_class': 5,  #label数
    'metric': 'multi_logloss',  #评估函数
    'num_leaves': 500,  #叶子节点数
    'num_iterations':100,#一个整数，给出了boosting的迭代次数。默认为 100。
    'min_data_in_leaf': 20, #一个整数，表示一个叶子节点上包含的最少样本数量。默认值为 20
    'learning_rate': 0.01, #学习速率
    'max_depth': -1, #一个整数，限制了树模型的最大深度，默认值为-1
    'verbose': -1, #一个整数，表示是否输出中间信息。默认值为1。如果小于0，则仅仅输出critical 信息；如果等于0，则还会输出error,warning 信息； 如果大于0，则还会输出info 信息。
} 
# 训练 cv and train
gbm = lgb.train(params, lgb_train,valid_sets=lgb_eval,num_boost_round=20, early_stopping_rounds=5) #num_boost_round=20, early_stopping_rounds=5
 
# 保存模型到文件
gbm.save_model('model.txt')

#模型加载
gbm = lgb.Booster(model_file='model.txt')
# 预测数据集
y_prob = gbm.predict(X_test.values, num_iteration=gbm.best_iteration)
y_pred = [list(x).index(max(x)) for x in y_prob]
# 评估模型
print("AUC score: {:<8.5f}".format(metrics.accuracy_score(y_pred, y_test)))

