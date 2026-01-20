#!/usr/bin/env python3
"""
多源新闻聚合爬虫 (Anthropo-Reader)
支持: 微博热搜、知乎热榜、BBC中文、36Kr、少数派、TechCrunch、极客公园
增强功能: 简繁转换、AI 翻译、优先级标记
"""

import requests
import feedparser
import json
import os
import sys
import argparse
import time
import re
from datetime import datetime
from typing import List, Dict, Optional
import opencc
import html2text
from bs4 import BeautifulSoup

# Try to import supabase
try:
    from supabase import create_client, Client
except ImportError:
    create_client = None

# 初始化转换器
cc = opencc.OpenCC('t2s')  # 繁体转简体

# ==================== 配置区 ====================

NEWS_SOURCES = {
    # --- 国内热点 (API) ---
    'weibo': {
        'name': '微博热搜',
        'category': 'domestic',
        'type': 'api',
        'url': 'https://weibo.com/ajax/side/hotSearch',
        'source_id': 'news_domestic',
    },

    # --- 国际新闻 (RSS) ---
    'bbc_chinese': {
        'name': 'BBC中文',
        'category': 'international',
        'type': 'rss',
        'url': 'https://feeds.bbci.co.uk/zhongwen/simp/rss.xml',
        'source_id': 'news_international',
    },
    'nytimes_chinese': {
        'name': '纽约时报中文',
        'category': 'international',
        'type': 'rss',
        'url': 'https://cn.nytimes.com/rss/',
        'source_id': 'news_international',
    },

    # --- 科技事件 (RSS) ---
    '36kr': {
        'name': '36氪',
        'category': 'tech',
        'type': 'rss',
        'url': 'https://36kr.com/feed',
        'source_id': 'news_tech',
    },
    'geekpark': {
        'name': '极客公园',
        'category': 'tech',
        'type': 'rss',
        'url': 'https://www.geekpark.net/rss',
        'source_id': 'news_tech',
    },
    'techcrunch': {
        'name': 'TechCrunch',
        'category': 'tech',
        'type': 'rss',
        'url': 'https://techcrunch.com/feed/',
        'source_id': 'news_tech',
    },
    'sspai': {
        'name': '少数派',
        'category': 'tech',
        'type': 'rss',
        'url': 'https://sspai.com/feed',
        'source_id': 'news_tech',
    },
}

# 优先级关键词
HIGH_PRIORITY_KEYWORDS = [
    '政治', '经济', '政策', 'GDP', '贸易', '选举',
    'AI', '人工智能', '芯片', '半导体', 'GPT', 'LLM',
    'Apple', 'Google', 'Microsoft', 'OpenAI', 'Huawei',
    '裁员', '融资', '上市', '重大', '突发'
]

# ==================== 核心功能 ====================

def clean_html(html_content: str) -> str:
    """简单的 HTML 清理"""
    if not html_content:
        return ""
    text = re.sub(r'<(script|style).*?>.*?</\1>', '', html_content, flags=re.DOTALL)
    text = re.sub(r'<[^>]+>', '', text)
    text = re.sub(r'\s+', ' ', text).strip()
    return text

def convert_to_simplified(text: str) -> str:
    """繁体转简体"""
    if not text: return ""
    return cc.convert(text)

def is_english(text: str) -> bool:
    """简单的英文检测"""
    if not text: return False
    eng_chars = sum(1 for c in text if 'a' <= c.lower() <= 'z')
    return eng_chars / len(text) > 0.5 if len(text) > 0 else False

def calculate_priority(title: str, category: str) -> str:
    """计算文章优先级"""
    # 1. 科技和国际类默认较高
    if category in ['tech', 'international']:
        base_score = 1
    else:
        base_score = 0

    # 2. 关键词匹配
    for kw in HIGH_PRIORITY_KEYWORDS:
        if kw.lower() in title.lower():
            return 'high'

    return 'high' if base_score > 0 else 'low'

