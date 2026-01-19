#!/usr/bin/env python3
"""
SCUT JW (华南理工大学教务处) Crawler
Fetches academic notices from SCUT JW website and uploads to Supabase
针对微电子专业的智能过滤爬虫
"""

import requests
from bs4 import BeautifulSoup
import html2text
import json
import os
import sys
import argparse
import time
import random
from datetime import datetime
from typing import List, Dict, Optional

# Try to import supabase
try:
    from supabase import create_client, Client
except ImportError:
    create_client = None


# ==================== 配置区 ====================

# 关键词优先级配置
HIGH_PRIORITY_KEYWORDS = [
    "微电子", "集成电路", "芯片", "半导体",
    "保研", "推免", "实习",
    "广州国际校区", "GZIC", "国际校区",
    "电子科学与技术", "微电子科学与工程"
]

LOW_PRIORITY_KEYWORDS = [
    "选课", "放假", "通知", "考试", "补考", "重修",
    "教学", "课程", "成绩", "学分"
]

# User-Agent 池（反爬虫）
USER_AGENTS = [
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
    'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36'
]

# 教务处网站配置
JW_BASE_URL = "https://jw.scut.edu.cn"
JW_NOTICE_URL = f"{JW_BASE_URL}/zhinan/cms/toPosts.do"
JW_API_URL = f"{JW_BASE_URL}/zhinan/cms/article/v2/findInformNotice.do"  # AJAX API 接口


# ==================== 核心功能 ====================

def get_random_headers() -> Dict:
    """生成随机 HTTP 请求头（反爬虫）"""
    return {
        'User-Agent': random.choice(USER_AGENTS),
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        'Accept-Language': 'zh-CN,zh;q=0.9,en;q=0.8',
        'Connection': 'keep-alive',
    }


def calculate_priority(title: str, content: str) -> str:
    """
    基于关键词计算通知优先级
    返回: 'high' | 'low'
    """
    text = (title + " " + content).lower()

    # 高优先级关键词匹配
    for keyword in HIGH_PRIORITY_KEYWORDS:
        if keyword.lower() in text:
            return 'high'

    # 低优先级关键词匹配
    for keyword in LOW_PRIORITY_KEYWORDS:
        if keyword.lower() in text:
            return 'low'

    # 默认低优先级
    return 'low'


def extract_tags(title: str, content: str) -> List[str]:
    """提取文章标签"""
    tags = set()
    text = (title + " " + content).lower()

    # 合并所有关键词
    all_keywords = HIGH_PRIORITY_KEYWORDS + LOW_PRIORITY_KEYWORDS
    for keyword in all_keywords:
        if keyword.lower() in text:
            tags.add(keyword)

    return list(tags)[:5]  # 最多返回 5 个标签


