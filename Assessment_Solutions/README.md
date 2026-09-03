# ✅ Assessment Solutions

Worked solutions for both assessments. Every number in the reports was produced by running the scripts in this folder; nothing is typed in by hand.

## 🎤 Formative assignment (40 marks): presentation

| File | Purpose |
|---|---|
| `presentation/Formative_Assessment_Presentation.pptx` | **The deliverable.** 16 slides (13 content) with speaker notes on every slide |
| `Formative_Assessment_Solution.md` / `.docx` | Slide-by-slide plan: what goes on each slide and what to say |
| `presentation/build_presentation.py` | Rebuilds the deck with `python-pptx` |
| `presentation/img/` | Figures on the slides, drawn in R |

## 📝 Summative assignment (60 marks): report

| File | Purpose |
|---|---|
| `Summative_Assessment_Solution.md` / `.docx` | **The report**: explanation, code, output and interpretation for both tasks |
| `Summative_Task1_Solution.R` | Task 1: histogram function, exploration, regression, stepwise selection, diagnostics, prediction |
| `Summative_Task2_Solution.R` | Task 2: cleaning, EDA, one-way and two-way ANOVA, Tukey HSD, assumption checks, findings |
| `Summative_Task1_Output.txt`, `Summative_Task2_Output.txt` | Console output of the two scripts |
| `plots/` | All 13 figures the scripts produce |

Run the scripts with the working directory set to this folder so the relative paths to the CSV files resolve.

## 🔍 EDA

| File | Purpose |
|---|---|
| `EDA/EDA_Report.md` / `.docx` | Four-layer EDA of both datasets with interpretation and actionable insights |
| `EDA/EDA_Task1_Task2.R` | The analysis script |
| `EDA/EDA_Output.txt`, `EDA/plots/` | Console output and 12 figures |

## 🛠️ Tools

`md_to_docx.py` converts any of the Markdown reports to Word:

```bash
python md_to_docx.py Summative_Assessment_Solution.md
python md_to_docx.py EDA/EDA_Report.md EDA/EDA_Report.docx
```

> **Submission note.** The summative brief asks for RStudio screenshots pasted into the Word file. Run the scripts in RStudio and add screenshots alongside the code and output already in the report.