def fetch_rss_news(source_key: str, limit: int = 10) -> List[Dict]:
    """抓取 RSS 新闻源"""
    config = NEWS_SOURCES[source_key]
    print(f"📡 正在抓取 RSS: {config['name']}...", file=sys.stderr)

    try:
        # 添加 User-Agent 以通过简单的反爬虫检查
        feed = feedparser.parse(config['url'], agent='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36')
        articles = []

        for entry in feed.entries[:limit]:
            content = ""
            if 'content' in entry:
                content = entry.content[0].value
            elif 'summary' in entry:
                content = entry.summary

            clean_content = clean_html(content)
            if not clean_content:
                clean_content = entry.title

            # 繁简转换
            title = convert_to_simplified(entry.title)
            clean_content = convert_to_simplified(clean_content)

            # 计算优先级
            priority = calculate_priority(title, config['category'])

            published_at = datetime.now().isoformat()
            if hasattr(entry, 'published_parsed') and entry.published_parsed:
                published_at = datetime(*entry.published_parsed[:6]).isoformat()

            articles.append({
                'title': title,
                'summary': clean_content[:200] + '...',
                'content': f"# {title}\n\n> 来源: {config['name']} | {published_at[:10]}\n\n{clean_content}\n\n[查看原文]({entry.link})",
                'source': config['source_id'],
                'source_url': entry.link,
                'author': config['name'],
                'category': config['category'],
                'priority': priority,
                'published_at': published_at,
                'fetched_at': datetime.now().isoformat(),
                'tags': [config['name'], config['category']],
            })

        print(f"✅ {config['name']}: 获取 {len(articles)} 条", file=sys.stderr)
        return articles
    except Exception as e:
        print(f"❌ {config['name']} 抓取失败: {e}", file=sys.stderr)
        return []

def fetch_weibo_hot(limit: int = 15) -> List[Dict]:
    """抓取微博热搜"""
    config = NEWS_SOURCES['weibo']
    print(f"📡 正在抓取 API: {config['name']}...", file=sys.stderr)

    try:
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
            'Cookie': 'SUB=_2AkMVWDUjf8NxqwJRmP0SzGvhZYt2yw_EieKjbJDZJRMxHRl-yT9jqhAbtRB6PfaN_xT-yL9-yL9-yL9-yL9-'
        }
        resp = requests.get(config['url'], headers=headers, timeout=10)
        data = resp.json()

        articles = []
        items = data.get('data', {}).get('realtime', [])

        for item in items[:limit]:
            if 'word' not in item: continue

            title = item.get('word', '')
            note = item.get('note', '') or title
            num = item.get('num', 0)
            url = f"https://s.weibo.com/weibo?q={title}"

            # 热搜前3名或含有关键词为高优先级
            priority = 'high' if (len(articles) < 3 or calculate_priority(title, 'domestic') == 'high') else 'low'

            articles.append({
                'title': title,
                'summary': f"热度: {num} | {note}",
                'content': f"# {title}\n\n> 来源: 微博热搜\n\n**当前热度**: {num}\n\n{note}\n\n[查看讨论]({url})",
                'source': config['source_id'],
                'source_url': url,
                'author': '微博热搜',
                'category': config['category'],
                'priority': priority,
                'published_at': datetime.now().isoformat(),
                'fetched_at': datetime.now().isoformat(),
                'tags': ['微博', '热搜', 'domestic'],
            })

        print(f"✅ {config['name']}: 获取 {len(articles)} 条", file=sys.stderr)
        return articles
    except Exception as e:
        print(f"❌ {config['name']} 抓取失败: {e}", file=sys.stderr)
        return []

