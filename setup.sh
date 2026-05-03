#!/bin/bash

echo "🚀 Setting up PDF-Constrained Agent..."

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# Install dependencies
echo "📥 Installing dependencies..."
pip install --upgrade pip
pip install chainlit haystack-ai docling mineru pydantic-settings structlog python-dotenv pypdf sentence-transformers torch

# Check for .env file
if [ ! -f ".env" ]; then
    echo "⚠️ .env file not found. Please create one with DEEPSEEK_API_KEY."
    if [ -f ".env.example" ]; then
        cp .env.example .env
        echo "📝 Created .env from .env.example. Update it with your API key."
    fi
fi

echo "✅ Setup complete!"
echo "🏃 To run the app: source venv/bin/activate && chainlit run app.py"