def fetch_notice_list(max_pages: int = 3, category: int = 0) -> List[Dict]:
    """
    抓取教务处通知列表（通过 AJAX API）

    Args:
        max_pages: 最大抓取页数
        category: 通知分类 (0=全部, 1=选课, 2=考试, 3=实践, 4=交流, 5=教师, 6=信息)

    Returns:
        通知列表 [{'title': str, 'url': str, 'date': str, 'category': str}, ...]
    """
    notices = []

    print(f"开始通过 API 抓取教务处通知（类别: {category}, 最多 {max_pages} 页）...", file=sys.stderr)

    # 创建 Session 对象（重要：需要先访问主页获取 Cookie）
    session = requests.Session()

    try:
        # Step 1: 访问主页获取 JSESSIONID
        print("正在获取 Session Cookie...", file=sys.stderr)
        session.get(JW_NOTICE_URL, headers=get_random_headers(), timeout=10)
    except Exception as e:
        print(f"获取 Session 失败: {e}", file=sys.stderr)

    for page in range(1, max_pages + 1):
        try:
            # 构造 API 请求参数
            payload = {
                'category': str(category),
                'tag': str(category),
                'pageNum': page,
                'pageSize': 15,
                'keyword': ''
            }

            # 构造完整的请求头（包含 AJAX 标识）
            headers = get_random_headers()
            headers.update({
                'Accept': 'application/json, text/javascript, */*; q=0.01',
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                'X-Requested-With': 'XMLHttpRequest',
                'Referer': JW_NOTICE_URL,
                'Origin': JW_BASE_URL
            })

            # POST 请求到 AJAX API（使用 session）
            response = session.post(
                JW_API_URL,
                data=payload,
                headers=headers,
                timeout=15
            )
            response.raise_for_status()

            # 解析 JSON 响应
            data = response.json()

            if not data.get('success', False):
                print(f"API 返回错误: {data.get('message', '未知错误')}", file=sys.stderr)
                break

            if 'list' not in data or not data['list']:
                print(f"第 {page} 页无数据，停止抓取", file=sys.stderr)
                break

            page_count = 0
            for item in data['list']:
                try:
                    # 提取字段（使用实际的 API 字段名）
                    article_id = item.get('id', '')
                    title = item.get('title', '').strip()  # ✅ 修正：使用 'title' 而非 'postTitle'
                    create_time = item.get('createTime', datetime.now().strftime('%Y.%m.%d'))
                    tag = item.get('tag', 0)  # ✅ 修正：使用 'tag' 字段

                    # 格式化日期（从 2026.01.16 转为 2026-01-16）
                    if '.' in create_time:
                        parts = create_time.split('.')
                        if len(parts) == 3:
                            create_time = f"20{parts[0]}-{parts[1]}-{parts[2]}"

                    # 构造详情页 URL
                    url = f"{JW_BASE_URL}/zhinan/cms/article/view.do?type=posts&id={article_id}"

                    # 分类映射（根据 tag 字段）
                    category_map = {
                        1: '选课',
                        2: '考试',
                        3: '实践',
                        4: '交流',
                        5: '教师',
                        6: '信息'
                    }
                    category_name = category_map.get(tag, '通知')

                    # 验证数据有效性
                    if title and article_id:
                        notices.append({
                            'title': title,
                            'url': url,
                            'date': create_time,
                            'category': category_name,
                            'id': article_id
                        })
                        page_count += 1

                except Exception as e:
                    print(f"解析单条通知时出错: {e}", file=sys.stderr)
                    continue

            print(f"第 {page} 页抓取完成，本页 {page_count} 条，累计 {len(notices)} 条", file=sys.stderr)

            # 检查是否还有更多数据
            total = data.get('total', 0)
            if len(notices) >= total:
                print(f"已抓取全部通知（共 {total} 条），停止", file=sys.stderr)
                break

            # 礼貌延迟
            time.sleep(random.uniform(1.5, 3))

        except requests.exceptions.RequestException as e:
            print(f"API 请求失败（第 {page} 页）: {e}", file=sys.stderr)
            break
        except json.JSONDecodeError as e:
            print(f"JSON 解析失败（第 {page} 页）: {e}", file=sys.stderr)
            break

    # 去重
    unique_notices = {n['id']: n for n in notices}.values()
    final_list = list(unique_notices)
    print(f"去重后共 {len(final_list)} 条唯一通知", file=sys.stderr)
    return final_list