def process_with_ai(articles: List[Dict], api_key: str):
    """使用 AI 生成摘要和翻译"""
    try:
        from ai_summarizer import generate_summary

        print(f"\n🤖 开始 AI 摘要生成与翻译 (共 {len(articles)} 条)...", file=sys.stderr)

        count = 0
        for i, article in enumerate(articles):
            if len(article['content']) < 100: continue
            if count > 0: time.sleep(1.5)

            # 使用 is_english_content 避免与函数名冲突
            is_english_content = article.get('is_english', False) or is_english(article['title'])
            action = "翻译与摘要" if is_english_content else "生成摘要"

            print(f"[{i+1}/{len(articles)}] {action}: {article['title'][:20]}...", file=sys.stderr)

            content_type = 'news_en' if is_english_content else 'news'
            ai_summary = generate_summary(article['content'], content_type, api_key)

            if ai_summary:
                article['ai_summary'] = ai_summary
                count += 1
            else:
                print(f"  ⚠️ 生成失败", file=sys.stderr)

    except ImportError:
        print("❌ 未找到 ai_summarizer 模块，跳过 AI 摘要", file=sys.stderr)
    except Exception as e:
        print(f"❌ AI 处理出错: {e}", file=sys.stderr)

def save_to_supabase(articles: List[Dict], url: str, key: str):
    """上传数据到 Supabase"""
    if not create_client:
        print("❌ 未安装 supabase 库", file=sys.stderr)
        return

    print(f"\n💾 连接 Supabase...", file=sys.stderr)
    try:
        supabase: Client = create_client(url, key)
        success = 0
        skipped = 0

        for article in articles:
            try:
                # 检查重复
                existing = supabase.table('news').select('id').eq('source_url', article['source_url']).execute()
                if existing.data:
                    skipped += 1
                    continue

                supabase.table('news').insert(article).execute()
                success += 1
                print(f"  ✅ 上传: {article['title'][:20]}... [{article['priority']}]", file=sys.stderr)
            except Exception as e:
                print(f"  ❌ 上传失败: {e}", file=sys.stderr)

        print(f"📊 完成: 新增 {success}, 跳过 {skipped}", file=sys.stderr)

    except Exception as e:
        print(f"❌ Supabase 连接失败: {e}", file=sys.stderr)

def main():
    parser = argparse.ArgumentParser(description='多源新闻聚合爬虫')
    parser.add_argument('--upload', action='store_true', help='上传到 Supabase')
    parser.add_argument('--ai', action='store_true', help='启用 AI 摘要')
    parser.add_argument('--limit', type=int, default=10, help='每个源的限制数量')
    parser.add_argument('--supabase-url', default=os.environ.get('SUPABASE_URL'), help='Supabase URL')
    parser.add_argument('--supabase-key', default=os.environ.get('SUPABASE_KEY'), help='Supabase Key')

    args = parser.parse_args()
    api_key = os.environ.get('SILICONFLOW_API_KEY')

    all_news = []

    # 1. 抓取各源
    # 国内
    all_news.extend(fetch_weibo_hot(limit=args.limit))

    # 国际
    all_news.extend(fetch_rss_news('bbc_chinese', limit=args.limit))
    all_news.extend(fetch_rss_news('nytimes_chinese', limit=args.limit))

    # 科技 (新源)
    all_news.extend(fetch_rss_news('36kr', limit=args.limit))
    all_news.extend(fetch_rss_news('geekpark', limit=args.limit))
    all_news.extend(fetch_rss_news('techcrunch', limit=args.limit))
    all_news.extend(fetch_rss_news('sspai', limit=args.limit))

    print(f"\n📦 共抓取到 {len(all_news)} 条新闻", file=sys.stderr)

    # 2. AI 处理
    if args.ai and api_key:
        process_with_ai(all_news, api_key)

    # 3. 上传
    if args.upload:
        if args.supabase_url and args.supabase_key:
            save_to_supabase(all_news, args.supabase_url, args.supabase_key)
        else:
            print("❌ 缺少 Supabase 配置，无法上传", file=sys.stderr)
    else:
        # 本地测试
        print(json.dumps(all_news[:2], indent=2, ensure_ascii=False))

if __name__ == '__main__':
    main()
