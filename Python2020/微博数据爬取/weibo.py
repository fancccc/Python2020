# -*- coding: utf-8 -*-
"""
Created on Thu Jun  4 22:05:20 2020

@author: Mario
"""

from selenium import webdriver
import time
import re
from bs4 import BeautifulSoup
import json
import pandas as pd
#全局变量
driver = webdriver.Chrome('E:\Files\Google\Chrome\Application\chromedriver.exe')

def visitUserInfo(userId):
    driver.get('http://weibo.cn/' + userId)

    print('********************')   
    print('用户资料')
    
    # 1.用户id
    print('用户id:' + userId)
    
    # 2.用户昵称
    strName = driver.find_element_by_xpath("//div[@class='ut']")
    strlist = strName.text.split(' ')
    nickname = strlist[0]
    print('昵称:' + nickname)
    
    # 3.微博数、粉丝数、关注数
    strCnt = driver.find_element_by_xpath("//div[@class='tip2']")
    pattern = r"\d+\.?\d*"      # 匹配数字，包含整数和小数
    cntArr = re.findall(pattern, strCnt.text)
    print(strCnt.text)
    print("微博数：" + str(cntArr[0]))
    print("关注数：" + str(cntArr[1]))
    print("粉丝数：" + str(cntArr[2]))
    
    print('\n********************')
    # 4.将用户信息写到文件里
    with open("userinfo（{}）.txt".format(nickname), "w", encoding = "gb18030") as file:
        file.write("用户ID：" + userId + '\r\n')
        file.write("昵称：" + nickname + '\r\n')
        file.write("微博数：" + str(cntArr[0]) + '\r\n')
        file.write("关注数：" + str(cntArr[1]) + '\r\n')
        file.write("粉丝数：" + str(cntArr[2]) + '\r\n')
        
    
def visitWeiboContent(userId):
    pageList = driver.find_element_by_xpath("//div[@class='pa']")
    print(pageList.text)
    pattern = r"\d+\d*"         # 匹配数字，只包含整数
    pageArr = re.findall(pattern, pageList.text)
    totalPages = pageArr[1]     # 总共有多少页微博
    print(totalPages)
    
    pageNum = 1                 # 第几页
    numInCurPage = 1            # 当前页的第几条微博内容
    curNum = 0                  # 全部微博中的第几条微博
    contentPath = "//div[@class='c'][{0}]"
    #while(pageNum <= 3):   
    while(pageNum <= int(totalPages)):
        try:
            contentUrl = "http://weibo.cn/" + userId + "?page=" + str(pageNum)
            driver.get(contentUrl)
            content = driver.find_element_by_xpath(contentPath.format(numInCurPage)).text
            #print("\n" + content)                  # 微博内容，包含原创和转发
            if "设置:皮肤.图片.条数.隐私" not in content:
                numInCurPage += 1
                curNum += 1
                with open("weibocontent.txt", "a", encoding = "gb18030") as file:
                    file.write(str(curNum) + '\r\n' + content + '\r\n\r\n') 
            else:
                pageNum += 1                        # 抓取新一页的内容
                numInCurPage = 1                    # 每一页都是从第1条开始抓
                time.sleep(20)                      # 要隔20秒，否则会被封
        except Exception as e:
            print("curNum:" + curNum)
            print(e)
        finally:
            pass
    print("Load weibo content finished!")       

def get_topblog():
    top_url = 'https://weibo.cn/pub/topmblog'
    driver.get(top_url)
    r = driver.page_source#.encode('utf-8')
    soup = BeautifulSoup(r,'lxml')
    #lis = driver.find_element_by_class_name('c')
    lis = soup.find_all('div',attrs={'class':'c'})
    for i in lis:
        print('********')
        try:
            with open('topmblog.txt','a',encoding = "gb18030") as f:
                f.write(i.div.span.text + ' ' +i.div.text + '\n' + i.find('a',attrs={'class':'cc'})['href'] + '\n\n')
        except Exception as e:
            print(e)
        finally:
            pass
    #return r,lis
def get_coment():
    coment_urls = []
    coments = []
    with open('topmblog.txt','r',encoding = "gb18030") as f:
        for i in f.read().split('\n'):
            if i[:4] == 'http':
                coment_urls.append(i)
    
    for i in coment_urls:
        print(i)
        page = 1
        number = 1
        max_page = 50
        coment = []
        while page <= max_page:
            hot_comment = 'https://weibo.cn/comment/hot/' + i[25:35] + 'rl=1' + '&page={}'.format(page)
            #print(hot_comment)
            try:
                driver.get(hot_comment)
                pageList = driver.find_element_by_xpath("//div[@class='pa']")
                print(pageList.text)
                pattern = r"\d+\d*"         # 匹配数字，只包含整数
                pageArr = re.findall(pattern, pageList.text)
                totalPages = pageArr[1]     # 总共有多少页微博
                print(totalPages)
                if int(totalPages) < max_page:
                    max_page = int(totalPages)
                r = driver.page_source
                soup = BeautifulSoup(r,'lxml')
                coms = soup.find_all('div',attrs={'class':'c'})
                for j in coms:
                    if j.text not in ['手机微博触屏版,点击前往>>','返回评论列表']:
                        coment.append(j.text)
                        with open('./coments/'+i[25:34]+'.txt','a',encoding = 'gb18030')as files:
                            files.write(str(number) +'.\n' + j.text +'\r\n')
            except Exception as e:
                print(e)
            finally:
                page += 1
                number += 1
                time.sleep(1)
        coments.append(coment)
        time.sleep(5)
    with open('comment.json','w',encoding = "gb18030")as f:
        json.dump(coments, f) 
    return coments
  
if __name__ == '__main__':
    driver.get('https://weibo.cn/comment/hot/J5oFQ9s8X?rl=1')
    with open('cookies.json','r')as f:
        cookies = json.load(f)
    for cookie in cookies:
        if 'expiry' in cookie:
                del cookie['expiry']
        driver.add_cookie(cookie)
    driver.get('https://weibo.cn/comment/hot/J5oFQ9s8X?rl=1')
    time.sleep(2)
    uid = '********'                 # 微博账号id
    visitUserInfo(uid)                 # 获取用户基本信息
    visitWeiboContent(uid)              # 获取微博内容
    get_topblog()                  #获取热门微博 （仅第一页
    coments = get_coment()   #获取热门微博评论
    df = pd.DataFrame(coments).T       #保存为DataFrame格式
    df.to_csv('coments.csv',index = False,encoding = 'gb18030')   #保存为.csv文件
