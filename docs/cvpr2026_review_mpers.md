# review for mpers paper

Pretend you are a smart phd student with expertise that is relevant to this paper, in computer vision and LLMs, and remote sensing. You are to be skeptical and critical, but fair and also thorough and thoughtful, really trying to only review as is done in a top computer science computer vision conference journal. Attached is the paper, and below is a skeleton of a reviewing framework that is partially filled out. Each section has a title with some text instructions for the reviewer, and then there is a section following that with the same title but suffixed with " Response", followed by my response as the reviewer. Fill out the reviewer response sections that i haven't filled out yet, and add to the ones that I already filled out. Be concise, use very plain language, don't use unnecessary adjectives. Don't take anything the authors in the paper claim for granted, and don't assume they do anything correctly unless they explicitly state it. For example see my point about their choice of the dataset split for the Potsdam dataset. Another LLM assumed that their split was reasonable and common but the authors didn't give detail about it so I flagged it in the weaknesses section.

---

## Paper Summary

Summarize in your own words the paper, its key ideas, its contributions and their significance. This summary will help the AC and the authors understand the rest of your review and be confident that you understand the paper.

## Paper Summary Response

This paper introduces MPerS, a novel multimodal framework for remote sensing segmentation that tackles the issue of low quality captions by employing a Dynamic MixExperts module to integrate text information from VLM experts. Instead of relying on a single source, the authors generate multi-perspective prompts for three different VLMs and dynamically weight their outputs to capture the most useful semantic details for the scene. To merge this data, they integrate a "Linguistic Query Guided Attention" mechanism that fuses these refined text features with visual representations extracted by DINOv3. It is a contribution that demonstrates superior performance over current state-of-the-art methods on standard benchmarks like Potsdam and Vaihingen.

---

## Paper Strengths

List anything that you think could be of interest to readers and explain why. For example:

- What did you learn from the paper?
- Is there a key idea that could inspire others (remember that simple but powerful ideas can be more impactful than overly complicated architectures)?
- Does the paper present significant results that are likely of interest to people in the community?

## Paper Strengths Response

- **Ablation of Caption Quality**: The paper provides a clear comparison between "simple inquiry prompts" and "multi-perspective prompts" in Table 6, demonstrating that more granular prompting of VLMs yields measurable mIoU gains.
- **Modular Architecture**: The framework uses a clean, modular design where the VLM experts, vision backbone (DINOv3), and text encoder (CLIP) are frozen, making the system potentially adaptable to newer models as they are released.
- **Focus on Dense/Small Objects**: The inclusion of a "Lite Detail Prior Encoder" (LDPE) alongside the global features of DINOv3 addresses a known weakness in foundation models regarding fine-grained spatial details.
- **Strong Quantitative Gains**: The method shows significant improvements in the "Car" and "Obstacle" categories across datasets, suggesting the text-guidance is particularly effective for classes with low pixel counts.

---

## Major Weaknesses Prompt

Describe here as carefully as possible the weaknesses that you think could justify a rejection. Major weaknesses include:

The paper does not provide sufficient evidence to support the claims it makes.
The claims made by the paper are not novel. (you have to provide citations)
The claims made by the paper are not meaningful or of possible interest to the community.
Remember that a submission is not required to compare to closed source papers per a recent PAMI-TC motion, or papers that are only on arxiv (per earlier PAMI-TC motion).

## Major Weaknesses Response

- Lack of Explicit Justification for Potsdam dataset split
  - While the authors compare their results to other papers in Table 2 (such as RS3Mamba and SegCLIP), they do not explicitly state that "we follow the standard split defined by [Citation]" or "we use the same subset as [Competitor Paper]." They simply state, "Our work uses 18 images for training and 6 for testing" as a standalone fact. 
  - Can the authors confirm the rationale behind their choice of (1) train/test split, and whether the baselines all use the same splits for training and eval (were the baselines all retrained on the 18-image training set the authors used for mpers?), and (2) the rationale behind only using 18+6=24 images from the dataset of 38 images? Why are 14 images excluded? 
  - The open source torchgeo framework, for example uses all 38 images. The DC-Swin paper uses all 38 images and reports higher mF1 and mIoU than in this paper's Table 2. Other papers including but not limited to UNetFormer, use 24 images for training and the rest for testing, and also report much higher F1/IoU than in Table 2. 
