#!/usr/bin/env python3
"""
华工教务处爬虫 - AI 增强版
集成硅基流动 API 自动生成智能摘要
"""

import sys
import os

# 添加脚本目录到路径
sys.path.insert(0, os.path.dirname(__file__))

from fetch_scut_jw import *
from ai_summarizer import generate_summary

# 硅基流动 API Key
SILICONFLOW_API_KEY = "sk-jglsdgaygjgjcgttnqxcadbpfgpncphvkggkwvixsaclbkfa"


def process_notices_with_ai(notices: List[Dict], limit: int = 10) -> List[Dict]:
    """
    处理通知列表，抓取详情并生成 AI 摘要

    Args:
        notices: 通知列表
        limit: 最多处理的通知数量

    Returns:
        包含 AI 摘要的文章列表
    """
    articles = []

    print(f"\n开始处理通知详情（限制 {limit} 条，启用 AI 摘要）...", file=sys.stderr)

    for i, notice in enumerate(notices[:limit], 1):
        print(f"[{i}/{min(limit, len(notices))}] 处理: {notice['title'][:30]}...", file=sys.stderr)

        # 抓取详情页
        content, publish_date = fetch_notice_detail(notice['url'])

        if not content:
            content = "**内容抓取失败，请访问原文链接查看详情。**"
            publish_date = notice['date']

        final_date = publish_date if publish_date else notice['date']

        # 计算优先级和标签
        priority = calculate_priority(notice['title'], content)
        tags = extract_tags(notice['title'], content)

        if 'category' in notice and notice['category']:
            if notice['category'] not in tags:
                tags.insert(0, notice['category'])

        # 生成简短摘要
        content_text = content.replace('#', '').replace('*', '').replace('>', '').strip()
        summary = content_text[:200] + '...' if len(content_text) > 200 else content_text

        # 🤖 调用 AI 生成智能摘要
        print(f"    正在生成 AI 摘要...", file=sys.stderr)
        ai_summary = generate_summary(
            content=content,
            content_type='notice',
            api_key=SILICONFLOW_API_KEY
        )

        # 构造 Markdown 格式正文（包含 AI 摘要）
        priority_emoji = '🔴' if priority == 'high' else '🔵'

        # 如果有 AI 摘要，插入到正文开头
        ai_section = f"\n\n{ai_summary}\n\n---\n" if ai_summary else ""

        full_content = f"""# {notice['title']}

> 📅 发布日期: {final_date}
> 🏷️ 分类: {notice.get('category', '通知')}
> {priority_emoji} 优先级: **{priority.upper()}**
> 🔗 原文链接: [{notice['url']}]({notice['url']})

---
{ai_section}
{content}

---

*本文由 Anthropo-Reader 自动抓取整理 | 数据来源: 华南理工大学本科生院 | AI 摘要由硅基流动提供支持*
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
            'tags': tags[:5],
            'is_favorited': False
        }

        articles.append(article)

        # 礼貌延迟
        time.sleep(random.uniform(2, 4))

    print(f"\n处理完成！共生成 {len(articles)} 条结构化数据（含 AI 摘要）", file=sys.stderr)
    return articles


def main():
    """主函数"""
    parser = argparse.ArgumentParser(description='华工教务处爬虫（AI 增强版）')
    parser.add_argument('--pages', type=int, default=2, help='抓取页数（默认 2）')
    parser.add_argument('--limit', type=int, default=5, help='处理通知数量（默认 5，建议不超过 10 以控制 API 成本）')
    parser.add_argument('--category', type=int, default=0, help='通知分类')
    parser.add_argument('--output', default='', help='输出 JSON 文件路径')
    parser.add_argument('--upload', action='store_true', help='上传到 Supabase')
    parser.add_argument('--table', default='school_notices', help='Supabase 表名')
    parser.add_argument('--no-ai', action='store_true', help='禁用 AI 摘要（节省 API 调用）')

    default_url = "https://ovytvktzhuapvictznnr.supabase.co"
    default_key = "sb_secret_3DFQXsH8RqIldbdJAVrC5Q_A_xtu9uh"

    parser.add_argument('--supabase-url', default=default_url)
    parser.add_argument('--supabase-key', default=default_key)

    args = parser.parse_args()

    # Step 1: 抓取通知列表
    notices = fetch_notice_list(max_pages=args.pages, category=args.category)

    if not notices:
        print("⚠️  未抓取到任何通知", file=sys.stderr)
        sys.exit(1)

    print(f"\n✅ 共抓取到 {len(notices)} 条通知", file=sys.stderr)

    # Step 2: 处理通知详情（选择是否使用 AI）
    if args.no_ai:
        articles = process_notices(notices, limit=args.limit)
    else:
        articles = process_notices_with_ai(notices, limit=args.limit)

    # Step 3: 输出到文件
    if args.output:
        try:
            with open(args.output, 'w', encoding='utf-8') as f:
                json.dump(articles, f, indent=2, ensure_ascii=False)
            print(f"💾 数据已保存到: {args.output}", file=sys.stderr)
        except IOError as e:
            print(f"❌ 文件保存失败: {e}", file=sys.stderr)
    elif not args.upload:
        print(json.dumps(articles, indent=2, ensure_ascii=False))

    # Step 4: 上传到 Supabase
    if args.upload:
        url = args.supabase_url or os.environ.get('SUPABASE_URL')
        key = args.supabase_key or os.environ.get('SUPABASE_KEY')

        if url and key:
            save_to_supabase(articles, url, key, args.table)
        else:
            print("❌ 错误: 需要提供 Supabase URL 和 Key", file=sys.stderr)


if __name__ == '__main__':
    main()
