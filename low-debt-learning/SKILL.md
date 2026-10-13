---
name: low-debt-learning
description: Use when explaining learning concepts, planning a learning path, evaluating or trimming learning materials, updating old knowledge, or learning around a project. Choose modern, stable default practices with a low cognitive load for the learner's target environment. Reduce historical baggage and unnecessary implementation alternatives. Do not use for simple factual questions, pure translation, or rewriting.
---

# Learning with Low Cognitive Debt

## Goals and Constraints

Help learners build correct knowledge that they can apply and transfer to other situations, with as little cognitive load as possible. Focus first on how to solve problems in the current target environment, not on how the technology evolved over time.

- Respect the user's chosen materials, technical environment, exam, theory, or exploration goals. When no target environment is specified, prefer practices that are currently valid, stable, and widely applicable.
- Do not add learning branches to support old devices, systems, languages, or code versions. Cover them only when the old environment or history itself is a learning goal.
- Do not judge actual value by when a technology appeared, how popular it is, or how new its syntax is.
- Keep the principles, prerequisites, and limits of applicability needed to understand the current knowledge correctly.
- Do not measure learning quality by knowledge coverage, the number of language features, or tutorial length.
- Do not force theory learning into project development. Do not require advanced knowledge to have an immediate, visible practical benefit.

## Default Teaching Approach

### Choose One Default Practice

For the same common need, prefer one default implementation that fits the target environment. Consider:

1. Correctness and accurate semantics.
2. Whether it meets current and reasonably expected needs.
3. Readability and cognitive cost.
4. Actual performance and resource costs.
5. Consistency with other code in the target environment.

When a new implementation covers the common uses of an old one and is simpler and clearer, with no meaningful cost, teach the new implementation directly. Do not teach the old method first and then present the new one as an improvement. Do not teach several equivalent forms side by side just to show complete coverage.

Do not replace an implementation that is already clear and suitable just to use the newest features.

### Introduce Alternatives Based on Actual Needs

Introduce an alternative proactively only when it has a use that the default approach cannot adequately cover. Examples include different behavior or semantics, a specific configuration, a performance difference that matters to the current task, real environment constraints, or a prerequisite concept needed for later learning.

When introducing an alternative, state the current need, the default approach's limit, and the specific problem the alternative solves. Do not add a learning branch just because another form is valid, common, or was once popular.

**Example: Teach `List<T>` initialization in .NET 10 / C# 14 at three levels.**

**Level 1: Default form (learn it and actively use it)**

For normal list initialization, teach collection expressions directly. Do not teach equivalent older forms alongside them:

```csharp
List<int> numbers = [1, 2, 3];
```

**Level 2: Form for a specific need (learn it when needed)**

Introduce the constructor only when the need becomes “create an empty list and reserve capacity for adding many elements later.” The type is already given on the left, so target-typed `new` is enough:

```csharp
List<int> numbers = new(1000);
```

Here, `Count` is 0 and `Capacity` is 1000. This does **not** create 1000 elements. It is not equivalent to Level 1: it solves a different need.

**Level 3: Form to recognize (not a standard for actively writing code)**

When reading other projects, learners may see:

```csharp
List<int> numbers = new List<int> { 1, 2, 3 };
```

It is enough to know that this creates a list with three elements. It does not need to be taught alongside Level 1 in the main text of beginner materials. `new() { 1, 2, 3 }` is also a valid form of the same kind, but it does not need a separate learning branch.

These three levels describe **learning requirements**, not an absolute ranking of syntax: what to use by default, when there is a reason to switch, and what only needs to be understood when reading. Collection expressions can use a known element count to optimize construction, but do not describe a specific capacity or allocation strategy as a permanent language guarantee. This example shows a way to select learning content across technical fields. It does not require other languages to copy C# syntax.

### Control Cognitive Load

Cognitive load comes not only from the amount of knowledge, but also from unnecessary choices.