- **Similar Lack of Justification / Details for Other Datsets Used**
  - Vaihingen Dataset: The authors report using only 12 images for training and 4 for testing. However, the standard ISPRS Vaihingen benchmark contains 33 patches, with the official split typically assigning 16 images for training and 17 for testing. Like the Potsdam split, this is a significant, unexplained reduction of the benchmark data.
  - SynDrone Dataset: The paper states it uses 10,080 training tiles and 3,360 testing tiles. In contrast, the original SynDrone dataset provides 72,000 labeled samples (60k train / 12k test). The authors have utilized only a small fraction of this dataset without justifying the selection process or the exclusion of nearly 80% of the available data.
  - The paper provides no explicit statement that the baselines (e.g., RS^3Mamba, SegCLIP, MetaSegNet, etc) were retrained on these specific, non-standard subsets. If the baselines were retrained, the training details are missing. While the authors detail their own training setup (AdamW, batch size 8, learning rate 0.001), they provide no equivalent details for the baselines. IOf they were not retrained the comparisons are invalid since the splits are different.
- Are other settings for the baselines such as crop size also enabling fair comparison (if a different crop size than was used in the original baselines' papers, make a note of it as a potential reason for lower performance on the baselines)? Please provide a full accounting of such.
  - The authors use a fixed crop size of 512 x 512 for all datasets.Many of the cited baselines, such as Swin-B or ResNet-based models, often have different optimal input resolutions. There is no mention of whether baselines were modified to accept 512 inputs or if the MPerS models superior results are partially an artifact of using a higher resolution than the original baseline configurations.
- **Computational Overhead of Caption Generation**: The pipeline requires three different VLMs (LLaVA-1.5-7B, GPT-4o, and Qwen2.5-3B) to generate captions for every image. While the inference time for the segmentation *model* is reported as 55.52ms, this seemingly excludes the time required for VLM captioning. For remote sensing applications involving large-scale tiles, the cost and time of calling these VLMs (especially GPT-4o) could be prohibitive. The authors should clarify if captions are pre-computed or part of the live inference pipeline.
- **Incomplete Comparison with DINOv3 Baselines**: In Table 5, the authors show that LVD weights outperform SAT weights. However, they do not provide a direct comparison between MPerS and a standard "DINOv3 + Linear Head" or "DINOv3 + U-Net" baseline on all three datasets to isolate how much gain comes from the MixExperts vs. simply using a stronger vision backbone.
- **Leakage and VLM Knowledge**: ChatGPT and Qwen were likely trained on natural images and potentially some remote sensing data. There is no discussion on whether these VLMs have seen the test images (or similar aerial imagery) during their own training, which could lead to "perceptual leakage" where the text guidance is providing labels the VLMs already knew.


---

## Minor Weaknesses Prompt

Mention here the weaknesses that are easy to fix in a revision of the paper, such as occasional typographic errors and minor unclear points.

## Minor Weaknesses Response

- Vague "Checking Strategy": The "RS-Scene Caption Sentences Check" uses a similarity threshold of . The paper does not explain how this specific value was chosen or how sensitive the model is to this threshold.
- What metric is being reported in Table 5? Please ensure the same info is clear for all tables and figures.
- Inference Time Specifics: Table 7 lists an inference time of 55.52ms for MPerS but does not specify the hardware used for the baselines, making the comparison less rigorous.

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

The paper proposes a technically sound method for utilizing the reasoning capabilities of multiple VLMs to improve remote sensing segmentation. The results on small object categories are impressive. However, the lack of clarity regarding the dataset split for Potsdam, specifically why only 24 of 38 images were used and whether the baselines were trained/evaluated on the same subsets, is a major concern for reproducibility and fairness. Why are the results so much lower than those reported in the baseline papers? Additionally, the practical utility is questioned by the unaddressed latency and cost of running three separate high-parameter VLMs for captioning. Also, see the concerns above about the other settings for the baselines such as crop sizes.

**Suggestions for Rebuttal**:

1. **Split Clarification**: Explicitly state which images (by ID) were used in the 18/6 split and provide evidence that baselines were evaluated on this exact same data.
2. **End-to-End Latency**: Provide the total time required for a single 512x512 patch including VLM caption generation.
3. **Baseline Isolation**: Provide an ablation showing DINOv3-LVD + U-Net (without any text/MixExperts) to clearly show the "Delta" provided by the proposed module.
4. **Threshold Sensitivity**: Briefly show how varying the  threshold (e.g., 0.45 to 0.65) affects the final mIoU.

