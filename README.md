# simpleprod

Product Management skills for POC-s, hackathons and other small projects. A Claude Code plugin that stops you from building for a non-existent problem, or miss the problem with your build. 

## What it does

simpleprod forces you through structured product discovery before you start coding. It asks hard questions, challenges your assumptions, and won't let you skip to implementation until you've clarified what you're building and why.

### Workflows

1. **Problem Statement** - Who has the problem? What is it? Why does it matter?
2. **Competitive Research** - What already exists? Why is your approach different?
3. **User Insights** - What progress are your users trying to make? Draft jobs as hypotheses, then ground them in JTBD-style switch interviews. Every job carries a status (hypothesis, supported, refined, contradicted, discovered) so a guess never masquerades as a validated need.
4. **Personas** - Who specifically are you building for?
5. **Interview Script** - How would you validate your assumptions?
6. **Product Document** - Vision + outcome-driven requirements assembled from all the above.

Minimum path: Problem Statement + Product Document.

### Open questions don't get lost

Every unvalidated assumption raised during discovery goes into a shared register (`product/open-questions.md`) instead of dying at the bottom of a document. The hub surfaces them as you work and routes you to whatever closes them. Before it assembles the Product Document, simpleprod forces a decision on each testable one: answer it, plan how to validate it, or knowingly accept the risk. Nothing reaches the final doc as a silent guess.

### Out of scope

1. **Metrics** - Which metrics matter; how to collect and analyze user behaviour data? 
2. **Building it out** - simpleprod owns discovery and planning. When your Product Document is ready, hand simpleprod artefacts over to coding skills (eg Obra Superpowers) for planning and implementation. 

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

## Uninstall

```bash
claude plugins uninstall simpleprod
claude plugins marketplace remove simpleprod
```