- Introduce only the concepts needed to move toward the current goal. By default, show only the recommended implementation.
- Do not proactively list equivalent historical forms, version history, or APIs unrelated to the current goal.
- Do not repeat learning goals and selection principles that are already clear.
- Do not turn a simple question into an ecosystem overview, technology history, or a long comparison of approaches.
- Do not fill learning materials with long introductions, transitions, or repeated summaries.
- Omit content that does not need to be learned yet. There is no need to list every item that will not be studied for now.
- When necessary, explain the limits of simplified examples. Do not omit key conditions in a way that causes misunderstanding.

## Choose the Approach for the Task

Use the conversation to identify the learner's goals, existing knowledge, and relevant constraints. Proceed directly when there is enough context. Ask for clarification only when missing information would significantly change the learning path. Choose the approaches below as needed. They are not a required checklist or fixed report structure.

### Explain Concepts

- Directly explain the problem the concept solves, its basic mechanism, and its uses. Use the default implementation for the target environment.
- Prefer concrete examples over lists of definitions and historical details.
- Add counterexamples or limits only when they affect correct understanding.
- Distinguish stable principles, specific implementations, and conditions of use. Do not require learners to master several implementations at once just because they exist.

### Plan a Learning Path

- Organize the sequence around goals and prerequisites, not the release dates of technical features.
- Do not add stages just to cover a textbook's table of contents. Do not assume old systems must be learned first.
- Introduce deferred content when an actual need, prerequisite dependency, or explicit exploration goal appears.
- Give a next step the learner can start immediately and suitable ways to check understanding at each stage.

### Guide Practice

- First provide a simple, complete, correct implementation that meets the current need.
- Do not introduce abstractions or architecture before they solve an actual problem.
- Before extending the solution, explain the new need and the limits of the existing approach. Distinguish real simplification from hiding necessary complexity.
- Do not invent unnatural requirements just to practice specific syntax. Keep code style consistent.

### Evaluate, Trim, or Update Learning Materials

First read the actual content relevant to the task in the materials the user specifies. Reorganize the material around the learning goal. Do not keep the original table of contents by default. Identify necessary knowledge, currently recommended practices, special cases, historical compatibility, repeated explanations, and topics for later study.

- Keep necessary principles, prerequisites, limits of applicability, and implementations with practical uses of their own.
- Prefer currently recommended forms. Remove redundant historical forms, version history, and repeated examples.
- Remove unnecessary introductions, transitions, and summaries. Do not remove necessary concepts just because they look traditional.
- Check the relevant original text before trimming. Check whether removed sections contain definitions or conditions that retained sections depend on.
- After trimming, check knowledge completeness, prerequisite relationships, and whether examples are valid in the target environment.
- Distinguish “excerpts or trimmed original text” from “learning materials rewritten using modern practices.” Simply removing pages does not complete syntax modernization.
- Do not claim to have checked materials you have not reviewed.

## Historical Knowledge and Modern Practices

Do not teach technology version history by default. Introduce it only when the user is studying history, historical context is needed to explain design reasons, conflicting materials need an explanation, reading existing code requires recognizing old forms, or old and new implementations have real differences that affect the current task.

“Being able to read historical code” and “actively using historical forms” are different goals. Forms that only need recognition can be explained when learners actually encounter them. They do not need to appear in the main beginner text.

## Currency and Evidence

For facts that can change, such as versions, APIs, default settings, support, performance, or deprecation status, check official documentation, standards, release notes, or other primary sources. Distinguish official guarantees, current implementation behavior, empirical performance advice, and code style preferences.

- Do not describe an optimization in a specific compiler or runtime as a permanent language guarantee.
- Do not claim better performance just because code is shorter. Do not assume one approach is better because of when it appeared.
- State uncertainty when verification is not possible. Do not describe remembered information as a verified fact.

## Completion and Feedback

- Deliver the explanation, learning path, exercise, or materials needed for the current request directly. Do not repeat learning principles that are already clear.
- When checking understanding is needed, use explanations in the learner's own words, result predictions, application exercises, or exercises that transfer knowledge to a new situation. Successfully running an example does not mean the learner has mastered it.
- Adjust depth and default implementations based on actual feedback. Do not guess learning outcomes.
- Stop when the current request is satisfied. Do not automatically add more lessons.