def fetch_notice_detail(notice_url: str) -> tuple[Optional[str], Optional[str]]:
    """
    抓取通知详情页内容

    Args:
        notice_url: 通知详情页 URL

    Returns:
        (Markdown 格式的正文内容, 发布日期)
    """
    try:
        response = requests.get(
            notice_url,
            headers=get_random_headers(),
            timeout=15,
            verify=True
        )
        response.raise_for_status()
        response.encoding = 'utf-8'

        soup = BeautifulSoup(response.text, 'html.parser')

        # 提取发布日期（多种可能的位置）
        publish_date = None
        date_patterns = [
            soup.find('span', class_='publish-date'),
            soup.find('div', class_='post-date'),
            soup.find('time'),
        ]

        for date_elem in date_patterns:
            if date_elem:
                publish_date = date_elem.get_text(strip=True)
                break

        if not publish_date:
            publish_date = datetime.now().strftime('%Y-%m-%d')

        # 查找正文内容（根据实际网站结构）
        content_div = (
            soup.find('div', class_='article-content') or
            soup.find('div', class_='post-content') or
            soup.find('div', class_='content') or
            soup.find('div', id='content') or
            soup.find('article')
        )

        if not content_div:
            # 备用方案：提取主要内容区域
            main_content = soup.find('main') or soup.find('div', class_='main')
            if main_content:
                # 移除导航、侧边栏等干扰元素
                for unwanted in main_content.find_all(['nav', 'aside', 'header', 'footer']):
                    unwanted.decompose()
                content_html = str(main_content)
            else:
                # 最后备用：提取所有段落
                paragraphs = soup.find_all('p')
                content_html = ''.join(str(p) for p in paragraphs)
        else:
            content_html = str(content_div)

        # HTML 转 Markdown
        h = html2text.HTML2Text()
        h.ignore_links = False
        h.ignore_images = False
        h.body_width = 0  # 不限制行宽
        h.unicode_snob = True  # 保持 Unicode 字符

        markdown_content = h.handle(content_html)

        # 清理多余的空行
        markdown_content = '\n'.join(
            line for line in markdown_content.split('\n')
            if line.strip() or line == ''
        )

        return markdown_content.strip(), publish_date

    except Exception as e:
        print(f"抓取详情页失败 ({notice_url}): {e}", file=sys.stderr)
        return None, None


def process_notices(notices: List[Dict], limit: int = 10) -> List[Dict]:
    """
    处理通知列表，抓取详情并生成结构化数据

    Args:
        notices: 通知列表
        limit: 最多处理条数

    Returns:
        结构化文章数据
    """
    articles = []

    print(f"\n开始处理通知详情（限制 {limit} 条）...", file=sys.stderr)

    for i, notice in enumerate(notices[:limit], 1):
        print(f"[{i}/{min(limit, len(notices))}] 处理: {notice['title'][:30]}...", file=sys.stderr)

        # 抓取详情页
        content, publish_date = fetch_notice_detail(notice['url'])

        if not content:
            content = "**内容抓取失败，请访问原文链接查看详情。**"
            publish_date = notice['date']

        # 使用详情页的日期（如果有）
        final_date = publish_date if publish_date else notice['date']

        # 计算优先级和标签
        priority = calculate_priority(notice['title'], content)
        tags = extract_tags(notice['title'], content)

        # 添加分类标签
        if 'category' in notice and notice['category']:
            if notice['category'] not in tags:
                tags.insert(0, notice['category'])

        # 生成简短摘要（取内容前200字符，去除 Markdown 符号）
        content_text = content.replace('#', '').replace('*', '').replace('>', '').strip()
        summary = content_text[:200] + '...' if len(content_text) > 200 else content_text

        # 构造 Markdown 格式正文
        priority_emoji = '🔴' if priority == 'high' else '🔵'
        full_content = f"""# {notice['title']}

> 📅 发布日期: {final_date}
> 🏷️ 分类: {notice.get('category', '通知')}
> {priority_emoji} 优先级: **{priority.upper()}**
> 🔗 原文链接: [{notice['url']}]({notice['url']})

---

{content}

---

*本文由 Anthropo-Reader 自动抓取整理 | 数据来源: 华南理工大学本科生院*
"""

        # 构造数据库记录
        article = {
            'title': notice['title'],
            'summary': summary,
            'content': full_content,
            'source': 'SCUT_JW',
            'source_url': notice['url'],
            'author': '华南理工大学本科生院',
            'published_at': final_date,
            'fetched_at': datetime.now().isoformat(),
            'priority': priority,
            'tags': tags[:5],  # 限制最多5个标签
            'is_favorited': False
        }

        articles.append(article)

        # 礼貌延迟
        time.sleep(random.uniform(1.5, 3))

    print(f"\n处理完成！共生成 {len(articles)} 条结构化数据", file=sys.stderr)
    return articles


