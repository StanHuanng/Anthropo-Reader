#!/usr/bin/env python3
"""
调试华工教务处 API 响应
"""

import requests
import json

# API 配置
API_URL = "https://jw.scut.edu.cn/zhinan/cms/article/v2/findInformNotice.do"

# 构造请求
payload = {
    'category': '0',
    'tag': '0',
    'pageNum': 1,
    'pageSize': 15,
    'keyword': ''
}

headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
    'Accept': 'application/json, text/javascript, */*; q=0.01',
    'Accept-Language': 'zh-CN,zh;q=0.9,en;q=0.8',
    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
    'X-Requested-With': 'XMLHttpRequest',
    'Referer': 'https://jw.scut.edu.cn/zhinan/cms/toPosts.do',
    'Origin': 'https://jw.scut.edu.cn'
}

print("调试 API 请求...\n")
print(f"URL: {API_URL}")
print(f"Payload: {payload}\n")

try:
    # 先访问主页获取 Cookie
    print("Step 1: 访问主页获取 Session...")
    session = requests.Session()
    session.get('https://jw.scut.edu.cn/zhinan/cms/toPosts.do', headers=headers, timeout=10)

    print(f"Cookies: {session.cookies.get_dict()}\n")

    # 发送 API 请求
    print("Step 2: 发送 API 请求...")
    response = session.post(API_URL, data=payload, headers=headers, timeout=10)

    print(f"Status Code: {response.status_code}")
    print(f"Response Headers: {dict(response.headers)}\n")

    # 打印响应内容
    print("Response Body:")
    print("=" * 60)

    try:
        data = response.json()
        print(json.dumps(data, indent=2, ensure_ascii=False))

        if 'list' in data:
            print(f"\n[SUCCESS] 成功获取 {len(data['list'])} 条通知")
            print(f"总数: {data.get('total', 'N/A')}")
        else:
            print("\n[WARNING] 响应中没有 'list' 字段")

    except json.JSONDecodeError:
        print("[ERROR] 不是 JSON 格式，原始内容：")
        print(response.text[:500])

except Exception as e:
    print(f"[ERROR] 错误: {e}")
