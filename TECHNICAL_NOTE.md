## Technical Note: PDF-Grounded Q&A System

### Overview
This system is a *retrieval-augmented question answering (RAG)* application for PDFs. Users upload a PDF, ask questions in chat, and receive answers grounded in extracted document passages with page-level citations. The design prioritizes *grounding, traceability, and evaluator visibility* over raw generative flexibility.

---

### Architecture
The system is split into four layers:

1.⁠ ⁠*Frontend — Chainlit*
   - Handles PDF upload, chat interaction, streaming responses, and citation display.
   - Chosen for fast delivery and native support for AI chat UX.

2.⁠ ⁠*Backend Orchestration — Haystack*
   - Manages ingestion and query pipelines explicitly.
   - Ingestion: PDF → parser → chunker → embeddings → vector store.
   - Querying: question → embedding → retrieve → rerank → generate → verify → cite.

3.⁠ ⁠*Document + Retrieval Stack*
   - *Docling / MinerU* for layout-aware PDF parsing.
   - *multilingual-e5-large-instruct* embeddings for semantic retrieval.
   - *Qdrant* or in-memory store for vector search.

4.⁠ ⁠*Quality / Observability Layer*
   - *LangFuse* for tracing and latency/cost inspection.
   - *RAGAS* for automated RAG evaluation.
   - *Arize Phoenix* for embedding-space debugging and retrieval analysis.

---

### Key Design Decisions
•⁠  ⁠*Explicit RAG pipeline instead of free-form prompting*  
  This keeps answers grounded in source text and makes failure modes easier to inspect.

•⁠  ⁠*Page-aware chunking and citations*  
  Each chunk carries page and section metadata so answers can cite exact sources.

•⁠  ⁠*Two-stage confidence control*
  1. retrieval threshold
  2. grounding verification  
  This reduces hallucinations and enables safe refusal when evidence is weak.

•⁠  ⁠*Multilingual support from the start*
  Using multilingual embeddings and a multilingual-capable parser allows cross-lingual retrieval and answering.

•⁠  ⁠*Trace-first observability*
  Every query can be inspected end-to-end, which is important for debugging and evaluator trust.

---

### Tradeoffs
•⁠  ⁠*Accuracy vs latency*  
  Adding reranking and grounding verification improves reliability but increases response time.

•⁠  ⁠*Structured parsing vs simplicity*  
  Docling/MinerU produce better layout-aware extraction than basic PDF text extraction, but the pipeline is more complex.

•⁠  ⁠*Open-source stack vs operational overhead*  
  The design avoids vendor lock-in, but requires more setup and maintenance than a single managed platform.

•⁠  ⁠*Strict refusal policy vs answer coverage*  
  The system may refuse some borderline questions rather than speculate, which is safer but can feel less helpful.

•⁠  ⁠*Traceability vs implementation complexity*  
  Full tracing, evaluation, and debugging layers improve confidence but add engineering surface area.

---

### Why this architecture is appropriate
This design is optimized for *grounded QA over a bounded document corpus*. It is not a general-purpose chatbot. The emphasis is on:
•⁠  ⁠correctness over creativity,
•⁠  ⁠citations over fluency,
•⁠  ⁠refusal over hallucination,
•⁠  ⁠and measurable quality over hidden behavior.

---

## Test Instructions for Evaluators

### Goal
Verify that the system:
1.⁠ ⁠answers correctly when evidence exists,
2.⁠ ⁠refuses when evidence is absent,
3.⁠ ⁠cites the uploaded PDF accurately,
4.⁠ ⁠behaves consistently across questions and languages.

### Test Procedure
1.⁠ ⁠*Upload the sample PDF*
   - Use the provided test document, e.g. Attention Is All You Need.

2.⁠ ⁠*Ask valid grounded questions*
   Example queries:
   - “What is the architecture of the Transformer model?”
   - “How many attention heads were used in the base model?”
   - “What BLEU scores did the Transformer achieve?”

   *Check that:*
   - the answer is relevant,
   - claims are supported by the document,
   - citations point to correct pages/sections.

3.⁠ ⁠*Ask invalid or out-of-scope questions*
   Example queries:
   - “What is the capital of France?”
   - “How do I fine-tune GPT-4?”
   - “What are the authors’ hobbies?”

   *Check that:*
   - the system refuses,
   - it explains the question is not answerable from the PDF,
   - it does not fabricate content.

4.⁠ ⁠*Inspect citations*
   - Verify that each cited page or section matches the claim in the answer.
   - Prefer answers where each factual statement is traceable.

5.⁠ ⁠*Check retrieval/debug panel*
   - Confirm the system retrieved relevant chunks.
   - If available, inspect scores and grounding status.

6.⁠ ⁠*Optional multilingual test*
   - Upload a non-English PDF or ask a cross-lingual question.
   - Confirm retrieval and answering still work.

---