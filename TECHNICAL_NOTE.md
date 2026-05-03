# Technical Note: PDF-Constrained Conversational Agent

## Architecture
The system is built on a modular RAG (Retrieval-Augmented Generation) architecture using **Haystack 2.0** and **Chainlit**.

1.  **Ingestion Pipeline**:
    *   **Parsing**: Uses **IBM Docling** for layout-aware PDF parsing, preserving tables and reading order. **MinerU** is integrated as a fallback for complex multilingual (CJK) documents.
    *   **Chunking**: Recursive character-based splitting with sentence overlap to maintain context.
    *   **Embedding**: `intfloat/multilingual-e5-large-instruct` model for state-of-the-art multilingual retrieval.
    *   **Storage**: `InMemoryDocumentStore` for fast, zero-config testing and evaluation.

2.  **Query Pipeline**:
    *   **Retrieval**: Semantic search with a configurable similarity threshold (default 0.65).
    *   **Refusal**: A dedicated `RefusalHandler` blocks queries that fall below the similarity threshold or are deemed out-of-scope.
    *   **Grounding**: A dual-stage verification process:
        *   *Pre-generation*: Similarity check.
        *   *Post-generation*: LLM-based fact verification using a separate prompt to ensure every claim is supported by the retrieved context.

## Design Decisions
*   **Docling Primary Parser**: Selected for its superior ability to handle multi-column layouts and tables compared to traditional parsers like PyPDF.
*   **Dual-Stage Grounding**: Crucial for the "strict grounding" requirement. Instead of just relying on the system prompt, the system explicitly verifies the answer against the source text.
*   **Chainlit Sidebar Citations**: Used to provide a non-intrusive way for users to verify page numbers and excerpts.

## Trade-offs
*   **Latency vs. Accuracy**: Post-generation LLM verification adds ~1-2 seconds of latency but drastically reduces hallucinations, fulfilling the requirement for robust grounding.
*   **In-Memory Store**: Optimized for the single-document use case. While not persistent, it allows for instant indexing upon upload.

## Test Instructions
1.  **Environment Setup**:
    *   Ensure Python 3.10+ is installed.
    *   Run `bash setup.sh` to install dependencies.
    *   Set your `DEEPSEEK_API_KEY` in a `.env` file.
2.  **Running the App**:
    *   Execute `chainlit run app.py`.
3.  **Testing**:
    *   Upload the provided `demo/sample_document.pdf`.
    *   Use the queries in `evaluation/test_queries.json` to verify grounding and refusal behavior.
