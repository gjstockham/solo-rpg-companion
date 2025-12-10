---
name: prompt-engineering
description: Improve and optimize prompts for LLMs and SLMs. Use when refining starter prompts, selecting prompting techniques, designing system prompts for agents, or optimizing prompts for specific models. Covers technique selection (chain-of-thought, few-shot, ReAct, etc.), model-specific considerations, and Microsoft Agent Framework prompt patterns.
---

# Prompt Engineering

Improve prompts through systematic analysis and technique selection.

## Prompt Improvement Workflow

### 1. Analyze the Current Prompt

Identify:
- **Goal**: What should the model produce?
- **Context**: What information does the model need?
- **Constraints**: Output format, length, style, safety requirements
- **Failure modes**: Where might the current prompt go wrong?

### 2. Select Techniques

Choose based on task characteristics. See `references/techniques.md` for detailed guidance.

| Task Type | Recommended Techniques |
|-----------|----------------------|
| Simple factual/classification | Zero-shot, clear instructions |
| Complex reasoning | Chain-of-thought, step-by-step |
| Consistent format needed | Few-shot examples, structured output |
| Multi-step tasks | Prompt chaining, decomposition |
| Agent/tool use | ReAct, function schemas |
| Creative/open-ended | Role prompting, temperature tuning |
| Accuracy-critical | Self-consistency, verification steps |

### 3. Apply Improvements

**Structure**: Task → Context → Instructions → Format → Examples (if needed)

**Clarity checklist**:
- Remove ambiguity (define terms, specify edge cases)
- Use positive instructions ("do X") over negative ("don't do Y")
- Separate instructions from content with delimiters
- Specify output format explicitly

### 4. Validate

- Test with edge cases and adversarial inputs
- Check for instruction-following on format requirements
- Verify reasoning quality (not just final answer)

## Model-Specific Considerations

### Large Models (GPT-4, Claude, etc.)
- Excel at nuanced instructions and complex reasoning
- Can handle longer contexts and multi-step tasks
- Often benefit from explicit reasoning requests
- Support sophisticated structured output

### Smaller Models (Phi, Llama-7B, Mistral-7B, etc.)
- Need clearer, more explicit instructions
- Benefit more from few-shot examples
- Keep prompts concise; avoid instruction overload
- Simpler output formats more reliable
- May need task decomposition for complex work

### Microsoft Agent Framework

For agent system prompts:
- Define the agent's role and capabilities clearly
- Specify available tools/functions with precise schemas
- Include behavioral guidelines (when to use tools, when to respond directly)
- Handle edge cases explicitly (unknown queries, errors, out-of-scope requests)

## Quick Reference

**When adding few-shot examples**: Use 2-5 diverse examples covering edge cases. Format examples exactly as expected output.

**When using chain-of-thought**: Add "Let's think step by step" or "Reason through this carefully" for complex problems. Include reasoning structure in examples.

**When output format matters**: Use JSON/XML schemas, provide exact format examples, consider grammar-constrained decoding if available.

**When prompt is too long**: Decompose into chained prompts, move reference material to retrieval, prioritize most impactful instructions.

For detailed technique explanations and examples, see `references/techniques.md`.
