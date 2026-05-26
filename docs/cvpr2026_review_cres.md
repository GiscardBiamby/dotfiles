# review for mpers paper

Pretend you are a smart phd student with expertise that is relevant to this paper, in computer vision and LLMs, and remote sensing. You are to be skeptical and critical, but fair and also thorough and thoughtful, really trying to only review as is done in a top computer science computer vision conference journal. Attached is the paper, and below is a skeleton of a reviewing framework that is partially filled out. Each section has a title with some text instructions for the reviewer, and then there is a section following that with the same title but suffixed with " Response", followed by my response as the reviewer. Fill out the reviewer response sections that i haven't filled out yet, and add to the ones that I already filled out. Be concise, use very plain language, don't use unnecessary adjectives. Don't take anything the authors in the paper claim for granted, and don't assume they do anything correctly unless they explicitly state it.

---

Compare your review with the one I came up with, which is pasted below. Generate a "diff" style output that tells me what edits/additions/removals (and where to make them) to close the gap between yours and mine. Don't make it a literal code style diff, just in the sense of tell me where our revviews differ, and suggest the edit i should make to mine ("remove this sentence/section...", "replace this with this....", "add this after the third bullet in this section"). For each one give a bried description of why the edit is necessary unless it is obvious without explanation. Check my review for correctness, and if the feedback I am giving is correct and fair. Make sure I am not asking for things that are "missing" that are actually mentinoed in the paper, that i am not making any misunderstandings of the paper, etc.

---

## Review title

Addressing Multimodal Alignment Drift via ADMER with Limited Empirical Breadth.

---

## Paper Summary

Summarize in your own words the paper, its key ideas, its contributions and their significance. This summary will help the AC and the authors understand the rest of your review and be confident that you understand the paper.

## Paper Summary Response

This paper formalizes Continual Referring Expression Segmentation (CRES), a task requiring models to incrementally learn language-guided, pixel-level segmentation. The authors identify multimodal alignment drift as the primary hurdle, consisting of semantic knowledge forgetting (losing the "what") and spatial grounding degradatio (losing the "where"). To address this, they propose ADMER (Alignment Drift guided Multimodal Exemplar Replay).

The core of ADMER is a Multimodal Coherence Selector that prioritizes replaying samples with low "coherence" scores. This score is derived from two metrics: (1) Multimodal Correlation Concentration (MCC), which uses the standard deviation of cross-attention maps as a proxy for spatial grounding confidence, and (2) Multimodal Representation Cohesion (MRC), which measures the cosine similarity between current multimodal embeddings and class prototypes to assess semantic consistency.

The method is evaluated on three re-split datasets (RefCOCO, RefCOCO+, RefCOCOg) and claims superior stability and plasticity over existing unimodal and CLIP-based continual learning methods.

---

## Paper Strengths

List anything that you think could be of interest to readers and explain why. For example:

- What did you learn from the paper?
- Is there a key idea that could inspire others (remember that simple but powerful ideas can be more impactful than overly complicated architectures)?
- Does the paper present significant results that are likely of interest to people in the community?

## Paper Strengths Response

- Defining CRES as a distinct continual-learning setting for language-guided segmentation is useful. The embodied-agent motivation is plausible, though the experiments are limited to static RES datasets.
- Using cross-attention behavior as a proxy for grounding uncertainty is a nice training-free way to detect when a model is beginning to "forget" spatial associations.
- The paper provides a clear breakdown of how MCC and MRC contribute to performance, showing that combining spatial and semantic signals yields the best results for old task preservation.
- The qualitative analysis in Figure 4 is interesting; it shows the model can sometimes segment unseen classes (e.g., "person") by grounding associated attributes like "green" or "left," suggesting the model learns reusable multimodal features.
- The method is simple and easy to reproduce in principle: it reduces replay selection to two interpretable signals (attention-map concentration and prototype similarity) and a clear ranking rule.

---

## Major Weaknesses Prompt

Describe here as carefully as possible the weaknesses that you think could justify a rejection. Major weaknesses include:

The paper does not provide sufficient evidence to support the claims it makes.
The claims made by the paper are not novel. (you have to provide citations)
The claims made by the paper are not meaningful or of possible interest to the community.
Remember that a submission is not required to compare to closed source papers per a recent PAMI-TC motion, or papers that are only on arxiv (per earlier PAMI-TC motion).

## Major Weaknesses Response

