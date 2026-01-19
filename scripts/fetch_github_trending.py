#!/usr/bin/env python3
"""
GitHub Trending Data Fetching Script
Fetches trending repositories from GitHub and uploads to Supabase
"""

import requests
import json
import os
import sys
import argparse
from datetime import datetime

# Try to import supabase
try:
    from supabase import create_client, Client
except ImportError:
    create_client = None

def fetch_trending_repos(language='', limit=20):
    """
    Fetch GitHub Trending repositories
    """
    url = "https://api.github.com/search/repositories"

    # Query: created in the last 30 days (approx) to ensure relevance
    # For demo purposes, we use a fixed date or relative logic.
    # Here we stick to a simple query for high stars.
    query = f'stars:>100'
    if language:
        query += f' language:{language}'

    params = {
        'q': query,
        'sort': 'stars',
        'order': 'desc',
        'per_page': limit
    }

    try:
        response = requests.get(url, params=params)
        response.raise_for_status()
        repos = response.json()['items']

        articles = []
        for repo in repos:
            # Build article content
            content = f"""# {repo['name']}

{repo['description'] or 'No description provided.'}

## Project Info
- **Stars**: {repo['stargazers_count']:,}
- **Language**: {repo['language'] or 'N/A'}
- **Forks**: {repo['forks_count']:,}
- **Open Issues**: {repo['open_issues_count']}
- **Created**: {repo['created_at'][:10]}
- **Last Updated**: {repo['updated_at'][:10]}

## Links
[View Project]({repo['html_url']})

## Author
[{repo['owner']['login']}]({repo['owner']['html_url']})
"""

            article = {
                'title': repo['name'],
                'summary': (repo['description'] or '')[:300],
                'content': content,
                'source': 'github_trending',
                'source_url': repo['html_url'],
                'author': repo['owner']['login'],
                'published_at': repo['created_at'],
                'fetched_at': datetime.now().isoformat(),
                'tags': [repo['language']] if repo['language'] else [],
                'is_favorited': False
            }
            articles.append(article)

        return articles

    except requests.exceptions.RequestException as e:
        print(f"Error: Failed to fetch data - {e}", file=sys.stderr)
        return []

def save_to_supabase(articles, url, key):
    """
    Upload articles to Supabase
    """
    if not create_client:
        print("Error: 'supabase' package not installed. Run: pip install supabase", file=sys.stderr)
        return

    print(f"Connecting to Supabase...", file=sys.stderr)
    try:
        supabase: Client = create_client(url, key)

        count = 0
        for article in articles:
            try:
                # Check for duplicates based on source_url
                # Note: This requires the key to have SELECT permissions
                existing = supabase.table('articles').select('id').eq('source_url', article['source_url']).execute()

                if existing.data:
                    print(f"Skipping existing: {article['title'][:20]}...", file=sys.stderr)
                else:
                    # Insert new article
                    # Note: This requires the key to have INSERT permissions (Service Role Key recommended)
                    supabase.table('articles').insert(article).execute()
                    print(f"Uploaded: {article['title'][:20]}...", file=sys.stderr)
                    count += 1

            except Exception as e:
                print(f"Error uploading {article['title'][:20]}: {e}", file=sys.stderr)

        print(f"Upload complete. New articles: {count}", file=sys.stderr)

    except Exception as e:
        print(f"Supabase connection error: {e}", file=sys.stderr)

def main():
    """Main function"""
    parser = argparse.ArgumentParser(description='Fetch GitHub Trending Data')
    parser.add_argument('--language', default='', help='Programming language filter')
    parser.add_argument('--limit', type=int, default=20, help='Number of results')
    parser.add_argument('--output', default='', help='Output file path')
    parser.add_argument('--upload', action='store_true', help='Upload to Supabase')

    # Args for Supabase credentials (optional, can use env vars)
    # Defaulting to provided credentials for ease of use
    default_url = "https://ovytvktzhuapvictznnr.supabase.co"
    default_key = "sb_secret_3DFQXsH8RqIldbdJAVrC5Q_A_xtu9uh"

    parser.add_argument('--supabase-url', default=default_url, help='Supabase Project URL')
    parser.add_argument('--supabase-key', default=default_key, help='Supabase API Key')

    args = parser.parse_args()

    print(f"Fetching GitHub Trending data...", file=sys.stderr)
    articles = fetch_trending_repos(args.language, args.limit)

    print(f"Successfully fetched {len(articles)} articles", file=sys.stderr)

    # Handle Output
    if args.output:
        try:
            output_data = json.dumps(articles, indent=2, ensure_ascii=False)
            with open(args.output, 'w', encoding='utf-8') as f:
                f.write(output_data)
            print(f"Saved to: {args.output}", file=sys.stderr)
        except IOError as e:
             print(f"Error saving file: {e}", file=sys.stderr)
    elif not args.upload:
        print(json.dumps(articles, indent=2, ensure_ascii=False))

    # Handle Upload
    if args.upload:
        # Prioritize args, then env vars
        url = args.supabase_url or os.environ.get('SUPABASE_URL')
        key = args.supabase_key or os.environ.get('SUPABASE_KEY') # Prefer SERVICE_ROLE_KEY for writing

        if url and key:
            save_to_supabase(articles, url, key)
        else:
            print("Error: Supabase URL and Key required for upload.", file=sys.stderr)
            print("Provide via arguments --supabase-url/--supabase-key or environment variables.", file=sys.stderr)

if __name__ == '__main__':
    main()
