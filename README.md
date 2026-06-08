# simpleprod

Product management for hackathons. A Claude Code plugin that stops you from building for a non-existent problem, or miss the problem with your build. 

## What it does

simpleprod forces you through structured product discovery before you start coding. It asks hard questions, challenges your assumptions, and won't let you skip to implementation until you've clarified what you're building and why.

## Workflows

1. **Problem Statement** - Who has the problem? What is it? Why does it matter?
2. **Competitive Research** - What already exists? Why is your approach different?
3. **Jobs to be Done** - What progress are your users trying to make?
4. **Personas** - Who specifically are you building for?
5. **Interview Script** - How would you validate your assumptions?
6. **Product Document** - Vision + outcome-driven requirements assembled from all the above.

Minimum path: Problem Statement + Product Document.

## Install

Copy paste this to Claude Code CLI and run:

```bash
claude plugins marketplace add martparve/simpleprod
claude plugins install simpleprod@simpleprod --scope user
```

Restart Claude Code. The plugin activates automatically when you start a new project.

## How it works

When you say "let's build X" in Claude Code, simpleprod intercepts and guides you through product discovery. It asks opinionated multiple-choice questions with recommendations, so you learn product thinking by seeing how a PM evaluates options.

All artifacts are saved to a `product/` directory in your project.

## Coexistence with coding skills

simpleprod owns discovery and planning. Coding skills (eg Obra Superpowers) own implementation. When your Product Document is ready, hand simpleprod artefacts over to coding skills for planning and implementation.

## Uninstall

```bash
claude plugins uninstall simpleprod
claude plugins marketplace remove simpleprod
```
