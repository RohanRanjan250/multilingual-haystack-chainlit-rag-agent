# 📄 PDF-Constrained Conversational Agent

A robust RAG-based agent that chats with your PDF documents while strictly adhering to the source content. Built with **Haystack 2.0**, **Chainlit**, and **IBM Docling**.

## ✨ Features
*   **Strict Grounding**: Only answers based on the uploaded document. Hallucinations are blocked by a dual-verification grounding engine.
*   **Layout-Aware Parsing**: Uses Docling to correctly handle multi-column text and tables.
*   **Page-Level Citations**: All answers include references to specific pages in the sidebar.
*   **Multilingual Support**: Fallback to MinerU for high-quality CJK and multilingual document parsing.
*   **Graceful Refusal**: Explicitly identifies and refuses out-of-scope queries.

## 🚀 Quick Start

### 1. Setup Environment
```bash
bash setup.sh
```

### 2. Configure API Key
Create a `.env` file in the root directory:
```env
DEEPSEEK_API_KEY=your_api_key_here
```

### 3. Run Application
```bash
source venv/bin/activate
chainlit run app.py
```

## 🧪 Testing Instructions
1.  **Upload**: Use the `demo/sample_document.pdf` (GPT-4 Technical Report).
2.  **Verify Grounding**: Ask "How does GPT-4 perform on the Bar Exam?".
3.  **Verify Refusal**: Ask "What is the best way to cook pasta?".
4.  **Check Citations**: Observe the sidebar for page references after every valid answer.

## 📁 Project Structure
*   `app.py`: Main Chainlit application.
*   `core/`: Core logic for grounding, parsing, and retrieval.
*   `pipelines/`: Haystack 2.0 pipeline definitions.
*   `evaluation/`: Test queries and evaluation metrics.
*   `demo/`: Sample documents for testing.

## 📝 Technical Note
See [TECHNICAL_NOTE.md](TECHNICAL_NOTE.md) for architectural details and design decisions.
