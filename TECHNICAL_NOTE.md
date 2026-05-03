## Technical Note: PDF-Grounded Q&A System

### Overview
This is a *retrieval-augmented question answering (RAG)* application for PDFs. It prioritizes *grounding, traceability, and evaluator visibility* over raw generative flexibility, ensuring answers are strictly based on the uploaded document with exact page-level citations.

---

### Architecture
The system is divided into four main layers:
1. **Frontend (Chainlit)**: Handles PDF upload, streaming chat interaction, and citation display.
2. **Backend Orchestration (Haystack)**: Explicitly manages the ingestion and query pipelines.
3. **Retrieval Stack**: Uses **Docling/MinerU** for layout-aware PDF parsing and `multilingual-e5-large-instruct` for semantic retrieval via vector search.
4. **Observability Layer**: Integrates LangFuse, RAGAS, and Arize Phoenix for comprehensive tracing and evaluation.

---

### Key Design Decisions
*   **Explicit RAG Pipeline**: Keeps answers fully grounded and makes failure modes easy to inspect.
*   **Page-Aware Chunking**: Each chunk carries page/section metadata to generate exact, verifiable citations.
*   **Two-Stage Confidence Control**: Combines a pre-generation retrieval threshold filter with post-generation LLM verification to eliminate hallucinations.
*   **Trace-First Observability**: Every query is fully traceable end-to-end to build evaluator trust.

---

### Tradeoffs
*   **Accuracy vs Latency**: Grounding verification drastically improves reliability but adds 1-2 seconds of response time.
*   **Structured Parsing vs Simplicity**: Docling produces superior extraction for tables and columns but makes the pipeline heavier than basic PyPDF text extraction.
*   **Strict Refusal vs Coverage**: The system safely refuses borderline questions rather than speculating. This reduces hallucinations but can occasionally feel restrictive.

---

## Test Instructions for Evaluators

**Goal**: Verify accurate grounded answering, proper refusal logic, citation accuracy, and consistent cross-lingual behavior.

### Test Procedure
1.  **Upload**: Use the provided sample PDF (e.g. *Attention Is All You Need*).
2.  **Valid Queries**: Ask grounded questions (e.g., “What is the architecture of the Transformer model?”). 
    * *Verify*: The answer is relevant, claims are supported, and citations point to correct pages.
3.  **Invalid Queries**: Ask out-of-scope questions (e.g., “What is the capital of France?” or "How do I fine-tune GPT-4?"). 
    * *Verify*: The system explicitly refuses and does not hallucinate.
4.  **Inspect Citations**: Confirm that the cited page numbers match the factual claims in the answer.
5.  **Optional Multilingual Test**: Upload a non-English PDF or ask a cross-lingual question to confirm the system's language capabilities.