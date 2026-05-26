# review for mpers paper

Pretend you are a smart phd student with expertise that is relevant to this paper, in computer vision and LLMs, and remote sensing. You are to be skeptical and critical, but fair and also thorough and thoughtful, really trying to only review as is done in a top computer science computer vision conference journal. Attached is the paper, and below is a skeleton of a reviewing framework that is partially filled out. Each section has a title with some text instructions for the reviewer, and then there is a section following that with the same title but suffixed with " Response", followed by my response as the reviewer. Fill out the reviewer response sections that i haven't filled out yet, and add to the ones that I already filled out. Be concise, use very plain language, don't use unnecessary adjectives. Don't take anything the authors in the paper claim for granted, and don't assume they do anything correctly unless they explicitly state it.

---

## Comparison Text

Compare your review with the one I came up with, which is pasted below. Generate a "diff" style output that tells me what edits/additions/removals (and where to make them) to close the gap between yours and mine. Don't make it a literal code style diff, just in the sense of tell me where our revviews differ, and suggest the edit i should make to mine ("remove this sentence/section...", "replace this with this....", "add this after the third bullet in this section"). For each one give a bried description of why the edit is necessary unless it is obvious without explanation. Check my review for correctness, and if the feedback I am giving is correct and fair.

---

## Second Check Prompt

