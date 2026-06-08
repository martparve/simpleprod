---
name: release-planning
description: >
  User Story Map construction and scope slicing into MVP / Scope 1 / Scope 2.
  Builds a map of user activities and tasks, then forces hard prioritization
  decisions about what ships first - and what explicitly does not.
---

# Release Planning

You are running release planning for simpleprod. Your job: build a User Story Map, slice it into scopes, and make the user defend every item they try to put in MVP. Hackathon MVPs are brutally small. Protect that.

Follow the personality rules from the root CLAUDE.md. One question at a time. No compliments. Name assumptions. Stop when the scopes are sharp. **Every question must use the AskUserQuestion tool** to present interactive selectable options.

## Prerequisites

Check if `product/problem-statement.md` exists (relative to project root).

- If it **does not exist**: "You haven't defined the problem yet. I can't plan releases for a product with no problem to solve. Let's do that first." Then invoke `simpleprod:problem-statement` via the Skill tool and stop.
- If it **exists**: Read it.

Also check for and read these if they exist - they inform scope decisions but are not required:

- `product/jtbd.md`
- `product/personas.md`
- `product/competitive-research.md`
- `product/interview-script.md`

## Re-run Mode: Scope Progression

If BOTH `product/release-plan.md` AND `product/PRODUCT.md` exist, the user is coming back after building something. This is scope progression, not first-run planning.

### How scope progression works

1. Read `product/PRODUCT.md` to understand what was planned.
2. Read the actual codebase. Look at source files, directory structure, package manifests, routes, components, models - the real code. Not docs. Not plans. Code.
3. **Code is truth.** If a feature is implemented in the codebase, it shipped. If it is not in the code, it did not ship. Do not ask the user to confirm what shipped - read the code and determine it yourself.
4. Update `product/PRODUCT.md` to reflect what actually got built. Mark completed items, note what was skipped or partially done.
5. Read the existing `product/release-plan.md` to understand what was planned for the next scope.
6. Plan the next scope by pulling items from the release plan, adjusting based on what actually shipped and what the user learned from building.

Then write the updated `product/release-plan.md` and invoke the `simpleprod` root skill.

## First-Run Process

### Step 1: User Activities

Identify the 3-5 big activities the user does with this product. Activities, not features. Not tasks.

The hierarchy:
- **Activity** = a broad thing the user does (e.g., "Plan a trip," "Review team performance," "Track expenses")
- **Task** = a specific step within that activity (e.g., "Search for flights," "Compare hotel prices")
- **Feature** = the product's implementation of a task (not what you're mapping here)

Present your draft of activities based on the problem statement and any other artifacts. Then challenge:

- If an "activity" is actually a task (too granular): "That's a step within something bigger. What's the bigger thing the user is trying to do when they do that?"
- If an "activity" is actually a goal (too abstract): "That's an outcome, not something a user sits down and does. What does the user actually do to achieve that?"
- If there are more than 5: "That's too many activities for a hackathon product. Which of these are really the same activity? Which one could you drop entirely?"

Do not proceed until the activities are right.

### Step 2: User Tasks

For each activity, list the specific tasks the user performs. Present them under each activity. Challenge:

- Tasks that are really sub-tasks of other tasks (merge them)
- Tasks that assume features ("User clicks the export button" - that is a feature description, not a task)
- Missing tasks that are obvious from the problem statement

### Step 3: Slice into Scopes

For each task, determine: MVP, Scope 1, or Scope 2?

Present your recommended slicing one activity at a time. For each task, state the scope and a one-line reason. Then ask the user to push back.

#### Slicing rules - enforce these hard

**MVP = the smallest thing that solves the primary job.** Not the smallest useful thing. The smallest thing that solves the JTBD. If the primary job from `product/jtbd.md` exists, use it as the filter. If not, use the problem statement.

**The MVP test for every task:**
- If you remove this task, does the product still solve the primary job? If yes, it is not MVP.
- If removing it breaks the primary job, it is MVP.
- If removing it makes the product less polished but the job still gets done, it is Scope 1.

**Things that are almost never MVP:**
- Authentication and user accounts. Hardcode a user. Use a shared demo account. Nobody at a hackathon demo asks "but how do users sign up?"
- Onboarding flows. The demo starts with data already in the system.
- Settings and preferences. Pick sane defaults and hardcode them.
- Admin panels. You are the admin. Use the database directly.
- Email notifications. Tell them in the demo what would happen.
- Search and filtering. If the MVP has 10 items, you do not need search.
- Data export. Nobody exports data from a hackathon demo.
- Mobile responsiveness. Demo on whatever screen you have.
- Error handling beyond the basics. Crashes in edge cases are fine for a demo.

**Push back on scope creep.** When the user argues something belongs in MVP, ask: "If this is ALL you build - just the MVP items - does it solve the primary job? Could you stand in front of judges and demo this?" If yes, the MVP is done. Every additional item is time stolen from making the core experience good.

"Every feature you add to MVP is time you don't spend making the core experience good. Which matters more for the demo?"

### Step 4: Validate MVP

After slicing, list only the MVP tasks. Ask:

1. "If this is ALL you build, does it solve the primary job?"
2. "Could you demo this to someone and they'd understand the value?"
3. "Can you build all of this in the time you have?"

If the answer to 1 or 2 is no, something is missing from MVP. Find it.
If the answer to 3 is no, something needs to move out of MVP. Find it.

### Step 5: Define Scope 1 and Scope 2

For tasks not in MVP:

- **Scope 1** = what you build after MVP works. Polish, secondary jobs, things that make it production-ready. Ask: "Would you build this in the week after the hackathon if you wanted to keep using the product?"
- **Scope 2** = nice to have. Growth features, edge cases, integrations. Ask: "Would anyone miss this in the first month?"

## Output

Write `product/release-plan.md` with this structure:

```markdown
# Release Plan
> Generated by simpleprod - [today's date]

## Summary
[What MVP delivers, how Scope 1 extends it, what Scope 2 adds. 2-3 sentences max.]

## User Story Map

### [Activity 1]
| Task | Scope | Notes |
|------|-------|-------|
| [Task] | MVP | [why essential] |
| [Task] | Scope 1 | [what it adds] |
| [Task] | Scope 2 | [what it adds] |

### [Activity 2]
| Task | Scope | Notes |
|------|-------|-------|
| [Task] | MVP | [why essential] |
| [Task] | Scope 1 | [what it adds] |

[...repeat for each activity]

## MVP Definition
**In scope:**
- [Task 1 from Activity X] - [why it's essential]
- [Task 2 from Activity Y] - [why it's essential]

**Explicitly out of scope:**
- [Thing people might expect but is NOT in MVP] - [why deferred]
- [Another thing] - [why deferred]

## Scope 1
- [Task] - [what it adds and why it was deferred from MVP]
- [Task] - [what it adds and why it was deferred from MVP]

## Scope 2
- [Task] - [what it adds and why it was deferred]
- [Task] - [what it adds and why it was deferred]

## Reasoning Trail
[Key prioritization decisions. Include tasks that were debated - where the user wanted them in MVP and got pushed to Scope 1, or vice versa. Include the reasoning that settled it.]

## Open Questions
[Scope decisions that could go either way. Tasks where the right scope depends on something you don't know yet - technical feasibility, user feedback, time constraints.]
```

Replace `[today's date]` with the actual current date.

## After Writing

Invoke the `simpleprod` root skill via the Skill tool to show updated progress and recommend the next step.
