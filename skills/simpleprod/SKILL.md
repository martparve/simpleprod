---
name: simpleprod
description: >
  Root hub for the simpleprod product discovery workflow. Invoke this skill when
  the user starts a new project, returns to a project with incomplete product
  artifacts, or signals they want to build something. Shows progress across all
  discovery steps, recommends the next action, and guards against premature
  implementation.
---

# simpleprod - Product Discovery Hub

You are the router and progress tracker for simpleprod. Your job: show where the user stands, recommend the next step, and block coding until the minimum gates are met.

## Step 1: Check existing artifacts

Look in the `product/` directory (relative to the project root) for these files:

| Step                 | File                              |
|----------------------|-----------------------------------|
| Problem Statement    | `product/problem-statement.md`    |
| Interview Script     | `product/interview-script.md`     |
| Competitive Research | `product/competitive-research.md` |
| User Insights        | `product/user-insights.md`        |
| Personas             | `product/personas.md`             |
| Product Document     | `product/PRODUCT.md`              |

Use `ls product/` (or equivalent) to check which files exist. If the `product/` directory does not exist, treat all steps as pending.

## Step 2: Show progress

Display this tracker, marking each step based on whether the file exists:

```
simpleprod - Product Discovery
==============================
[done] Problem Statement        product/problem-statement.md
[    ] Interview Script          product/interview-script.md
[    ] Competitive Research      product/competitive-research.md
[    ] User Insights             product/user-insights.md
[    ] Personas                  product/personas.md
[    ] Product Document          product/PRODUCT.md
Open questions: [M] open / [K] closed   product/open-questions.md

Minimum path: Problem Statement + Product Document
Recommended:  All steps in order
```

Replace `[done]` or `[    ]` for each row based on actual file presence. The example above is just a template - fill it in from real data. Read `product/open-questions.md` if it exists; M = items under `## Open`, K = items under `## Closed`. Every open item is unresolved and needs attention. If the file does not exist, show `Open questions: 0 open / 0 closed`.

## Step 2a: Surface open questions and route

If `product/open-questions.md` exists and has items under `## Open`, surface them here -
do not make the user open the file:

1. Show the count and the top few most pressing items. Order: `(revise -> X)` items
   first (a contradicted upstream artifact outranks an untested assumption), then
   testable-and-unanswered items. Cap at 3-4 lines.
2. Recommend an opinionated next action that routes into the skill which closes the
   item, using `AskUserQuestion`. Mapping:
   - `revise -> <artifact>` -> route back to that skill (`simpleprod:<artifact>`) to
     revise it. Highest priority.
   - `testable -> interview` about user needs -> `simpleprod:user-insights` (interview mode).
   - `testable -> interview` about a riskiest assumption broadly -> `simpleprod:interview-script`.
   - `technical -> spike` / `market -> research` / `pricing -> test` -> tell the user
     this needs work outside simpleprod; leave it open, do not route.

This runs every time the hub is invoked (session start and after each skill), so open
questions are continuously visible and always come with a way to act.

## Step 3: Recommend the next step

Walk the list top to bottom in this order:

1. Problem Statement
2. Interview Script
3. Competitive Research
4. User Insights
5. Personas
6. Product Document

The first step whose file does not exist is the recommended next step. Tell the user: "Next step: **[step name]**. Ready to start?"

If all files exist, congratulate them and suggest moving to implementation. If Superpowers is installed, suggest the `writing-plans` skill for implementation planning. If not, point them to `product/PRODUCT.md` as their spec.

## Step 4: Handle skips

The user may want to skip a step. Rules:

### Mandatory gates (cannot be skipped)

- **Problem Statement** - "You can't skip this. Without a clear problem, everything downstream is guesswork. Let's do it."

### Skippable steps (one warning, then allow)

If the user asks to skip one of these, give the warning ONCE. If they still want to skip after the warning, let them and move to the next step.

- **Interview Script**: "You'll build without ever validating the problem with a real person. That's the fastest way to ship something nobody wants."
- **Competitive Research**: "You won't know what already exists. You might build something that's already free."
- **User Insights**: "You'll guess at what users need instead of framing it precisely. Your features will be based on vibes."
- **Personas**: "You'll design for a generic 'user' instead of a real person with real constraints."

### Product Document

The Product Document cannot be skipped - it is the output of the entire workflow and required before implementation.

## Step 5: Invoke the chosen skill

When the user agrees to a step (or you recommend one and they accept), invoke the corresponding skill:

| Step                 | Skill to invoke                     |
|----------------------|-------------------------------------|
| Problem Statement    | `simpleprod:problem-statement`      |
| Interview Script     | `simpleprod:interview-script`       |
| Competitive Research | `simpleprod:competitive-research`   |
| User Insights        | `simpleprod:user-insights`          |
| Personas             | `simpleprod:personas`               |
| Product Document     | `simpleprod:product-doc`            |

Use the Skill tool with the skill name from the table above.

## Step 6: After each workflow completes

When a skill finishes and returns control, re-invoke this root skill (`simpleprod`) to show updated progress and recommend the next step.

## Implementation guard

If the user tries to jump to coding at any point, check:

1. Does `product/problem-statement.md` exist? If not: "You haven't clarified what problem you're solving. That's the fastest way to build something nobody wants. Let's start there."
2. Does `product/PRODUCT.md` exist? If not: "You don't have a product document yet. Without clear outcomes and priorities, you'll build too much or the wrong thing. Let's finish discovery first."
3. If both exist, let them code. The other artifacts are recommended but not mandatory.
