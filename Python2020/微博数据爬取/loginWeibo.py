# -*- coding: utf-8 -*-
"""
Created on Tue Jun  9 11:13:29 2020

@author: Mario
"""

from selenium import webdriver
import time
import json
#全局变量
driver = webdriver.Chrome('E:\Files\Google\Chrome\Application\chromedriver.exe')


def loginWeibo(username, password):
    driver.get('https://passport.weibo.cn/signin/login')
    time.sleep(3)
    driver.find_element_by_id('loginName').send_keys(username)
    driver.find_element_by_id('loginPassword').send_keys(password)
    driver.find_element_by_id('loginAction').click()
    time.sleep(3)
    try:
        driver.find_element_by_id('getCode').click()
        time.sleep(3)
        #driver.find_element_by_id('checkBtn').click()
        yzm = input('验证码：')
        time.sleep(3)
        driver.find_element_by_id('checkCode').send_keys(yzm)
        driver.find_element_by_id('submitBtn').click()
    except:
        driver.find_element_by_class_name('geetest_radar_tip').click()
        x = input('手动验证后输入任意值：')
    print('\n登录成功')
    #这里只是看一下cookie内容，下面不会用到这个cookie值，因为driver会把cookie自动带过去
    cookies = driver.get_cookies()
    with open('cookies.json','w')as f:
        json.dump(cookies, f)
    #print (cookie)
    #return cookies
    #driver.close()
if __name__ == '__main__':
    username = '*********'             # 输入微博账号
    password = '*********'             # 输入密码
    loginWeibo(username, password)
