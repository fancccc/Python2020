# -*- coding: utf-8 -*-
"""
Created on Fri Jan 31 18:52:52 2020

@author: Mario
"""
import os
import base64
import random
import time
import requests
import json
import werobot
from datetime import datetime
from werobot.replies import ArticlesReply, Article, ImageReply, TextReply, MusicReply
from twilio.rest import Client
from bs4 import BeautifulSoup

robot=werobot.WeRoBot(token='******')
def send_phone_mes(body):
    account_sid = 'AC7a80eff4317d2f1e47b2085d0fdfb0ee'
    auth_token = '***********************************'
    client = Client(account_sid,auth_token)
    message = client.messages.create(
        to = '+8613********92',
        from_ = '+12******23',
        body = body)
# 订阅后的回复
@robot.subscribe
def subscribe():
    return "***欢迎关注公众号[愉快][愉快][愉快]***\n" \
           "***输入任意内容开始与我聊天！\n" \
           "***输入'文章'获取历史文章!\n" \
           "***输入'视频'获取历史视频!\n" \
           "***输入'Python'获取Python3零基础教程!\n" \
           "***发送照片测试颜值!\n" \
           #"***输入'音乐'为送上舒缓的歌曲!\n"

# 关键字回复
@robot.filter('文章')
def blog(message):
    reply = ArticlesReply(message=message)
    article = Article(
        title="历史群发",
        description="乱七八糟的",
        img="http://image.biaobaiju.com/uploads/20180227/11/1519701852-pQFCqdYWoD.jpg",
        url="https://mp.weixin.qq.com/mp/homepage?__biz=MzI4Nzc4NjE2Nw==&hid=9&sn=0fb12269521137c0bac5355777058cca"
    )
    reply.add_article(article)
    return reply
@robot.filter('视频')
def blog(message):
    reply = ArticlesReply(message=message)
    article = Article(
        title="历史视频",
        description="乱七八糟的",
        img="http://img.duoziwang.com/2016/12/30/19570835988.jpg",
        url="https://mp.weixin.qq.com/mp/homepage?__biz=MzI4Nzc4NjE2Nw==&hid=10&sn=39b20b7102bbfc7352a92e631b47b295"
    )
    reply.add_article(article)
    return reply
@robot.filter('Python')
def blog(message):
    reply = ArticlesReply(message=message)
    article = Article(
        title="Python零基础学习",
        description="廖雪峰学习网站",
        img="https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1581182922983&di=99797126d30557e47892e7af4b5c663b&imgtype=jpg&src=http%3A%2F%2Fimg1.imgtn.bdimg.com%2Fit%2Fu%3D2046400996%2C3772250545%26fm%3D214%26gp%3D0.jpg",
        url="https://www.liaoxuefeng.com/wiki/1016959663602400"
    )
    reply.add_article(article)
    return reply
@robot.filter('python')
def blog(message):
    reply = ArticlesReply(message=message)
    article = Article(
        title="Python零基础学习",
        description="廖雪峰学习网站",
        img="https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1581182922983&di=99797126d30557e47892e7af4b5c663b&imgtype=jpg&src=http%3A%2F%2Fimg1.imgtn.bdimg.com%2Fit%2Fu%3D2046400996%2C3772250545%26fm%3D214%26gp%3D0.jpg",
        url="https://www.liaoxuefeng.com/wiki/1016959663602400"
    )
    reply.add_article(article)
    return reply

