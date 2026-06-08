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
| Competitive Research | `product/competitive-research.md` |
| Jobs to be Done      | `product/jtbd.md`                 |
| Personas             | `product/personas.md`             |
| Interview Script     | `product/interview-script.md`     |
| Release Planning     | `product/release-plan.md`         |
| Product Document     | `product/PRODUCT.md`              |

Use `ls product/` (or equivalent) to check which files exist. If the `product/` directory does not exist, treat all steps as pending.

## Step 2: Show progress

Display this tracker, marking each step based on whether the file exists:

```
simpleprod - Product Discovery
==============================
[done] Problem Statement        product/problem-statement.md
[    ] Competitive Research      product/competitive-research.md
[    ] Jobs to be Done           product/jtbd.md
[    ] Personas                  product/personas.md
[    ] Interview Script          product/interview-script.md
[    ] Release Planning          product/release-plan.md
[    ] Product Document          product/PRODUCT.md

Minimum path: Problem Statement + Release Planning + Product Document
Recommended:  All steps in order
```

Replace `[done]` or `[    ]` for each row based on actual file presence. The example above is just a template - fill it in from real data.

## Step 3: Recommend the next step

Walk the list top to bottom in this order:

1. Problem Statement
2. Competitive Research
3. Jobs to be Done
4. Personas
5. Interview Script
6. Release Planning
7. Product Document

The first step whose file does not exist is the recommended next step. Tell the user: "Next step: **[step name]**. Ready to start?"

If all files exist, congratulate them and suggest moving to implementation. If Superpowers is installed, suggest the `writing-plans` skill for implementation planning. If not, point them to `product/PRODUCT.md` as their spec.

## Step 4: Handle skips

The user may want to skip a step. Rules:

### Mandatory gates (cannot be skipped)

- **Problem Statement** - "You can't skip this. Without a clear problem, everything downstream is guesswork. Let's do it."
- **Release Planning** - "You can't skip this. Without a scoped plan, you'll build too much or the wrong thing. Let's do it."

### Skippable steps (one warning, then allow)

If the user asks to skip one of these, give the warning ONCE. If they still want to skip after the warning, let them and move to the next step.

- **Competitive Research**: "You won't know what already exists. You might build something that's already free."
- **Jobs to be Done**: "You'll guess at what users need instead of framing it precisely. Your features will be based on vibes."
- **Personas**: "You'll design for a generic 'user' instead of a real person with real constraints."
- **Interview Script**: "You'll have no way to validate your assumptions with real people."

### Product Document

The Product Document cannot be skipped - it is the output of the entire workflow and required before implementation.

## Step 5: Invoke the chosen skill

When the user agrees to a step (or you recommend one and they accept), invoke the corresponding skill:

| Step                 | Skill to invoke                     |
|----------------------|-------------------------------------|
| Problem Statement    | `simpleprod:problem-statement`      |
| Competitive Research | `simpleprod:competitive-research`   |
| Jobs to be Done      | `simpleprod:jtbd`                   |
| Personas             | `simpleprod:personas`               |
| Interview Script     | `simpleprod:interview-script`       |
| Release Planning     | `simpleprod:release-planning`       |
| Product Document     | `simpleprod:product-doc`            |

Use the Skill tool with the skill name from the table above.

## Step 6: After each workflow completes

When a skill finishes and returns control, re-invoke this root skill (`simpleprod`) to show updated progress and recommend the next step.

## Implementation guard

If the user tries to jump to coding at any point, check:

1. Does `product/problem-statement.md` exist? If not: "You haven't clarified what problem you're solving. That's the fastest way to build something nobody wants. Let's start there."
2. Does `product/release-plan.md` exist? If not: "You don't have a scoped plan. You'll build too much or the wrong thing. Let's scope this first."
3. If both exist, let them code. The other artifacts are recommended but not mandatory.