- Benchmark construction is under-specified in the main paper. Tasks are defined via 12 object supercategories, but it is unclear how each referring-expression instance is mapped to a supercategory label (especially for ambiguous or multi-object expressions), and how such cases are handled. Without this, it is hard to tell whether measure "forgetting" reflects continual learning dynamics or label/assignment noise.
- The "continual" aspect is tested on only 12 hjgh level categories. In real-world "open environments" mentioned in the abstract, the number of object classes is orders of magnitude higher. It is unclear if a replay buffer of 800 samples per class is scalable when moving from 12 classes to hundreds. Even within this benchmark, it would help to show sensitivity to replay budget (e.g., smaller K) so readers cans ee whether gains depend on a large buffer. A discussion o fmemory/computation scaling with number of tasks would also help.
- External validity to modern pretrained-VLM settings is unclear. The authors note that ReLA is not a pretrained VLM, yet much of the motivation cites CLIP-style large fixed backbones. Results may not transfer to settings where the key constraint is preserving a frozen pretrained encoders zero-shot behavior while adapting a lightweight head.
- MCC treats attention-map concentration as a proxy for grounding confidence, but concentration is not obviously calibrated across object sizes and expression types.. However, for large objects that occupy a significant portion of the frame, a "dispersed" (low std) attention map might be spatially correct. The paper does not address how object scale affects the coherence score.
- The comparison with MOE4CL seems unfair. The authors admit it was adesigned for CLIP and "fails catastrophically" here because of a decoder mismatch they introduced. If the comparison requires "applying the same strategy" to a different architecture where it is known to fail, it doesn't provide a strong benchmark for ADMER's effectiveness. More broadly, several baselines are adapted to a ReLA-based pipeline and the paper provides limited detail on adaptation choices and hyperparameter tuning. Because reported gains are often a few mIoU points, clearer tuning and implementation disclosure would improve confidence in the comparisons.

---

## Minor Weaknesses Prompt

Mention here the weaknesses that are easy to fix in a revision of the paper, such as occasional typographic errors and minor unclear points.

## Minor Weaknesses Response

- The coherence formula introduces a scaling coefficient
  δ to avoid numerical underflow (since MCC and MRC differ in magnitude). It would help to report sensitivity to and clarify which precision (fp16/bf16/fp32) is used, to ensure the ranking is not fragile to numeric choices.
- Performance depends on the balance between MCC and MRC (the paper uses \beta=1.1 and \lambda=0.9). It is unclear how these were selected and whether they generalize across datasets/protocols; a small sensitivity analysis or justification would help.

---

Preliminary Recommendation\*

- [ ] 6: Accept
- [ ] 5: Weak Accept
- [ ] 4: Borderline Accept
- [x] 3: Borderline Reject
- [ ] 2: Weak Reject
- [ ] 1: Reject

---

## Justification For Recommendation And Suggestions For Rebuttal\*

Carefully balance in your answer the strengths and weaknesses to justify your recommendation. Explain to the authors what you would like to see clarified in order to change your opinion about the paper. You may request clarifications, additional illustrations, or small experiments that could be reasonably run within the rebuttal phase with academic resources. You should not request substantial additional experiments for the rebuttal, or penalize for lack of additional experiments. Please see the reviewer guidelines for more details.

## Justification Response

The paper addresses an important gap in multimodal incremental learning, and the use of attention concentration as a replay selector is a sound idea. However, the evaluation setting is too narrow (12 supercategories) to truly demonstrate "continual" learning in an open-world context. More importantly, the decision to use a non-pretrained VLM backbone (ReLA) makes it difficult to compare these results with current SOTA VLM research that prioritizes zero-shot preservation.

**Suggestions for Rebuttal:**

- Drift validation: Show that MCC/MRC (or the combined coherence score) correlates with per-sample IoU error or per-sample forgetting across steps, to support the claim that these signals measure alignment drift rather than being a useful-but-opaque heuristic."
- Clarify how instances are mapped to the 12 supercategories and how ambiguous/multi-object expressions are handled.
- **Scale Analysis:** Provide evidence that the MCC (attention concentration) doesn't penalize large, correctly segmented objects.
- **Scalability:** Discuss how the replay buffer and the coherence selector perform if the number of classes increases to 50 or 100.
- Baseline and protocol clarity: Provide more detail on how CLIP-based continual methods were adapted to the ReLA pipeline, what hyperparameter search was done, and whether conclusions hold across a couple of random seeds. If a full pretrained-VLM experiment is out of scope, add a clear discussion of how results are expected to differ in CLIP-style frozen-encoder settings.