# 用户发送图片
@robot.image
def img(message):
    host = 'https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=**************************&client_secret=***************************'
    response = requests.get(host,timeout=2)
    if response:
        rejson = response.json()
        access_token = rejson['access_token']
        request_url = "https://aip.baidubce.com/rest/2.0/face/v3/detect"
        s = message.img
        html = requests.get(s)
        os.remove('2.jpg')
        with open('2.jpg','ab') as file:
            file.write(html.content)
            file.close()
        #fsize = os.path.getsize('2.jpg')            
        with open('2.jpg', 'rb') as f:
            base64_data = base64.b64encode(f.read())
            s = base64_data.decode()
        params = "{\"image\":\""+ s +"\",\"image_type\":\"BASE64\",\"face_field\":\"faceshape,facetype\",\"face_field\":\"age,beauty,expression,face_shape,gender,glasses,race,eye_status,emotion,face_type\"}"
        request_url = request_url + "?access_token=" + access_token
        headers = {'content-type': 'application/json'}
        try:
            response = requests.post(request_url, data=params, headers=headers,timeout=4)    
            response.raise_for_status()   # 如果不是200，则引发HTTPError异常
            face_before = response.json()
            if face_before['error_code'] == 0:
                face = face_before['result']['face_list'][0]
                face_dic = {'存在人脸概率':face['face_probability'],
                              '性别':[face['gender']['type'],face['gender']['probability']],
                              '年龄':face['age'],
                                '颜值打分':face['beauty'],
                                '表情':[face['expression']['type'],face['expression']['probability']],
                                '脸型':[face['face_shape']['type'],face['face_shape']['probability']],
                                '眼镜':[face['glasses']['type'],face['glasses']['probability']],
                                '肤色':[face['race']['type'],face['race']['probability']],
                                '双眼状态（左右）':[face['eye_status']['left_eye'],face['eye_status']['right_eye']],
                                '情绪':[face['emotion']['type'],face['emotion']['probability']],
                                '人脸类型':[face['face_type']['type'],face['face_type']['probability']]}
                face_end = str(list(face_dic.items())).replace('),','\n').replace('(','').strip('[]').strip(')')
                return face_end
                        #break
            else:
                return face_before['error_msg']
                        #break
        except BaseException as e:
                #tries -= 1
                localtime = time.asctime(time.localtime(time.time()))
                #print(e,tries)
                f = open('error.txt','a+')
                f.write(str(localtime) + ' : ')
                f.write(str(e) + ' ')
                f.write('\n')
                f.close()
                time.sleep(2)
                print('defeated')
                #send_phone_mes(body =str(localtime) + ' : ' + str(e) )
                #if tries == 0:
                return '服务器响应超时'
    else:
        return '请重试'
'''
# 随机一首音乐
def music_data():
    music_list = [
            ['童话镇','陈一发儿','https://e.coka.la/wlae62.mp3','https://e.coka.la/wlae62.mp3'],
            ['都选C','缝纫机乐队','https://files.catbox.moe/duefwe.mp3','https://files.catbox.moe/duefwe.mp3'],
            ['精彩才刚刚开始','易烊千玺','https://e.coka.la/PdqQMY.mp3','https://e.coka.la/PdqQMY.mp3']
            ]
    num = random.randint(0,2)
    return music_list[num]


# 匹配 音乐 回复一首歌
@robot.filter('音乐')
def music(message):
    return music_data()
'''
# 调用智能回复接口
def get_response(msg_text_bd):
    host = 'https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=*************************&client_secret=******************************'
    response = requests.get(host)    
    if response:
        rejson = response.json()    
    access_token = rejson['access_token']
    url = 'https://aip.baidubce.com/rpc/2.0/unit/service/chat?access_token=' + access_token
    post_data = {"log_id":"UNITTEST_10000","version":"2.0","service_id":"S24514","session_id":'',"request":{"query":msg_text_bd,"user_id":"88888"},"dialog_state":{"contexts":{"SYS_REMEMBERED_SKILLS":["90991",'90992']}}}
    headers = {'content-type': 'application/x-www-form-urlencoded'}
    post_data = json.dumps(post_data)
    response = requests.post(url, data=post_data, headers=headers)
    robot_replys = []
    if response:
        robot_reply = response.json()    
        for i in range(len(robot_reply['result']['response_list'][0]['action_list'])):
            robot_replys.append(robot_reply['result']['response_list'][0]['action_list'][i]['say'])
    my_reply = random.choice(robot_replys)
    return my_reply
# 文字智能回复
@robot.text
def replay(msg):
    response = get_response(msg.content)
    return response

# 让服务器监听在 0.0.0.0:80
robot.config['HOST']='0.0.0.0'
robot.config['PORT']=80
robot.run()
