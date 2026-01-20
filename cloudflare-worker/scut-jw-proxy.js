// ==================== Cloudflare Worker 代理脚本 ====================
// 用途: 代理华工教务处 API 请求，绕过 GitHub Actions 的 IP 限制

export default {
  async fetch(request, env, ctx) {
    // 1. 处理 CORS 预检请求
    if (request.method === 'OPTIONS') {
      return new Response(null, {
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
          'Access-Control-Allow-Headers': 'Content-Type, X-Requested-With',
          'Access-Control-Max-Age': '86400',
        },
      });
    }

    // 2. 获取请求路径
    const url = new URL(request.url);

    // 支持两种 API 端点
    let targetUrl;
    if (url.pathname.includes('/findInformNotice.do')) {
      // AJAX API (推荐)
      targetUrl = 'https://jw.scut.edu.cn/zhinan/cms/article/v2/findInformNotice.do';
    } else if (url.pathname.includes('/toPosts.do')) {
      // 主页 (用于获取 Cookie)
      targetUrl = 'https://jw.scut.edu.cn/zhinan/cms/toPosts.do';
    } else {
      return new Response('Invalid endpoint. Use /findInformNotice.do or /toPosts.do', {
        status: 400,
        headers: { 'Access-Control-Allow-Origin': '*' }
      });
    }

    try {
      // 3. 读取请求体（重要：克隆请求体以支持重定向）
      let bodyData = null;
      if (request.method === 'POST') {
        bodyData = await request.text();
      }

      // 4. 构造代理请求
      const proxyRequest = new Request(targetUrl, {
        method: request.method,
        headers: {
          // 模拟真实浏览器请求头
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
          'Accept': 'application/json, text/javascript, */*; q=0.01',
          'Accept-Language': 'zh-CN,zh;q=0.9,en;q=0.8',
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'X-Requested-With': 'XMLHttpRequest',
          'Referer': 'https://jw.scut.edu.cn/zhinan/cms/toPosts.do',
          'Origin': 'https://jw.scut.edu.cn',
        },
        body: bodyData,
        redirect: 'follow', // 自动跟随重定向
      });

      // 5. 发送请求到教务处（带超时）
      const response = await fetch(proxyRequest, {
        signal: AbortSignal.timeout(15000), // 15 秒超时
      });

      // 6. 获取响应内容
      const responseBody = await response.text();

      // 7. 调试日志（可选，帮助排查问题）
      console.log('Status:', response.status);
      console.log('Response preview:', responseBody.substring(0, 200));

      // 8. 添加 CORS 头并返回
      return new Response(responseBody, {
        status: response.status,
        headers: {
          'Content-Type': response.headers.get('Content-Type') || 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
          'Access-Control-Allow-Headers': 'Content-Type, X-Requested-With',
        },
      });

    } catch (error) {
      // 9. 错误处理
      console.error('Proxy error:', error);
      return new Response(JSON.stringify({
        error: 'Proxy failed',
        message: error.message,
        timestamp: new Date().toISOString(),
      }), {
        status: 500,
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
        },
      });
    }
  }
};