def save_to_supabase(articles: List[Dict], url: str, key: str, table_name: str = 'school_notices'):
    """
    上传数据到 Supabase

    Args:
        articles: 文章数据列表
        url: Supabase URL
        key: Supabase API Key
        table_name: 目标表名（默认 school_notices）
    """
    if not create_client:
        print("错误: 未安装 supabase 包，请运行: pip install supabase", file=sys.stderr)
        return

    print(f"\n连接 Supabase 数据库...", file=sys.stderr)

    try:
        supabase: Client = create_client(url, key)

        uploaded_count = 0
        skipped_count = 0

        for article in articles:
            try:
                # 检查是否已存在（基于 source_url 去重）
                existing = supabase.table(table_name).select('id').eq('source_url', article['source_url']).execute()

                if existing.data:
                    print(f"⏭️  跳过已存在: {article['title'][:25]}...", file=sys.stderr)
                    skipped_count += 1
                else:
                    # 插入新数据
                    supabase.table(table_name).insert(article).execute()
                    print(f"✅ 上传成功: {article['title'][:25]}... [优先级: {article['priority']}]", file=sys.stderr)
                    uploaded_count += 1

            except Exception as e:
                print(f"❌ 上传失败 ({article['title'][:20]}): {e}", file=sys.stderr)

        print(f"\n📊 上传统计: 新增 {uploaded_count} 条, 跳过 {skipped_count} 条", file=sys.stderr)

    except Exception as e:
        print(f"❌ Supabase 连接错误: {e}", file=sys.stderr)


# ==================== 主函数 ====================

def main():
    """主函数"""
    parser = argparse.ArgumentParser(description='华南理工大学教务处通知爬虫')
    parser.add_argument('--pages', type=int, default=2, help='抓取页数（默认 2）')
    parser.add_argument('--limit', type=int, default=10, help='处理通知数量（默认 10）')
    parser.add_argument('--category', type=int, default=0, help='通知分类 (0=全部, 1=选课, 2=考试, 3=实践, 4=交流, 5=教师, 6=信息)')
    parser.add_argument('--output', default='', help='输出 JSON 文件路径')
    parser.add_argument('--upload', action='store_true', help='上传到 Supabase')
    parser.add_argument('--table', default='school_notices', help='Supabase 表名（默认 school_notices）')

    # Supabase 配置（与 GitHub 脚本保持一致）
    default_url = "https://ovytvktzhuapvictznnr.supabase.co"
    default_key = "sb_secret_3DFQXsH8RqIldbdJAVrC5Q_A_xtu9uh"

    parser.add_argument('--supabase-url', default=default_url, help='Supabase Project URL')
    parser.add_argument('--supabase-key', default=default_key, help='Supabase API Key')

    args = parser.parse_args()

    # Step 1: 抓取通知列表
    notices = fetch_notice_list(max_pages=args.pages, category=args.category)

    if not notices:
        print("⚠️  未抓取到任何通知，请检查网络或网站结构是否变化", file=sys.stderr)
        sys.exit(1)

    print(f"\n✅ 共抓取到 {len(notices)} 条通知", file=sys.stderr)

    # Step 2: 处理通知详情
    articles = process_notices(notices, limit=args.limit)

    # Step 3: 输出到文件
    if args.output:
        try:
            with open(args.output, 'w', encoding='utf-8') as f:
                json.dump(articles, f, indent=2, ensure_ascii=False)
            print(f"💾 数据已保存到: {args.output}", file=sys.stderr)
        except IOError as e:
            print(f"❌ 文件保存失败: {e}", file=sys.stderr)
    elif not args.upload:
        # 不上传且不保存文件时，打印到标准输出
        print(json.dumps(articles, indent=2, ensure_ascii=False))

    # Step 4: 上传到 Supabase
    if args.upload:
        url = args.supabase_url or os.environ.get('SUPABASE_URL')
        key = args.supabase_key or os.environ.get('SUPABASE_KEY')

        if url and key:
            save_to_supabase(articles, url, key, args.table)
        else:
            print("❌ 错误: 需要提供 Supabase URL 和 Key", file=sys.stderr)
            print("请通过参数 --supabase-url/--supabase-key 或环境变量提供", file=sys.stderr)


if __name__ == '__main__':
    main()
