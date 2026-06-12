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
Interviews: [N] total, [P] new (not yet synthesized)   product/interviews/

Minimum path: Problem Statement + Product Document
Recommended:  All steps in order
```

Replace `[done]` or `[    ]` for each row based on actual file presence. The example above is just a template - fill it in from real data. Read `product/open-questions.md` if it exists; M = items under `## Open`, K = items under `## Closed`. Every open item is unresolved and needs attention. If the file does not exist, show `Open questions: 0 open / 0 closed`. For interviews, read `product/interviews/` (ignore `README.md` and `_`-prefixed files): N = total interview files, P = those whose first line does not contain `simpleprod: synthesized`. If the folder does not exist, show `Interviews: 0 total, 0 new`.

## Step 2a: Surface open questions, interviews, and route

If `product/open-questions.md` has items under `## Open`, or `product/interviews/`
has files, surface them here - do not make the user open the files. Write the items
themselves in your message, then recommend an opinionated next action with
`AskUserQuestion`; keep each question field to a short prompt (long question text
truncates in the terminal). Priority order:

1. **New interviews waiting** (P > 0 from the tracker): "You have P new interviews.
   Synthesize them now (run `simpleprod:user-insights`) so they inform the rest of
   the work." This outranks the linear next step - the sooner interviews are
   consumed, the more informed everything downstream is.
2. **`(revise -> X)` items**: a contradicted upstream artifact - route back to that
   skill (`simpleprod:<artifact>`) to revise it.
3. **Open `(testable -> interview)` items**: these are interviews worth doing.
   Surface the actual questions: "These N questions can only be answered by real
   people - here they are. Want to interview? Your script is at
   `product/interview-script.md` (run `simpleprod:interview-script` if you need one)."
4. **Other open items** (`technical -> spike` / `market -> research` /
   `pricing -> test`): tell the user this needs work outside simpleprod; leave open,
   do not route.

Cap the surfaced list at 3-4 lines. This runs every time the hub is invoked, so
interviews and open questions are continuously visible and always come with a way to
act.

## Step 3: Recommend the next step

Walk the list top to bottom in this order:

1. Problem Statement
2. Interview Script
3. Competitive Research
4. User Insights
5. Personas
6. Product Document

The first step whose file does not exist is the recommended next step. Tell the user: "Next step: **[step name]**. Ready to start?"

If `product/PRODUCT.md` exists, the product is established - switch to feature-backlog mode (Step 3a) rather than treating discovery as merely finished. (Any greenfield steps that were skipped remain available, but a live product's day-to-day is features.)

## Step 3a: Feature backlog (when PRODUCT.md exists)

Once `product/PRODUCT.md` exists, the hub also manages features. Read the `## Features`
section of PRODUCT.md and show the backlog count, e.g. `Features: 3 (2 Open, 1 Done)` -
Open/Done counted from each entry's `Status:` line; if there is no `## Features`
section, show `Features: 0`.

Then offer, via `AskUserQuestion`:
- **Add a feature** -> invoke `simpleprod:feature`. It runs scoped discovery from the
  feature's own problem and writes a new `Status: Open` entry.
- **Mark a feature Done** -> flip an Open entry's `Status: Open` to `Status: Done` (the
  user confirms it is built).

A feature is never written into PRODUCT.md directly; it always goes through
`simpleprod:feature` first.

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
| Feature (existing product) | `simpleprod:feature`          |

Use the Skill tool with the skill name from the table above.

## Step 6: After each workflow completes

When a skill finishes and returns control, re-invoke this root skill (`simpleprod`) to show updated progress and recommend the next step.

## Implementation guard

If the user tries to jump to coding at any point, check:

1. Does `product/problem-statement.md` exist? If not: "You haven't clarified what problem you're solving. That's the fastest way to build something nobody wants. Let's start there."
2. Does `product/PRODUCT.md` exist? If not: "You don't have a product document yet. Without clear outcomes and priorities, you'll build too much or the wrong thing. Let's finish discovery first."
3. If both exist, let them code. The other artifacts are recommended but not mandatory.
4. For a new feature on an existing product (PRODUCT.md already exists): it must be a `Status: Open` entry in PRODUCT.md's `## Features` with acceptance criteria before it is built. If the user wants to code a feature that isn't there yet, route to `simpleprod:feature` first - discovery before code, same as the product.
