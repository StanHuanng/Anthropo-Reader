import '../../../../core/models/article.dart';

class MockArticleDataSource {
  static List<Article> getMockArticles() {
    return [
      Article(
        id: '1',
        title: 'Building a RISC-V Processor in Verilog',
        summary: 'A complete 32-bit RISC-V processor implementation built from scratch using Verilog HDL. Features 5-stage pipeline, Harvard architecture, and 32-bit datapath.',
        content: '''# Building a RISC-V Processor in Verilog

## Introduction
This project demonstrates a complete implementation of a RISC-V RV32I processor...

## Architecture
- 5-stage pipeline
- Harvard architecture
- 32-bit data path

## Code Example
\`\`\`verilog
module riscv_core (
  input wire clk,
  input wire rst,
  // ... more ports
);
\`\`\`
''',
        source: 'github_trending',
        sourceUrl: 'https://github.com/example/riscv-verilog',
        author: 'hardware_guru',
        publishedAt: DateTime.now().subtract(Duration(hours: 2)),
        fetchedAt: DateTime.now(),
        tags: ['RISC-V', 'Verilog', 'Hardware'],
      ),
      Article(
        id: '2',
        title: 'Advanced Flutter Architecture Patterns',
        summary: 'Exploring clean architecture, riverpod state management, and functional programming in Flutter apps.',
        content: '''# Advanced Flutter Architecture

## Clean Architecture
Separating your app into layers is crucial for maintainability...

## State Management
Using Riverpod for dependency injection and state management...
''',
        source: 'WeChat',
        sourceUrl: 'https://mp.weixin.qq.com/s/example',
        author: 'flutter_dev',
        publishedAt: DateTime.now().subtract(Duration(days: 1)),
        fetchedAt: DateTime.now(),
        tags: ['Flutter', 'Architecture', 'Dart'],
      ),
       Article(
        id: '3',
        title: 'Deep Learning with PyTorch',
        summary: 'A comprehensive guide to building neural networks with PyTorch, covering tensors, autograd, and model training.',
        content: '''# Deep Learning with PyTorch

## Tensors
Tensors are the fundamental building blocks...

## Training Loop
```python
for epoch in range(100):
    # training code
```
''',
        source: 'github_trending',
        sourceUrl: 'https://github.com/example/pytorch-guide',
        author: 'ai_researcher',
        publishedAt: DateTime.now().subtract(Duration(hours: 5)),
        fetchedAt: DateTime.now(),
        tags: ['AI', 'Python', 'PyTorch'],
      ),
    ];
  }
}