Here is my updated review. I made some edits to your version. Please check this against the paper and make sure this is a fair review. all the points I raise are valid, and fair, and factually correct (make sure I am not asking for things that are "missing" that are actually mentinoed in the paper, that i am not making any misunderstandings of the paper, etc.


---

## Review title

## A useful step toward album-level VLM evaluation, but the current benchmark/evaluation pipeline is under-specified and somewhat confounded.

## Paper Summary

Summarize in your own words the paper, its key ideas, its contributions and their significance. This summary will help the AC and the authors understand the rest of your review and be confident that you understand the paper.

## Paper Summary Response

The paper introduces AlbumBench, a benchmark designed to evaluate Vision-Language Models (VLMs) on their ability to organize personal photo albums. Unlike existing multi-image benchmarks that use a handful of images or video frames with high temporal consistency, AlbumBench uses albums of 30-100 images that represent time-bounded life events. The authors define four specific tasks: Intent Selection, Intent Rating, Group Labeling, and Group Clustering.

The paper evaluates models under two context modes: (i) a visual-context setting where the model is given all images from the album, and (ii) a language-context setting where the model is given an album level caption plus a single image with some tasks being reformulated under this setting. The dataset split also includes two held-out event types (31 albums) intended for future open-set evaluation.

The benchmark utilizes 27,051 images from the CUFED dataset across 641 albums. Findings indicate that while proprietary models generally outperform open ones, performance is often close to a caption based pipeline, suggesting models may not reliably benefit from long visual context in this benchmark.. Furthermore, models often fail to follow structured output instructions, requiring secondary LLMs to "fix" their responses for evaluation.

The paper also notes that prompts were specialized per model and that processing raw outputs would yield poor results without this pipeline, which complicates attribution of the reported scores to the evaluated model alone.

## Paper Strengths

List anything that you think could be of interest to readers and explain why. For example:

- What did you learn from the paper?
- Is there a key idea that could inspire others (remember that simple but powerful ideas can be more impactful than overly complicated architectures)?
- Does the paper present significant results that are likely of interest to people in the community?

## Paper Strengths Response

- **Practical Task Alignment**: The benchmark addresses the real-world problem of managing the high volume of smartphone photos, which is more grounded in user utility than abstract reasoning tasks.
- **Long-Context Evaluation**: By using 30-100 images per album, it pushes VLMs far beyond the 4.3 image average seen in prior benchmarks like MuirBench, testing the limits of multi-image context windows.
- **Rigorous Baselines**: The inclusion of a "Caption Baseline" is a critical sanity check. It reveals a significant weakness in current VLMs: they often perform just as well using only text captions as they do when provided with actual image pixels, suggesting the evaluation may be dominated by language representations or that models underuse long visual context here.
- **Ablation of "Thinking" Models**: Comparing "instruct" versions against "thinking" or reasoning-heavy versions provides useful data on how much inference-time compute helps with complex grouping logic.
- **Documents practical failure modes**: The paper reports common structured-output failures (invalid JSON; overlapping groups; missing image assignments), which is useful both for practitioners and for interpreting what the benchmark is really measuring.
- **Clear task framing and diagnostic setup**: The paper defines concrete album organization tasks and explicitly compares visual context of all album images versus language context (album caption + single image), which is a useful probe of whether models actually use extra visual context.

---

## Major Weaknesses Prompt

Describe here as carefully as possible the weaknesses that you think could justify a rejection. Major weaknesses include:

The paper does not provide sufficient evidence to support the claims it makes.
The claims made by the paper are not novel. (you have to provide citations)
The claims made by the paper are not meaningful or of possible interest to the community.
Remember that a submission is not required to compare to closed source papers per a recent PAMI-TC motion, or papers that are only on arxiv (per earlier PAMI-TC motion).

## Major Weaknesses Response

- **Pipeline attribution problem from post-processing**: The authors use Gemini 2.5 Flash as a secondary post-processor to repair invalid JSON/formatting. This creates an attribution problem: the reported scores reflect a pipeline (prompting + repair), not just the evaluated model. The paper should report (i) raw parsing-failure rates per model, (ii) score deltas with vs. without repair, and (iii) evidence (e.g., a manual audit on a small sample) that the repair is strictly format-only and does not change selections or group assignments.
- **Model-specific prompting reduces comparability and reproducibility**: The paper states prompts were specialized per model and that processing raw outputs would yield poor results. Without a standardized prompting protocol and clearer reporting of prompt differences, comparisons may partially reflect prompt engineering effort rather than model capability.
- **Reliance on a Dated Source Dataset**: The images are sourced from the CUFED dataset (2016). Photo-taking habits, image quality, and even the semantic "intent" of photography have evolved significantly in the last decade. This may reduce representativeness for current smartphone photo distributions, and the paper should either justify why this source remains appropriate or include a small contemporary validation set.
- **Ambiguous Task Distinction**: The distinction between "Intent Selection" and traditional "Visual Retrieval" is thin. The paper argues that user intent introduces a different framing than standard retrieval, but the authors argue "intent" is unique, the evaluation metrics (F1, Precision, Recall, mAP) are identical to standard retrieval tasks. it remains unclear whether the task is really new or mainly standard retrieval applied to a specific domaina clearer set o fqualitative counterexamples would help
- **Impractical Computational Costs**: The authors acknowledge that "thinking" models are too slow and power-hungry for practical use. The paper suggests thinking variants can improve results but may be too slow/resource-intensive for many product settings; the cost/performance trade-off should be quantified more concretely (e.g., latency or compute per album alongside accuracy).
- **Caption baseline is not a clean "no-vision" baseline**: The "caption baseline" still uses visual information distilled by a strong captioning model (Gemini-2.5-Pro) to generate image/album captions. This can inflate the baseline and complicate the conclusion that "pixels don't help," because the baseline is effectively "strong VLM -> text representation" rather than truly vision-free input.
- The decision to artificially suppress the thinking budgets of proprietary models like GPT-5 and Gemini2.5 to resemble Instruct models creates an artificial ceiling on the benchmark's reported SOTA. This limits the paper's ability to show the true performance potential of current long-context models on these tasks.

---

## Minor Weaknesses Prompt

Mention here the weaknesses that are easy to fix in a revision of the paper, such as occasional typographic errors and minor unclear points.

## Minor Weaknesses Response

- **Visualization Issues**: Figure 2 uses a radar chart to compare models across 7 axes. These charts are difficult to read for precise metric comparison; a standard bar chart or a more detailed table in the main text would be more effective.
- **language-context changes the task**: Visual vs language comparisons are confounded by task reformulation: In the language-context setting, some tasks are reduced to per-image decisions using an album caption + single image. This changes the problem definition relative to the visual-context setting (joint reasoning over the full album), making it hard to interpret "language vs visual" gaps as purely a modality/context-window effect.
- Summarize the post-processing contract in the main paper: Even if details are in the supplement, the main text should state what the post-processor is allowed to modify (format-only vs. content).

---

Preliminary Recommendation\*

- [ ] 6: Accept
- [ ] 5: Weak Accept
- [ ] 4: Borderline Accept
- [ ] 3: Borderline Reject
- [ ] 2: Weak Reject
- [ ] 1: Reject

---

## Justification For Recommendation And Suggestions For Rebuttal\*

Carefully balance in your answer the strengths and weaknesses to justify your recommendation. Explain to the authors what you would like to see clarified in order to change your opinion about the paper. You may request clarifications, additional illustrations, or small experiments that could be reasonably run within the rebuttal phase with academic resources. You should not request substantial additional experiments for the rebuttal, or penalize for lack of additional experiments. Please see the reviewer guidelines for more details.

## Justification Response

My recommendation is a Borderline Reject. While the paper identifies a legitimate and under-explored gap in VLM evaluation, i.e., the transition from single images/videos to sparse/high-context photo albums, the methodology has significant issues.

Specifically, using a secondary LLM (Gemini-2.5-Flash) to repair outputs creates an attribution problem unless the paper reports raw failure rates, score deltas with/without repair, and evidence that the repair is format-only and does not change the semantic content of outputs. Furthermore, using a decade-old source dataset (CUFED) limits the relevance of the findings for modern photography workflows.

**Suggestions for Rebuttal**:

- Annotation protocol and ambiguity: Clarify who annotated, how queries/groupings were authored, how multiple annotations are aggregated, and provide a basic agreement/ambiguity statistic (even on a subset).
- **Raw Performance Data**: Provide the metrics without the Gemini post-processing to show the true "failure to follow instructions" rate of these models.
- **Dataset Modernization**: Explain why CUFED is still representative of 2025/2026 photography, or provide a small-scale validation set using contemporary photos.
- **Task Novelty**: Better differentiate "Intent Selection" from standard "semantic retrieval" through more qualitative examples where standard retrieval would fail but AlbumBench succeeds.
- _Post-processing semantic audit_: Provide a small manual audit showing that Gemini-Flash repairs are format-only (do not change selected images, ratings, or group assignments), or provide a deterministic format-repair alternative.
